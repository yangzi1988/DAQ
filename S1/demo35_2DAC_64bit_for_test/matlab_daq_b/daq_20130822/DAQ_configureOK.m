

%function [xem,xempll] = DAQ_configureOK()
function [xem] = DAQ_configureOK()

DAQ_constants_include;

addpath('OK_Matlab_Drivers');
if ~libisloaded('okFrontPanel')
	loadlibrary('okFrontPanel', 'okFrontPanelDLL.h');
end

[models,serials] = ok_getdevicelist();

if(isempty(serials))

    xem = [];
    xempll = [];
    errordlg('DAQ USB DAQ Not Found');
    
else
    % build a frontpanel instance
    xptr = calllib('okFrontPanel', 'okFrontPanel_Construct');
    numDev = calllib('okFrontPanel','okFrontPanel_GetDeviceCount',xptr);
    xem = okusbfrontpanel(xptr);

    %preferred:
    openbyserial(xem,strcat(char(serials)));
    %alternate: 
    %openbyserial(xem,lib.pointer);

    %loaddefaultpllconfiguration(xem);


    %xempll = okpll22393();
    %geteeprompll22393configuration(xem,xempll);
    %setpll22393configuration(xem,xempll);

    %DAQ_configurePLL(xem,xempll,CLK1FREQDEFAULT,CLK2FREQDEFAULT);

    bitfile = fullfile(pwd,BITFILENAME);
    fprintf('Loading Firmware %s\n',bitfile);
    success=configurefpga(xem, bitfile)

    %destroy the frontpanel instance
    %calllib('okFrontPanel', 'okUsbFrontPanel_Destruct', xptr);
end

