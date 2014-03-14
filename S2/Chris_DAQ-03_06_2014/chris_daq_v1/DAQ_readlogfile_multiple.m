
function DAQ_readlogfile_multiple(filefilter)

%samplerate=50e3;

logdata = [];

[filename, pathname, filterindex] = uigetfile(['*' filefilter '*.log'], 'pick log files','MultiSelect','on');



if(iscell(filename))
    for i = 1:length(filename)

        fprintf('\n\n------------------------------------------------\n');
        fprintf('processing file %d / %d\n',i,length(filename));

        %fullfile(pathname, filename{i});


        DAQ_readlogfile(fullfile(pathname, filename{i}));


        pause(1);
        %picturefilename = [filename{i} '.jpg']
        %saveas(gcf,[filename{i} '.jpg'],'jpg');
        
        %close(gcf);
        clear logdata t;
        
        % =======================================================
        % =======================================================

    end   %file
else
    DAQ_readlogfile(fullfile(pathname, filename));
end


