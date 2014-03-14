                                                                                                                                                  function varargout = DAQ_gui(varargin)
% DAQ_GUI M-file for DAQ_gui.fig
%      DAQ_GUI, by itself, creates a new DAQ_GUI or raises the existing
%      singleton*.
%
%      H = DAQ_GUI returns the handle to a new DAQ_GUI or the handle to
%      the existing singleton*.
%
%      DAQ_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DAQ_GUI.M with the given input arguments.
%
%      DAQ_GUI('Property','Value',...) creates a new DAQ_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DAQ_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DAQ_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DAQ_gui

% Last Modified by GUIDE v2.5 21-Jan-2014 13:25:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DAQ_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @DAQ_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DAQ_gui is made visible.
function DAQ_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DAQ_gui (see VARARGIN)

% Choose default command line output for DAQ_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DAQ_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% ======================================================================
% ======================================================================

DAQ_constants_include;
DAQ_constants_init;

todaysdate = datestr(now,'yyyymmdd');
set(handles.edit_logdir,'String',todaysdate);


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if(exist(SAVECONFIGFILE,'file'))
    load(SAVECONFIGFILE,'SETUP*');

    set(handles.edit_gain_Mohm,'String',SETUP_TIAgain*1e-6);
    set(handles.edit_preADCgain,'String',SETUP_preADCgain);
    set(handles.edit_pAoffset,'String',SETUP_pAoffset*1e12);
    set(handles.edit_mVoffset,'String',SETUP_mVoffset*1e3);
    set(handles.edit_Cfast,'String',SETUP_cfast*1e12);
    set(handles.edit_freqcomp,'String',SETUP_freqcomp);    
    ADCBITS = SETUP_ADCBITS;
    ADCVREF = SETUP_ADCVREF;
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




% --- Outputs from this function are returned to the command line.
function varargout = DAQ_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox_led0.
function checkbox_led0_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_led0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_led0

DAQ_constants_include;

ledvalue = get(hObject,'Value');
setwireinvalue(handles.xem,EP_WIREIN_TEST1, ledvalue*EPBIT_LED0, EPBIT_LED0 );    
updatewireins(handles.xem);
   


% --- Executes on button press in checkbox_led1.
function checkbox_led1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_led1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_led1

DAQ_constants_include;

ledvalue = get(hObject,'Value');
setwireinvalue(handles.xem,EP_WIREIN_TEST1, ledvalue*EPBIT_LED1, EPBIT_LED1 );    
updatewireins(handles.xem);





function edit_scanvectorfile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scanvectorfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scanvectorfile as text
%        str2double(get(hObject,'String')) returns contents of edit_scanvectorfile as a double


% --- Executes during object creation, after setting all properties.
function edit_scanvectorfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scanvectorfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_scanvector.
function pushbutton_scanvector_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_scanvector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname, filterindex] = uigetfile('VECTOR*.m', 'Pick a scan vector file');
if filename ~= 0
    set(handles.edit_scanvectorfile,'String',filename);
end


% --- Executes on button press in pushbutton_sendscanvector.
function pushbutton_sendscanvector_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_sendscanvector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DAQ_constants_include;

scanvectorfile = get(handles.edit_scanvectorfile,'String');

[pathstr, name, ext, versn] = fileparts(scanvectorfile);
getvector = eval(name);

% --- display vector ---
vectorlength = length(getvector);
printscanvector = dec2bin(getvector,16);
%toplot = dec2bin(getvector,16)-'0';
%toplot = 0.5*toplot + ones(vectorlength,1) * (15:-1:0);
%figure; stairs(toplot);
% ---------------

ADClogreset=1;

DAQ_sendscanvector1(handles.xem, getvector);


DAQ_updateDACvalues1(handles);





% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DAQ_constants_include;

if(exist('handles.triggertimer'))
    stop(handles.triggertimer);
    delete(handles.triggertimer);
end

