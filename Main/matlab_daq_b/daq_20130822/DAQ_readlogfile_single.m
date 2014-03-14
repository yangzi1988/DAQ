
function DAQ_readlogfile_single(fullfilename,targetsamplerate)

fullfilename

warning off all;

[pathname,filename,fileextension] = fileparts(fullfilename);

fprintf('filename: %s\n',filename);


% ============================================
% ============================================
% ** DEFAULTS **
ADCSAMPLERATE = 1e6;
ADCvref = 2.42;
ADCbits = 14;

SETUP_TIAgain = 100e6;
SETUP_preADCgain = 0.5; 
SETUP_pAoffset = 0;
SETUP_mVoffset = 0;

vn = 1e-9;
DAC12value = -100;
DAC34value = -100;
bias1value = -100;
bias2value = -100;

% LOAD DATA FILE
datafilename = fullfile(pathname,[filename '.mat']);
if(exist(datafilename) > 0)
    load(datafilename);
else
    disp('****************************************');
    disp('ERROR: No corresponding .mat file found.');
    disp('****************************************');
end

%TEMP   CHIPSETUP_butterworth2 = 312e3;

%TEMP 
%CHIPSETUP_boardgain = 1000
% TEMP CHIPSETUP_preADCgain = 2


samplerate = ADCSAMPLERATE;
TIAgain = SETUP_TIAgain;
preADCgain = SETUP_preADCgain;
currentoffset = SETUP_pAoffset;
voltageoffset = SETUP_mVoffset;
ADCvref = SETUP_ADCVREF;
ADCbits = SETUP_ADCBITS;

fprintf('samplerate = %f \n',samplerate);
fprintf('TIAgain = %e \n',TIAgain);
fprintf('preADCgain = %e \n',preADCgain);
fprintf('currentoffset = %e \n',currentoffset);
fprintf('voltageoffset = %e \n',voltageoffset);
fprintf('DAC12value = %e \n',DAC12value);
fprintf('DAC34value = %e \n',DAC34value);
fprintf('bias1value = %e \n',bias1value);
fprintf('bias2value = %e \n',bias2value);

% ============================================
% ============================================

%samplerate=50e3;

logdata = [];

%[filename, pathname, filterindex] = uigetfile([filefilter '*.log'], 'pick log files','MultiSelect','on');

