
function returnval = DAQ_process_triggers(obj, event, handles)

    PRINT_TIMES=0;
    %process_triggers_flag=1

    DAQ_constants_include;
       
    updatetriggerouts(handles.xem);
    
    if(PRINT_TIMES)
        fprintf('check triggers at %f\n',etime(clock,timezero));
    end
   
    
    %fprintf('check triggers at %f\n',etime(clock,timezero));
    
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    if ( ADCcaptureenable == 1 )
        
        if ( istriggered(handles.xem,EP_TRIGGEROUT_TEST1,EPBIT_ADCDATAREADY) )
            if(PRINT_TIMES)
                fprintf('\nADC trigger at %f\n',etime(clock,timezero));
            end

            %fprintf('\nADC trigger at %f\n',etime(clock,timezero));
            
            %readbytes = readfrompipeout(handles.xem, EP_PIPEOUT_ADC, ADC_xfer_len, ADC_pkt_len);
            readbytes = readfromblockpipeout(handles.xem, EP_PIPEOUT_ADC, ADC_xfer_blocksize, ADC_xfer_len, ADC_pkt_len);
            bytesread = length(readbytes);
            
            
            if(PRINT_TIMES)
                fprintf('ADC data received at %f\n',etime(clock,timezero));
                bytesread = length(readbytes)
            end
            
            

            %readvalues = 256*uint16(readbytes(2:2:length(readbytes))) + uint16(readbytes(1:2:length(readbytes)));
            %printRawADCdata=dec2bin(typecast(readvalues(1:16),'uint16'),16)
            
            readvalues = typecast(readbytes,RAWDATAFORMAT);
            
            % ================
            % TESTING
            ADCvalues = bitand(readvalues,bin2dec('00000000000000001111111111111111'));    %note: also saves trigger signals
            DACvalues = cast(bitshift(bitand(readvalues,bin2dec('11111111111111110000000000000000')),-16),'uint16');
            % ================
            
                       
            
            readvalues = cast(ADCvalues,'uint16');
            
            read_monitor = read_monitor + 2*length(readvalues);
            
            %printRawADCdata=dec2bin(readvalues(1:16),16)
            
            %fprintf('readvalues ready at %f\n',etime(clock,timezero));
            
            %readvalues = mod(readvalues,2^ADCBITS);
            
            %{
            % right-justfied
            bitmask = 2^(ADCBITS) - 1;
            readvalues = bitand(readvalues,bitmask);
            %readvalues = bitand(readvalues,bin2dec('0011111111111111'));
            %}
            
            
            %fprintf('mod ready at %f\n',etime(clock,timezero));
            