if(exist('handles.bandwidthtimer'))
    stop(handles.bandwidthtimer);
    delete(handles.bandwidthtimer);
end

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SETUP_TIAgain = str2double(get(handles.edit_gain_Mohm,'String'))*1e6;
SETUP_preADCgain = str2double(get(handles.edit_preADCgain,'String'));
SETUP_pAoffset = str2double(get(handles.edit_pAoffset,'String'))*1e-12;
SETUP_mVoffset = str2double(get(handles.edit_mVoffset,'String'))*1e-3;
SETUP_cfast = str2double(get(handles.edit_Cfast,'String'))*1e-12;
SETUP_freqcomp = str2double(get(handles.edit_freqcomp,'String'));
SETUP_ADCBITS = ADCBITS;
SETUP_ADCVREF = ADCVREF;
save(SAVECONFIGFILE,'SETUP*');
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% Hint: delete(hObject) closes the figure
delete(hObject);




% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5

DAQ_constants_include;

ADCcaptureenable = get(hObject,'Value');






function edit_logname_Callback(hObject, eventdata, handles)
% hObject    handle to edit_logname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_logname as text
%        str2double(get(hObject,'String')) returns contents of edit_logname as a double


% --- Executes during object creation, after setting all properties.
function edit_logname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_logname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_enablelogging.
function checkbox_enablelogging_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_enablelogging (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_enablelogging

DAQ_constants_include;

newlogenable = get(hObject,'Value');

if newlogenable == 1

    %{
    mysamplerate = sprintf('_%dksps',ADCSAMPLERATE/1000);
    mytimestamp = datestr(now,'_yyyymmdd_HHMMSS');
    logfilename = [get(handles.edit_logname,'String') mysamplerate mytimestamp '.log']
    logfid = fopen(logfilename,'a');
    %}
    %logenable=1;

    ADClogreset = 1;
    ADClogenable = 1;
    
else
    ADClogenable = 0;
    
    fclose(logADCfid);
    fclose(logDACfid);
    logADCfid=0;
    logDACfid=0;
    
end



% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

DAQ_constants_include;

muxselection = get(hObject,'Value');

wiremask=EPBIT_ADC1MUX0+EPBIT_ADC1MUX1;
wirevalue=0;
muxvals = dec2bin(muxselection-1,2);
%muxvals(1)
%muxvals(2)

if muxvals(1)=='1'
    wirevalue = wirevalue + EPBIT_ADC1MUX1;
end
if muxvals(2)=='1'
    wirevalue = wirevalue + EPBIT_ADC1MUX0;
end


%CHIPSETUP_ABselect = muxselection

setwireinvalue(handles.xem,EP_WIREIN_ADCMUX, wirevalue, wiremask );    
updatewireins(handles.xem);





% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in checkbox_counterelectrode.
function checkbox_counterelectrode_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_counterelectrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_counterelectrode


DAQ_constants_include;

wirevalue = get(hObject,'Value')*EPBIT_AMPMUX2;

wiremask=EPBIT_AMPMUX2;

setwireinvalue(handles.xem,EP_WIREIN_ADCMUX, wirevalue, wiremask );    
updatewireins(handles.xem);





% --- Executes on button press in pushbutton_zeroDACs.
function pushbutton_zeroDACs_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_zeroDACs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',0);
DAQ_updateDACvalues1(handles);




% --- Executes on button press in checkbox9_integratorreset4.
function checkbox9_integratorreset4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9_integratorreset4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9_integratorreset4

DAQ_constants_include;

wirevalue = get(hObject,'Value')*EPBIT_ASSERTINTEGRATORRESET4;

wiremask=EPBIT_ASSERTINTEGRATORRESET4;

setwireinvalue(handles.xem, EP_WIREIN_TEST1, wirevalue, wiremask );    
updatewireins(handles.xem);




% --- Executes on button press in checkbox_adcfifoenable.
function checkbox_adcfifoenable_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_adcfifoenable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_adcfifoenable

DAQ_constants_include;

wirevalue = get(hObject,'Value')*EPBIT_ENABLEADCFIFO;

wiremask=EPBIT_ENABLEADCFIFO;

setwireinvalue(handles.xem, EP_WIREIN_TEST1, wirevalue, wiremask );    
updatewireins(handles.xem);


% --- Executes on button press in pushbutton_clktimer.
function pushbutton_clktimer_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clktimer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DAQ_constants_include;

set(handles.checkbox_adcfifoenable,'Value',0);

delaytime = str2num(get(handles.edit_clktimer,'String'));

setwireinvalue(handles.xem, EP_WIREIN_TEST1, EPBIT_ENABLEADCFIFO, EPBIT_ENABLEADCFIFO ); 
updatewireins(handles.xem);

ADClogreset=1;

fprintf('Start timer at %f\n',etime(clock,timezero));

clktimer = timer('StartDelay', delaytime);
clktimer.TimerFcn = { @DAQ_ADCFIFOoff, handles };
start(clktimer);






function edit_clktimer_Callback(hObject, eventdata, handles)
% hObject    handle to edit_clktimer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_clktimer as text
%        str2double(get(hObject,'String')) returns contents of edit_clktimer as a double


% --- Executes during object creation, after setting all properties.
function edit_clktimer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_clktimer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in checkbox9_integratorreset3.
function checkbox9_integratorreset3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9_integratorreset3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9_integratorreset3


DAQ_constants_include;

wirevalue = get(hObject,'Value')*EPBIT_ASSERTINTEGRATORRESET3;

wiremask=EPBIT_ASSERTINTEGRATORRESET3;

setwireinvalue(handles.xem, EP_WIREIN_TEST1, wirevalue, wiremask );    
updatewireins(handles.xem);


% --- Executes on button press in checkbox9_integratorreset2.
function checkbox9_integratorreset2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9_integratorreset2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9_integratorreset2


DAQ_constants_include;

wirevalue = get(hObject,'Value')*EPBIT_ASSERTINTEGRATORRESET2;

wiremask=EPBIT_ASSERTINTEGRATORRESET2;

setwireinvalue(handles.xem, EP_WIREIN_TEST1, wirevalue, wiremask );    
updatewireins(handles.xem);



% --- Executes on button press in checkbox9_integratorreset.
function checkbox9_integratorreset_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9_integratorreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9_integratorreset


DAQ_constants_include;

wirevalue = get(hObject,'Value')*EPBIT_ASSERTINTEGRATORRESET;

wiremask=EPBIT_ASSERTINTEGRATORRESET;

setwireinvalue(handles.xem, EP_WIREIN_TEST1, wirevalue, wiremask );    
updatewireins(handles.xem);



% --- Executes on selection change in popupmenu_ampgain.
function popupmenu_ampgain_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_ampgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_ampgain contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_ampgain

DAQ_constants_include;

ampgainselection = get(hObject,'Value')

switch ampgainselection
    case 1
        CHIPSETUP_Ci = 1e-12
    case 2
        CHIPSETUP_Ci = 0.9e-12
    case 3
        CHIPSETUP_Ci = 0.15e-12
    case 4
        CHIPSETUP_Ci = 0.05e-12
end





% --- Executes during object creation, after setting all properties.
function popupmenu_ampgain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_ampgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_connectelectrode.
function checkbox_connectelectrode_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_connectelectrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_connectelectrode

DAQ_constants_include;

CHIPSETUP_electrodeconnect = get(hObject,'Value')





function edit_gain_Mohm_Callback(hObject, eventdata, handles)
% hObject    handle to edit_gain_Mohm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gain_Mohm as text
%        str2double(get(hObject,'String')) returns contents of edit_gain_Mohm as a double


% --- Executes during object creation, after setting all properties.
function edit_gain_Mohm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_gain_Mohm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Cp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Cp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Cp as text
%        str2double(get(hObject,'String')) returns contents of edit_Cp as a double


% --- Executes during object creation, after setting all properties.
function edit_Cp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Cp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Cz_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Cz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Cz as text
%        str2double(get(hObject,'String')) returns contents of edit_Cz as a double


% --- Executes during object creation, after setting all properties.
function edit_Cz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Cz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_preADCgain_Callback(hObject, eventdata, handles)
% hObject    handle to edit_preADCgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_preADCgain as text
%        str2double(get(hObject,'String')) returns contents of edit_preADCgain as a double


% --- Executes during object creation, after setting all properties.
function edit_preADCgain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_preADCgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_boostrapcap_Callback(hObject, eventdata, handles)
% hObject    handle to edit_boostrapcap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_boostrapcap as text
%        str2double(get(hObject,'String')) returns contents of edit_boostrapcap as a double

DAQ_constants_include;

CHIPSETUP_bootstrapcap  = str2double(get(hObject,'String'));




% --- Executes during object creation, after setting all properties.
function edit_boostrapcap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_boostrapcap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_butterworth3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_butterworth3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_butterworth3 as text
%        str2double(get(hObject,'String')) returns contents of edit_butterworth3 as a double


% --- Executes during object creation, after setting all properties.
function edit_butterworth3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_butterworth3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DAQ_constants_include;

set(handles.checkbox_adcfifoenable,'Value',0);

delaytime = 0.1;

setwireinvalue(handles.xem, EP_WIREIN_TEST1, EPBIT_ENABLEADCFIFO, EPBIT_ENABLEADCFIFO ); 
updatewireins(handles.xem);

ADClogreset=1;

fprintf('Start timer at %f\n',etime(clock,timezero));

clktimer = timer('StartDelay', delaytime);
clktimer.TimerFcn = { @DAQ_ADCFIFOoff, handles };
start(clktimer);
wait(clktimer);





% --- Executes on button press in checkbox_srcext.
function checkbox_srcext_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_srcext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_srcext


DAQ_constants_include;

CHIPSETUP_srcextAB = get(hObject,'Value')






function edit_boardgain_Callback(hObject, eventdata, handles)
% hObject    handle to edit_boardgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_boardgain as text
%        str2double(get(hObject,'String')) returns contents of edit_boardgain as a double


% --- Executes during object creation, after setting all properties.
function edit_boardgain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_boardgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_chAselect.
function checkbox_chAselect_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_chAselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_chAselect

DAQ_constants_include;

CHIPSETUP_CHAselect = get(hObject,'Value')



% --- Executes on button press in checkbox_chBselect.
function checkbox_chBselect_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_chBselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_chBselect

DAQ_constants_include;

CHIPSETUP_CHBselect = get(hObject,'Value')






function edit_logtext_Callback(hObject, eventdata, handles)
% hObject    handle to edit_logtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_logtext as text
%        str2double(get(hObject,'String')) returns contents of edit_logtext as a double


% --- Executes during object creation, after setting all properties.
function edit_logtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_logtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DAQ_constants_include;

% LOG EVENT
newlogentry = sprintf('%s: %s \r\n', datestr(now,'yyyymmdd_HHMMSS'), get(handles.edit_logtext,'String'));
fid=fopen(EVENTLOGFILE,'a');
fwrite(fid,newlogentry);
fclose(fid);













% --- Executes on button press in pushbutton_invert.
function pushbutton_invert_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_invert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentbias = str2double(get(handles.text_biasvoltage,'String'));
set(handles.text_biasvoltage,'String',-currentbias);
DAQ_updateDACvalues1(handles);







% --- Executes on button press in pushbutton_bias_inc100.
function pushbutton_bias_inc100_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bias_inc100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentbias = str2double(get(handles.text_biasvoltage,'String'));
set(handles.text_biasvoltage,'String',currentbias+100);
DAQ_updateDACvalues1(handles);




% --- Executes on button press in pushbutton_nbias_inc100.
function pushbutton_nbias_inc100_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nbias_inc100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentbias = str2double(get(handles.text_biasvoltage,'String'));
set(handles.text_biasvoltage,'String',currentbias-100);
DAQ_updateDACvalues1(handles);






function edit_attenfb_Callback(hObject, eventdata, handles)
% hObject    handle to edit_attenfb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_attenfb as text
%        str2double(get(hObject,'String')) returns contents of edit_attenfb as a double


% --- Executes during object creation, after setting all properties.
function edit_attenfb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_attenfb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function edit_pAoffset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pAoffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pAoffset as text
%        str2double(get(hObject,'String')) returns contents of edit_pAoffset as a double


% --- Executes during object creation, after setting all properties.
function edit_pAoffset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pAoffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sweep1vals = [0:0.01:0.1 0 0:-0.01:-0.1 0];

DAQ_IVsweep1(0,0,handles,1,sweep1vals);





% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DAQ_constants_include;

%myIdc
mypAoffset = str2double(get(handles.edit_pAoffset,'String'));

set(handles.edit_pAoffset,'String',mypAoffset-myIdc*1e12);





function edit_DCsweepstep_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DCsweepstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DCsweepstep as text
%        str2double(get(hObject,'String')) returns contents of edit_DCsweepstep as a double


% --- Executes during object creation, after setting all properties.
function edit_DCsweepstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DCsweepstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function text_biasvoltage_Callback(hObject, eventdata, handles)
% hObject    handle to text_biasvoltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_biasvoltage as text
%        str2double(get(hObject,'String')) returns contents of text_biasvoltage as a double

DAQ_updateDACvalues1(handles);


% --- Executes during object creation, after setting all properties.
function text_biasvoltage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_biasvoltage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_mVoffset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mVoffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mVoffset as text
%        str2double(get(hObject,'String')) returns contents of edit_mVoffset as a double


% --- Executes during object creation, after setting all properties.
function edit_mVoffset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mVoffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


DAQ_constants_include;

setwireinvalue(handles.xem,EP_WIREIN_TEST1, EPBIT_GLOBALRESET, EPBIT_GLOBALRESET );    
updatewireins(handles.xem);
pause(0.1);
setwireinvalue(handles.xem,EP_WIREIN_TEST1, 0, EPBIT_GLOBALRESET );    
updatewireins(handles.xem);




% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DAQ_constants_include;

DAQ_autozerooffsetvoltage([],[],handles,0);




% --- Executes on button press in pushbuttonOKinit.
function pushbuttonOKinit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOKinit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DAQ_constants_include;

handles.xem = DAQ_configureOK();


if(~isempty(handles.xem))

    set(handles.text_adcrate,'String',ADCSAMPLERATE/1000);

    setwireinvalue(handles.xem,EP_WIREIN_TEST1, EPBIT_GLOBALRESET, EPBIT_GLOBALRESET );    
    updatewireins(handles.xem);
    pause(0.1);
    setwireinvalue(handles.xem,EP_WIREIN_TEST1, EPBIT_ENABLEADCFIFO, EPBIT_ENABLEADCFIFO );    
    updatewireins(handles.xem);
    pause(0.1);
    setwireinvalue(handles.xem,EP_WIREIN_TEST1, 0, EPBIT_GLOBALRESET );    
    updatewireins(handles.xem);

    setwireinvalue(handles.xem,EP_WIREIN_TEST1, EPBIT_HEADSTAGE_PWR_LED, EPBIT_HEADSTAGE_PWR_LED );    
    updatewireins(handles.xem);
    pause(0.1);

    handles.bandwidthtimer = timer('Period', 1, 'TasksToExecute',10e6,'ExecutionMode','fixedRate');
    handles.bandwidthtimer.TimerFcn = { @DAQ_bandwidthtimer, handles };

    handles.triggertimer = timer('Period', 0.1, 'TasksToExecute',10e6,'ExecutionMode','fixedRate');
    handles.triggertimer.TimerFcn = { @DAQ_process_triggers, handles };

    guidata(hObject, handles);

    % INITIALIZING DAC AND DIGITAL POT
    DAQ_updateDACvalues1(handles);
    DAQ_updateDPOTvalues1(handles);

    % turn on ADC stream
    ADCcaptureenable = 1;
    set(handles.checkbox5,'Value',1);

    
    % select filtered signal mux
    set(handles.popupmenu2,'Value',ADCMUXDEFAULT);
    popupmenu2_Callback(handles.popupmenu2, [], handles)

    % init complete, change button to green
    set(handles.pushbuttonOKinit,'BackgroundColor','g')

    start(handles.bandwidthtimer);
    start(handles.triggertimer);

    
    % reset DAC FSM to initialize trigger threshold
    activatetriggerin(handles.xem, EP_TRIGGERIN_DACFSM, EPBIT_DACFSM_RESETFIFO); 
    
end




% --- Executes on button press in pushbutton_bias_inc10.
function pushbutton_bias_inc10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bias_inc10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentbias = str2double(get(handles.text_biasvoltage,'String'));
set(handles.text_biasvoltage,'String',currentbias+10);
DAQ_updateDACvalues1(handles);



% --- Executes on button press in pushbutton_nbias_inc10.
function pushbutton_nbias_inc10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nbias_inc10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentbias = str2double(get(handles.text_biasvoltage,'String'));
set(handles.text_biasvoltage,'String',currentbias-10);
DAQ_updateDACvalues1(handles);


% --- Executes on button press in pushbutton_bias_inc1.
function pushbutton_bias_inc1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bias_inc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentbias = str2double(get(handles.text_biasvoltage,'String'));
set(handles.text_biasvoltage,'String',currentbias+1);
DAQ_updateDACvalues1(handles);



% --- Executes on button press in pushbutton_nbias_inc1.
function pushbutton_nbias_inc1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nbias_inc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentbias = str2double(get(handles.text_biasvoltage,'String'));
set(handles.text_biasvoltage,'String',currentbias-1);
DAQ_updateDACvalues1(handles);



% --- Executes on button press in pushbutton_bias1000.
function pushbutton_bias1000_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bias1000 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',1000);
DAQ_updateDACvalues1(handles);

% --- Executes on button press in pushbutton_prevbias.
function pushbutton_prevbias_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_prevbias (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DAQ_constants_include;

set(handles.text_biasvoltage,'String',DACprevious*1e3);
DAQ_updateDACvalues1(handles);



% --- Executes on button press in pushbutton_bias500.
function pushbutton_bias500_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bias500 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',500);
DAQ_updateDACvalues1(handles);

% --- Executes on button press in pushbutton_bias400.
function pushbutton_bias400_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bias400 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',400);
DAQ_updateDACvalues1(handles);

% --- Executes on button press in pushbutton_bias300.
function pushbutton_bias300_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bias300 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',300);
DAQ_updateDACvalues1(handles);

% --- Executes on button press in pushbutton_bias200.
function pushbutton_bias200_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bias200 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',200);
DAQ_updateDACvalues1(handles);

% --- Executes on button press in pushbutton_bias100.
function pushbutton_bias100_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bias100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',100);
DAQ_updateDACvalues1(handles);

% --- Executes on button press in pushbutton_bias50.
function pushbutton_bias50_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bias50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text_biasvoltage,'String',50);
DAQ_updateDACvalues1(handles);

% --- Executes on button press in pushbutton_nbias1000.
function pushbutton_nbias1000_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nbias1000 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',-1000);
DAQ_updateDACvalues1(handles);

% --- Executes on button press in pushbutton_nbias500.
function pushbutton_nbias500_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nbias500 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',-500);
DAQ_updateDACvalues1(handles);

% --- Executes on button press in pushbutton_nbias400.
function pushbutton_nbias400_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nbias400 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',-400);
DAQ_updateDACvalues1(handles);

% --- Executes on button press in pushbutton_nbias300.
function pushbutton_nbias300_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nbias300 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',-300);
DAQ_updateDACvalues1(handles);

% --- Executes on button press in pushbutton_nbias200.
function pushbutton_nbias200_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nbias200 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',-200);
DAQ_updateDACvalues1(handles);

% --- Executes on button press in pushbutton_nbias100.
function pushbutton_nbias100_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nbias100 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',-100);
DAQ_updateDACvalues1(handles);

% --- Executes on button press in pushbutton_nbias50.
function pushbutton_nbias50_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nbias50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',-50);
DAQ_updateDACvalues1(handles);





function edit_scalepA_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scalepA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scalepA as text
%        str2double(get(hObject,'String')) returns contents of edit_scalepA as a double


% --- Executes during object creation, after setting all properties.
function edit_scalepA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scalepA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_previewzero.
function checkbox_previewzero_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_previewzero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_previewzero


% --- Executes on button press in checkbox_voltagepolarity.
function checkbox_voltagepolarity_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_voltagepolarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_voltagepolarity



function edit_Cfast_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Cfast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Cfast as text
%        str2double(get(hObject,'String')) returns contents of edit_Cfast as a double


% --- Executes during object creation, after setting all properties.
function edit_Cfast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Cfast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_freqcomp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_freqcomp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_freqcomp as text
%        str2double(get(hObject,'String')) returns contents of edit_freqcomp as a double

DAQ_updateDPOTvalues1(handles);




% --- Executes during object creation, after setting all properties.
function edit_freqcomp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_freqcomp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_previewms_Callback(hObject, eventdata, handles)
% hObject    handle to edit_previewms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_previewms as text
%        str2double(get(hObject,'String')) returns contents of edit_previewms as a double

DAQ_constants_include;

PREVIEWtime = str2double(get(handles.edit_previewms,'String'))*1e-3;



% --- Executes during object creation, after setting all properties.
function edit_previewms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_previewms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_autopreview.
function checkbox_autopreview_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_autopreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_autopreview


% --- Executes on button press in checkbox_previewsymmetric.
function checkbox_previewsymmetric_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_previewsymmetric (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_previewsymmetric


% --- Executes on button press in checkbox_cfastrange.
function checkbox_cfastrange_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_cfastrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_cfastrange

DAQ_constants_include;

cfastrange = get(hObject,'Value')

EP_ACTIVELOWBITS = bitxor(EP_ACTIVELOWBITS,EPBIT_FASTC_CAPMUX)








function edit_logdir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_logdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_logdir as text
%        str2double(get(hObject,'String')) returns contents of edit_logdir as a double


% --- Executes during object creation, after setting all properties.
function edit_logdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_logdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_autounclog.
function checkbox_autounclog_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_autounclog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_autounclog



function edit_unclogthreshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_unclogthreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_unclogthreshold as text
%        str2double(get(hObject,'String')) returns contents of edit_unclogthreshold as a double


% --- Executes during object creation, after setting all properties.
function edit_unclogthreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_unclogthreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_zapmV_Callback(hObject, eventdata, handles)
% hObject    handle to edit_zapmV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_zapmV as text
%        str2double(get(hObject,'String')) returns contents of edit_zapmV as a double


% --- Executes during object creation, after setting all properties.
function edit_zapmV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_zapmV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_zapseconds_Callback(hObject, eventdata, handles)
% hObject    handle to edit_zapseconds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_zapseconds as text
%        str2double(get(hObject,'String')) returns contents of edit_zapseconds as a double


% --- Executes during object creation, after setting all properties.
function edit_zapseconds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_zapseconds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white'); 
end


% --- Executes on button press in pushbutton_zap.
function pushbutton_zap_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_zap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

getbiasmV = str2double(get(handles.text_biasvoltage,'String'));
zapbiasmV = str2double(get(handles.edit_zapmV,'String'));
zapseconds = str2double(get(handles.edit_zapseconds,'String'));
%set(handles.text_biasvoltage,'String',zapbiasmV);
DAQ_updateDACvalues_manual_zap(handles, zapbiasmV, zapseconds, getbiasmV);

%t = timer('StartDelay',zapseconds);
%t.TimerFcn = {@DAQ_updateDACvalues3, handles, getbiasmV};
%start(t);
 
        
 



function edit_unclogdelay_Callback(hObject, eventdata, handles)
% hObject    handle to edit_unclogdelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_unclogdelay as text
%        str2double(get(hObject,'String')) returns contents of edit_unclogdelay as a double


% --- Executes during object creation, after setting all properties.
function edit_unclogdelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_unclogdelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



 

%------------------------------------------------------------------------------------------------------------------------------------

% --- Executes on button press in pushbutton_forcetrigger.
function pushbutton_forcetrigger_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_forcetrigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DAQ_constants_include;
activatetriggerin(handles.xem, EP_TRIGGERIN_DACFSM, EPBIT_DACFSM_FORCETRIGGER);  




% --- Executes on button press in checkbox26.
function checkbox26_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox26
DAQ_constants_include;
ledvalue = get(hObject,'Value');
%setwireinvalue(handles.xem,EP_WIREIN_TEST1, ledvalue*EPBIT_LED0, EPBIT_LED0 );    
setwireinvalue(handles.xem,EP_WIREIN_TEST1, ledvalue, hex2dec('0001')); 
updatewireins(handles.xem);







function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double
% --- Executes during object creation, after setting all properties.

function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%---------------------------------------------------------------------------------------------------------------



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton58.
function pushbutton58_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pushbutton_zap.
thresholdoffsetvalue = str2double(get(handles.thresholdoffset,'String'));
DAQ_updateDACvalues6(handles, thresholdoffsetvalue);



function thresholdoffset_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdoffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresholdoffset as text
%        str2double(get(hObject,'String')) returns contents of thresholdoffset as a double


% --- Executes during object creation, after setting all properties.
function thresholdoffset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresholdoffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton60.
function pushbutton60_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile('*.csv', 'Pick a scan vector file');
if pathname ~= 0
    set(handles.edit34,'String',filename);
end

% --- Executes on button press in pushbutton57.
function pushbutton57_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

name = get(handles.edit34,'String');
DAQ_updateDACvalues_script_file(handles,name);


% --- Executes on button press in pushbutton61.
function pushbutton61_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton62.
function pushbutton62_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_DACfiforeset.
function pushbutton_DACfiforeset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_DACfiforeset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DAQ_constants_include;
activatetriggerin(handles.xem, EP_TRIGGERIN_DACFSM, EPBIT_DACFSM_RESETFIFO); 


% --- Executes on button press in wireout_test.
function wireout_test_Callback(hObject, eventdata, handles)
% hObject    handle to wireout_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DAQ_constants_include;
%FSM = str2double(getwireoutvalue(handles.xem, EP_WIREOUT_TEST1));


%readbytes = readfromblockpipeout(handles.xem, EP_PIPEOUT_ADC, ADC_xfer_blocksize, ADC_xfer_len, ADC_pkt_len);
%PIPEOUT_FSM_CURRENT_STATE
%readbytes = readfromblockpipeout(handles.xem, PIPEOUT_FSM_CURRENT_STATE, ADC_xfer_blocksize, ADC_xfer_blocksize);
%bytesread = length(readbytes);
%readvalues = typecast(readbytes,RAWDATAFORMAT);
%readvalues = cast(readvalues,'uint16');
%set(handles.text_FSM,'String',sprintf('CH1: \n  %0.5f \n',readvalues));







% --- Executes on button press in checkbox29.
function checkbox29_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox29


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_triggerdetected.
function text_triggerdetected_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text_triggerdetected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