% subsample
subsample=1;
samplerate = samplerate / subsample;
    
    %readfid = fopen(fullfile(pathname, [filename '.log']),'r');
    readfid = fopen(fullfilename,'r');
    
    %right-justified
    %logdata = -ADCvref + (2*ADCvref) * double(mod(fread(readfid,'uint16'),2^ADCbits)) / 2^ADCbits;   % get rid of OTR bit and scale to 2*VREF
    
    %left-justified
    bitmask = (2^16 - 1) - (2^(16-ADCbits) - 1);
    rawvalues = fread(readfid,'uint16');
    readvalues = bitand(cast(rawvalues,'uint16'),bitmask);
    logdata = -ADCvref + (2*ADCvref) * double(readvalues) / 2^16;
    
    clear readvalues;
    
    triggermask = 2^0 + 2^1
    triggervalues = boolean(bitand(rawvalues,triggermask));
    
    %logdata = resample(logdata,1,subsample);
    %size(logdata)
    fclose(readfid);

    clear rawvalues;

    

    colors = 'br';

    % =======================================================
    % =======================================================

    scrsz = get(0,'ScreenSize');
    logfigure = figure('Position',[scrsz(3)/10 scrsz(4)/10 scrsz(3)*0.8 scrsz(4)*0.8]);
    plotydim = 2;
    plotxdim = 4;
    fftplotposition = [1 2 3 4];
    timeplotposition1 = [5 6 7];
    histogramplotposition1 = 8;
    %timeplotposition2 = [9 10 11];
    %histogramplotposition2 = 12;
    
    % =======================================================
    % =======================================================


    fftpoints = 2^16;



    
        [outputpsd,f] = pwelch(logdata-mean(logdata),[],floor(fftpoints*0.5),fftpoints,samplerate);
        %maxF=max(f)
        
        % ---------------
        %remove DC term
        f = f(2:length(f));
        outputpsd = outputpsd(2:length(outputpsd));
        % ---------------

        sqrtoutputpsd = sqrt(outputpsd);

        outputvn2 = cumtrapz(f,outputpsd);
        outputrms = sqrt(outputvn2);


        %closedloop_gain = nanopore_gain_calculation1(Cp,Cz,Rdc,preADCgain);
        closedloop_gain = TIAgain*preADCgain;
        
        
        
        inputpsd = outputpsd ./ (closedloop_gain.^2);
        %sqrtinputpsd = sqrtoutputpsd ./ closedloop_gain;
        inputrms = outputrms ./ closedloop_gain;

  

        fc = 1e6;
        w = f./fc*pi;
        Hbessel4 = 105 ./ sqrt( w.^8 + 10*w.^6 + 135.*w.^4 + 1575*w.^2 + 11025 );
        
        %extra pole with 36*2//470pF = 4.7MHz
        antialiasfilter = Hbessel4 ./ (1 + (f./4.7e6).^2);
        inputpsd = inputpsd ./ (antialiasfilter.^2);
        
        %{
        figure; loglog(f,Hbessel4);
        %}
        
        %{
        CHIPSETUP_butterworth3 = 400e3;
        antialiasfilter = sqrt( 1 ./ (1 + (f./CHIPSETUP_butterworth3).^6) );
        inputpsd = inputpsd ./ (antialiasfilter.^2);
        %}

            % ==========================
            % fit frequency domain
            fit_f = f( 1 : length(f)*400e3/max(f) );

            inputpsdtimesf = inputpsd(1:length(fit_f)).*fit_f;
            fitweights = 1./(fit_f.*inputpsdtimesf);
            freqcoeffs = JKRweightedpolyfit(fit_f, inputpsdtimesf, 3, fitweights);
            freqcoeffs = abs(freqcoeffs);

            %-----------------
            %KILL LINEAR TERM
            %freqcoeffs(2) = 0;
            %-----------------
            freqbestfit = polyval(freqcoeffs,f)./f;
       
        
            figure(logfigure);
            subplot(plotydim, plotxdim, fftplotposition);
            loglog(f,inputpsd.*(Hbessel4.^2).*1e24,'k');
            hold on;
            loglog(f,inputpsd*1e24,'-b');
            plot(f,1e24*freqbestfit,'--k','LineWidth',2);
            
            plot(f,1e24*polyval([freqcoeffs(1) 0 0 0],f)./f,'-r');
            plot(f,1e24*polyval([0 freqcoeffs(2) 0 0],f)./f,'-r');
            plot(f,1e24*polyval([0 0 freqcoeffs(3) 0],f)./f,'-r');
            plot(f,1e24*polyval([0 0 0 freqcoeffs(4)],f)./f,'-r');
            
            % -----------

            
        
        % ==========================
        

        % ================
        %
        figure;
        loglog(f,inputrms*1e12);
        %hold on;
        xlabel('Frequency (Hz)');
        ylabel('Input referred integrated noise current pA_{RMS}');
        grid on;
        grid minor;
        %
        % ================
        
    
        % =======================================================
        % =======================================================

        max_points_to_plot = 8e6;
        %timeplotoffset = 3; %sec

        targetsamplerate1 = 1e6;
        resampleratio1 = floor(samplerate/targetsamplerate1);
        outputsamplerate1 = samplerate / resampleratio1

        targetsamplerate2 = 100e3;
        resampleratio2 = floor(samplerate/targetsamplerate2);
        outputsamplerate2 = samplerate / resampleratio2

        
        points_to_use = min(length(logdata),max_points_to_plot*(min(resampleratio1,resampleratio2)));
        
        
        originaldata = -logdata(1:points_to_use)./max(closedloop_gain) + currentoffset;
        %originaldata = -logdata;
        
        %====================
        % SIMPLE COMPENSATION FOR DC ATTENUATION
        %originaldata = originaldata + 9*mean(originaldata);
        %originaldata = originaldata./max(closedloop_gain);
        %Idc = mean(originaldata);
        %====================
        
        
        %originaldata = medfilt1(originaldata,3,1024);
        
        
        resampleddata1 = resample(originaldata,1,resampleratio1,128);
        resampleddata2 = resample(originaldata,1,resampleratio2,128);        
        %resampleddata = resampleddata( 100:(length(resampleddata)-100) );

        
        % =====================================
        % COMPENSATION FOR DC ATTENUATION
        %filtereddata = resampleddata + 9*mean(resampleddata);
        %filtereddata = resampleddata;
        
        
        Idc = mean(resampleddata1);
        %
        %filtereddata = resampleddata;
        %Idc = mean(filtereddata);
        % =====================================
        
        
        % ============
        
        %resampled_samplerate = outputsamplerate;
        %save(datafilename,'resampleddata','resampled_samplerate','-APPEND');
        
        % ============
        
        
        
        
        %resampleddata = resample(originaldata,1,resampleratio,128);

        
        
        bincount = 2^10;
        
        [histocount,bincenters] = hist(resampleddata1.*1e9,bincount);
        histocount = histocount * bincount/length(resampleddata1);

        
        
        %figure(originaltime);
        %plot(t(1:len2plot),originaldata(1:len2plot),['.-' colors(m+1)]);

        %figure(resampledtime);

        figure(logfigure);
        
        
        subplot(plotydim, plotxdim, histogramplotposition1);
        %plot(bincenters,histocount,['.' colors(m+1)]);
        barh(bincenters,histocount,'FaceColor','b');
        hold on;
        fitcolors = ['kkkrmkg'];
        binsize = bincenters(2)-bincenters(1);
        


        subplot(plotydim, plotxdim, timeplotposition1);
        %indexoffset = timeplotoffset*resampleratio
        plot((1:length(resampleddata1))/samplerate * resampleratio1*1e3,resampleddata1.*1e9,'-b');
        hold on;
        plot((1:length(resampleddata2))/samplerate * resampleratio2*1e3,resampleddata2.*1e9,'-r');
        %plot(t,originaldata.*1e9,['-' colors(m+1)]);

        %plot((1:length(resampleddata1))/samplerate*1e3,triggervalues(1:length(resampleddata1)),'.k');
        
        triggerindexes = find(triggervalues>0)
        plot(triggerindexes./samplerate*1e3,zeros(size(triggerindexes)),'r^','MarkerSize',10)
        
        
        %==========================
        %{
        figure;
        loglog(f,outputpsd);
        %hold on;
        %plot(f,f./f*((1.65 * 0.5^12)^2 / (12*samplerate)),'r');
        %plot(f,f./f*((1.65 * 0.5^12)^2 / (samplerate)),'r');
        %plot(f,abs(closedloop_gain));
        %}
        %=========================
    

        figure(logfigure);
         subplot(plotydim, plotxdim, fftplotposition);
         xlabel('Frequency (Hz)');
         ylabel('Input-referred (pA^2/Hz)');
         %title(sprintf('%s - Ci=%g',filename,CHIPSETUP_Ci),'interpreter','none');
         title(sprintf('%s',filename),'interpreter','none');
         grid on;
         grid minor;
         axis([min(f) max(f) min(inputpsd)*1e23 max(inputpsd)*1e25]);

        subplot(plotydim, plotxdim, histogramplotposition1);       
        %xlabel('Current (nA)');
        %ylabel('Count');

        %subplot(plotydim, plotxdim, histogramplotposition2);       
        %xlabel('Current (nA)');
        %ylabel('Count');

        subplot(plotydim, plotxdim, timeplotposition1);
        xlabel('Time (milliseconds)');
        ylabel('Signal Current (nA)');
        
        %subplot(plotydim, plotxdim, timeplotposition2);
        %xlabel('Time (sec)');
        %ylabel('DC Current (nA)');

    % =======================================================
    % =======================================================
    

    % =====================================================================
    
    fprintf('\n');
    fprintf('Idc=%g \n',Idc);
    fprintf('\n');

    squareterm = freqcoeffs(1);
    linearterm = freqcoeffs(2);
    constantterm = freqcoeffs(3);
    flickerterm = freqcoeffs(4);

    fprintf('f^2 term: %g \n', squareterm);
    fprintf('f term: %g \n', linearterm);
    fprintf('constant term: %g \n', constantterm);
    fprintf('1/f term: %g \n', flickerterm);

    % shot noise:  I^2/Hz = 2qI
    q = 1.602e-19;
    expectedshotnoise = 2*q*abs(Idc);
    fprintf('Expected shot noise: %g \n', expectedshotnoise);

    % thermal noise:    I^2/Hz = 4*k*T/R
    k = 1.38e-23;
    T = 295;
    residualthermalnoise = sqrt(constantterm^2-expectedshotnoise^2);
    R_noisefit = 4*k*T / (residualthermalnoise);
    fprintf('Residual thermal noise: %g \n', residualthermalnoise);
    fprintf('Calculated thermal resistance: %g \n', R_noisefit);


    % flicker noise:    


    % capacitive noise:  I^2/Hz = vn^2 * (2*pi*f)^2 * C^2
    C_noisefit = sqrt( squareterm / (vn^2 * 4*pi^2) );
    fprintf('Calculated Cparasitic: %e \n', C_noisefit);


    subplot(plotydim, plotxdim, fftplotposition);
    text(200e3, 1e24*inputpsd(floor(length(f)*200e3/max(f)))/100,sprintf('Cp=%4.2fpF \n', C_noisefit*1e12));

    % =====================================================================



    picturefilename = fullfile(pathname,[filename '.jpg']);
    saveas(gcf,picturefilename,'jpg');
    %pause(2);
    %close(gcf);
    
    % =======================================================
    % =======================================================
    
    
    
    
    
    
    
    