%             % =============================================================
%             % BUG FIX:  HARDWARE DATA BUFFER PATH IS SHIFTING EVERY 512th SAMPLE
%             %before = readvalues(510:514)
%             for x = 1:512:(length(readvalues)-511)
%                 readvalues( x:(x+511) ) = [ readvalues(x+511); readvalues(x:(x+510)) ];
%             end
%             %readvalues(x) = 0.5*(readvalues(x-1)+readvalues(x+1));
%             %after = readvalues(510:514)
%             % ============================================================
            
            
            if ADClogenable==1
                %writinglog=1
                
                if( (ADClogreset==1) || (ADClogsize > MAXLOGBYTES) )
                    %logADCfid
                    if(logADCfid>0)
                        fclose(logADCfid);
                        fclose(logDACfid);
                    end
                    ADClogsize=0;
                    %mysamplerate = sprintf('_%dksps',ADCSAMPLERATE/1000);
                    mytimestamp = now;
                    
                    mytimestampstring = datestr(mytimestamp,'_yyyymmdd_HHMMSS');
                    
                    mylogdir = ['logfiles\' get(handles.edit_logdir,'String')];
                    ADClogfilename = [mylogdir '\' get(handles.edit_logname,'String') mytimestampstring];
                    DAClogfilename = [mylogdir '\' get(handles.edit_logname,'String') '_DAC' mytimestampstring];
                    fprintf('log file: %s\n',ADClogfilename);

                    SETUP_TIAgain = str2double(get(handles.edit_gain_Mohm,'String'))*1e6;
                    SETUP_preADCgain = str2double(get(handles.edit_preADCgain,'String'));
                    SETUP_pAoffset = str2double(get(handles.edit_pAoffset,'String'))*1e-12;
                    SETUP_mVoffset = str2double(get(handles.edit_mVoffset,'String'))*1e-3;
                    SETUP_ADCSAMPLERATE = ADCSAMPLERATE;
                    SETUP_ADCVREF = ADCVREF;
                    SETUP_ADCBITS = ADCBITS;
                    SETUP_biasvoltage = str2double(get(handles.text_biasvoltage,'String'));
                    
                    %legacy
                    bias2value = SETUP_biasvoltage;

                    if(exist(mylogdir)~=7)
                        mkdir(mylogdir);
                    end
                    
                    logADCfid = fopen([ADClogfilename '.log'],'a');
                    logDACfid = fopen([DAClogfilename '.log'],'a');
                    
                    logsetupname = [ADClogfilename '.mat'];
                    save(logsetupname,                  ...
                            'ADCSAMPLERATE',                    ...
                            'mytimestamp',                      ...
                            'bias2value',                      ...
                            'SETUP*',                   ...
                            'DACvalues');   %TEMPORARY ADDITION 9/26/2013
                    ADClogreset=0;
                end

                if(logADCfid>0)
                    ADClogsize = ADClogsize + 2*length(readvalues);
                    fwrite(logADCfid,readvalues,'uint16');
                    %fwrite(logADCfid,readbytes,'uint8');
                    
                    fwrite(logDACfid,DACvalues,'uint16');   
                    
                end
                
            else
                if(logADCfid>0)
                    fclose(logADCfid);
                    fclose(logDACfid);
                end
            end

            if(PRINT_TIMES)
                fprintf('previewing1 %f\n',etime(clock,timezero));
            end
            
            
            
            % =======================================================
            triggermask = 2^0;
            triggervalues = boolean(bitand(readvalues,triggermask));
    
            % left-justified
            bitmask = (2^16 - 1) - (2^(16-ADCBITS) - 1);
            readvalues = bitand(readvalues,bitmask);
            % =======================================================
            
            
            
            figure(handles.figure1);
            axes(handles.axes_trace);
            hold off;

            
            SETUP_TIAgain = str2double(get(handles.edit_gain_Mohm,'String'))*1e6;
            SETUP_preADCgain = str2double(get(handles.edit_preADCgain,'String'));
            
            mygain = SETUP_TIAgain*SETUP_preADCgain;
            
            
            SETUP_pAoffset = str2double(get(handles.edit_pAoffset,'String'))*1e-12;

            
            
            if(PRINT_TIMES)
                fprintf('previewing2 %f\n',etime(clock,timezero));
            end
            
            ADCnumsignals=1;
            colors = 'br';       
            
            % ###########################################
            triggerindex = find(triggervalues>0,1);
            if(~isempty(triggerindex))
                previewoffsetindex = triggerindex;
                set(handles.text_triggerdetected,'Visible','on');
            else
                previewoffsetindex = 1;
                set(handles.text_triggerdetected,'Visible','off');
            end

            previewindexstart = previewoffsetindex - 0.5*(displaybuffersize*displaysubsample*ADCnumsignals);
            previewindexstart = max(1,previewindexstart);
            previewindexstart = min(length(readvalues)-(displaybuffersize*displaysubsample*ADCnumsignals),previewindexstart);
            %previewindexstart = min(length(readvalues)-displaybuffersize,previewindexstart)
            previewindexend = previewindexstart + (displaybuffersize*displaysubsample*ADCnumsignals) - 1;
            % ###########################################
            
            autorefreshpreview = get(handles.checkbox_autopreview,'Value');
            if(autorefreshpreview || ~isempty(triggerindex))

                for sampleshift = 1:ADCnumsignals    

                    %right-justified
                    %doublereadvalues = ADCVREF - double(readvalues)./(2^ADCBITS).*(2*ADCVREF);

                    %left-justified
                    doublereadvalues = ADCVREF - double(readvalues)./(2^16).*(2*ADCVREF);

                    if(PRINT_TIMES)
                        fprintf('previewing3a %f\n',etime(clock,timezero));
                        
                        previewindexstart
                        previewindexend
                        displaysubsample
                        ADCnumsignals
                        
                        doublereadvaluessize = size(doublereadvalues)
                        
                        ceil((previewindexend-previewindexstart+1)/(displaysubsample*ADCnumsignals))
                        size(resample(doublereadvalues(previewindexstart:previewindexend),1,displaysubsample*ADCnumsignals))
                    end

                    %old
                    %displaybuffer(1:displaybuffersize) = -ADCvref + (resample(double(readvalues(1:(displaybuffersize*displaysubsample*ADCnumsignals))),1,displaysubsample*ADCnumsignals, 2)/2^ADCBITS*(2*ADCvref));

                    %{
                    previewindexstart
                    previewindexend
                    (previewindexend-previewindexstart+1)
                    (previewindexend-previewindexstart+1)/(displaysubsample*ADCnumsignals)
                    ((previewindexend-previewindexstart+1)/(displaysubsample*ADCnumsignals))
                    size(displaybuffer)
                    size(doublereadvalues)
                    %}

                    %displaybuffer(1:displaybuffersize) = resample(doublereadvalues(1:(displaybuffersize*displaysubsample*ADCnumsignals)),1,displaysubsample*ADCnumsignals, 2);
                    displaybuffer(1:ceil((previewindexend-previewindexstart+1)/(displaysubsample*ADCnumsignals))) = (resample(doublereadvalues(previewindexstart:previewindexend),1,displaysubsample*ADCnumsignals))';

                    %mean_original = mean(doublereadvalues);
                    %mean_resampleddisplay = mean(displaybuffer);

                    if(PRINT_TIMES)
                        fprintf('previewing3a before plot %f\n',etime(clock,timezero));
                    end
                    
                    %plot((100:(displaybuffersize-100))/(ADCSAMPLERATE/displaysubsample),mycurrentoffset*1e9+displaybuffer(100:(displaybuffersize-100))./(mygain*-1e-9),['-' colors(sampleshift)],'MarkerSize',5);
                    plot(((10:(displaybuffersize-10))/(ADCSAMPLERATE/displaysubsample)),(SETUP_pAoffset*1e9+displaybuffer(10:(displaybuffersize-10))./(mygain*-1e-9)),['-' colors(sampleshift)],'MarkerSize',5);
                    hold on;
                    displaycount = 1+mod(displaycount+1,4);

                    if(PRINT_TIMES)
                        fprintf('previewing3b %f\n',etime(clock,timezero));
                    end

                    %DCvoltage(sampleshift) = mean(displaybuffer(10:(displaybuffersize-10)));
                    DCvoltage(sampleshift) = mean(doublereadvalues);
                    %RMSpreview = std(displaybuffer(10:(displaybuffersize-10)))*1e-9;
                    if(displaycount==1)
                        RMSvoltage(sampleshift) = std(doublereadvalues);
                    end

                end


                if(PRINT_TIMES)
                    fprintf('previewing4 %f\n',etime(clock,timezero));
                end

                biasvoltage = 1e-3 * str2double(get(handles.text_biasvoltage,'String'));


                %displayDC=mean(displaybuffer(100:(displaybuffersize-100)))./(mygain*-1e-9) + mycurrentoffset*1e9
                myIdc = -DCvoltage(1)/mygain + SETUP_pAoffset;

                if(displaycount==1)
                    myIrms = RMSvoltage(1)/mygain;
                end
                
                
                
                                    
                    
                    
                    %----------------------------------------------------------------------------------------------------------------------------------------------

                readbytes_fifo = readfromblockpipeout(handles.xem, PIPEOUT_FSM_CURRENT_STATE, ADC_xfer_blocksize, ADC_xfer_blocksize);
                
                bytesread_fifo = length(readbytes_fifo);
                readvalues_fifo = typecast(readbytes_fifo,RAWDATAFORMAT);

                readvalues_fifo = cast(readvalues_fifo,'uint16');
                set(handles.text_FSM,'String',sprintf('Data in FIFO: %g \n' ,readvalues_fifo));
                
                
                if readvalues_fifo>0
                    manualbuttonenable = 'off';
                else
                    manualbuttonenable = 'on';
                end
                
                set(handles.pushbutton_bias1000,'Enable',manualbuttonenable);
                set(handles.pushbutton_bias500,'Enable',manualbuttonenable);
                set(handles.pushbutton_bias400,'Enable',manualbuttonenable);
                set(handles.pushbutton_bias300,'Enable',manualbuttonenable);
                set(handles.pushbutton_bias200,'Enable',manualbuttonenable);
                set(handles.pushbutton_bias100,'Enable',manualbuttonenable);
                set(handles.pushbutton_bias50,'Enable',manualbuttonenable);
                set(handles.pushbutton_nbias1000,'Enable',manualbuttonenable);
                set(handles.pushbutton_nbias500,'Enable',manualbuttonenable);
                set(handles.pushbutton_nbias400,'Enable',manualbuttonenable);
                set(handles.pushbutton_nbias300,'Enable',manualbuttonenable);
                set(handles.pushbutton_nbias200,'Enable',manualbuttonenable);
                set(handles.pushbutton_nbias100,'Enable',manualbuttonenable);
                set(handles.pushbutton_nbias50,'Enable',manualbuttonenable);
                set(handles.pushbutton_zeroDACs,'Enable',manualbuttonenable);
                set(handles.pushbutton_invert,'Enable',manualbuttonenable);
                set(handles.pushbutton_prevbias,'Enable',manualbuttonenable);
                set(handles.pushbutton_bias_inc100,'Enable',manualbuttonenable);
                set(handles.pushbutton_bias_inc10,'Enable',manualbuttonenable);
                set(handles.pushbutton_bias_inc1,'Enable',manualbuttonenable);
                set(handles.pushbutton_nbias_inc100,'Enable',manualbuttonenable);
                set(handles.pushbutton_nbias_inc10,'Enable',manualbuttonenable);
                set(handles.pushbutton_nbias_inc1,'Enable',manualbuttonenable);
                
                
                
                
                
                myRdc = biasvoltage / myIdc * 1e-6;
                myGdc = myIdc / biasvoltage * 1e9;
                set(handles.text_Idc1,'String',sprintf('Idc ~= %1.3f nA \nIrms ~= %1.1f pA \nR ~= %4.1f Mohm \nG ~= %4.1f nS',myIdc*1e9,myIrms*1e12,myRdc,myGdc ));            


                previewscale = str2double(get(handles.edit_scalepA,'String'))*1e-12;
                previewscale = max(previewscale,50e-12);

                display_ymax = myIdc+previewscale;
                display_ymin = myIdc-previewscale;
                if(get(handles.checkbox_previewzero,'Value')==1)
                    display_ymax = max(display_ymax,previewscale);
                    display_ymin = min(display_ymin,-previewscale);
                end

                if(get(handles.checkbox_previewsymmetric,'Value')==1)
                    display_ymax = max(display_ymax,-display_ymin);
                    display_ymin = min(display_ymin,-display_ymax);
                end

                %{
                [maxpreviewvalue maxpreviewindex] = max(displaybuffer);

                previewthreshold = 500e-12;

                if (maxpreviewvalue-myIdc)>previewthreshold
                    previewcenter = maxpreviewindex / (ADCSAMPLERATE/displaysubsample);
                else
                    previewcenter = 0.5*PREVIEWtime;
                end
                %}
                previewcenter = 0.5*displaybuffertime;

                if ~isempty(triggerindex)
                    previewcenter = displaybuffertime*((triggerindex-previewindexstart)/(previewindexend-previewindexstart));
                    
                    %disp('hello i am making a line');
                    
                    plot([0 0],[display_ymin*1e9 display_ymax*1e9],'r-','LineWidth',2);
                    
                    %{
                    % highlight several triggers
                    firsttriggers = find(triggervalues>0,4);
                    firsttriggerlocations = displaybuffertime*((firsttriggers-triggerindex-previewindexstart)/(previewindexend-previewindexstart));
                    for k = 1:length(firsttriggers)
                        plot(firsttriggerlocations(k)*[1 1],[display_ymin*1e9 display_ymax*1e9],'r-','LineWidth',2);
                    end
                    %}
                end

                previewstart = previewcenter - 0.5*PREVIEWtime;
                previewend = previewcenter + 0.5*PREVIEWtime;



                %axis([0 displaybuffersize/(ADCSAMPLERATE/displaysubsample) display_ymin*1e9 display_ymax*1e9])
                
                axis([previewstart previewend display_ymin*1e9 display_ymax*1e9]);
                grid on;
                xlabel('time (sec)');
                ylabel('current (nA)');


                if(displaycount==1)
                    set(handles.text_CH1stats,'String',sprintf('CH1: \n avg %1.5f V\n rms %1.5f V',DCvoltage(1),RMSvoltage(1)));
                    %set(handles.text_CH2stats,'String',sprintf('CH2: \n avg %1.5f \n rms %1.5f',DCvoltage(2),RMSvoltage(2)));   

                    
                    
                    
                    
                    
                end

                % ==========================





                if(PRINT_TIMES)
                    fprintf('done previewing %f\n',etime(clock,timezero));
                end


                
                
                
                % ======== AUTO UNCLOG ===========
                
                if((isUnclogging==0) && get(handles.checkbox_autounclog,'Value'))
                    unclogthresh_nS = str2double(get(handles.edit_unclogthreshold,'String'));
                    
                    if((biasvoltage~=0) && (myGdc < unclogthresh_nS))
                        
                        isUnclogging=1;
                        
                        getbiasmV = str2double(get(handles.text_biasvoltage,'String'));
                        zapbiasmV = str2double(get(handles.edit_zapmV,'String'));
                        zapseconds = str2double(get(handles.edit_zapseconds,'String'));

                        set(handles.text_biasvoltage,'String',zapbiasmV);
                        DAQ_updateDACvalues1(handles);

                        t = timer('StartDelay',zapseconds);
                        t.TimerFcn = {@DAQ_updateDACvalues3, handles, getbiasmV};
                        start(t);
                    end
                end
                
                
            
            end
            
        end   %adc trigger
    end % adc capture enable
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
    
    
end  %finish function





