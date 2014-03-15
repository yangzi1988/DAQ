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

% Last Modified by GUIDE v2.5 14-Mar-2014 18:06:31

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

DAQ_constants_include;

DAQ_constants_init;

stored_setup_restore(handles);

color_gui(handles);


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




function edit_scanvectorfile_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton_scanvector_Callback(hObject, eventdata, handles)

[filename, pathname, filterindex] = uigetfile('VECTOR*.m', 'Pick a scan vector file');
if filename ~= 0
    set(handles.edit_scanvectorfile,'String',filename);
end


function pushbutton_sendscanvector_Callback(hObject, eventdata, handles)

DAQ_constants_include;

scanvectorfile = get(handles.edit_scanvectorfile,'String');

[pathstr, name, ext, versn] = fileparts(scanvectorfile);
getvector = eval(name);

% --- display vector ---
% vectorlength = length(getvector);
% printscanvector = dec2bin(getvector,16);
%toplot = dec2bin(getvector,16)-'0';
%toplot = 0.5*toplot + ones(vectorlength,1) * (15:-1:0);
%figure; stairs(toplot);
% ---------------

ADClogreset=1;

DAQ_sendscanvector(handles.xem, getvector);


DAQ_updateDAC(handles);



function figure1_CloseRequestFcn(hObject, eventdata, handles)

DAQ_constants_include;

if(exist('handles.triggertimer'))
    stop(handles.triggertimer);
    delete(handles.triggertimer);
end

if(exist('handles.bandwidthtimer'))
    stop(handles.bandwidthtimer);
    delete(handles.bandwidthtimer);
end

store_setup(handles);
daq_initialized = 0;

% Hint: delete(hObject) closes the figure
delete(hObject);


function popupmenu1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function checkbox5_Callback(hObject, eventdata, handles)

DAQ_constants_include;

ADCcaptureenable = get(hObject,'Value');


function edit_logname_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkbox_enablelogging_Callback(hObject, eventdata, handles)

DAQ_constants_include;

newlogenable = get(hObject,'Value');

if newlogenable == 1

    %{
    mysamplerate = sprintf('_%dksps',ADCSAMPLERATE/1000);
    mytimestamp = datestr(now,'_yyyymmdd_HHMMSS');
    logfilename = [get(handles.edit_logname,'String') mysamplerate mytimestamp '.log']
    logADCfid = fopen(logfilename,'a');
    %}
    %logenable=1;

    ADClogreset = 1;
    ADClogenable = 1;
    
else
    ADClogenable = 0;
    
    fclose(logADCfid);
    logADCfid=0;
    
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
DAQ_updateDAC(handles);




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

DAQ_constants_include;

R_f_preamp = str2double(get(handles.edit_gain_Mohm,'String'))*1e6;
TIAgain = R_f_preamp;
fc1_preamp = 1/(2*pi*R_f_preamp*C_f_preamp);



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

DAQ_constants_include;

preADCgain = str2double(get(handles.edit_preADCgain,'String'));

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
DAQ_updateDAC(handles);







% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentbias = str2double(get(handles.text_biasvoltage,'String'));
set(handles.text_biasvoltage,'String',currentbias+100);
DAQ_updateDAC(handles);




% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentbias = str2double(get(handles.text_biasvoltage,'String'));
set(handles.text_biasvoltage,'String',currentbias-100);
DAQ_updateDAC(handles);






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





% --- Executes on button press in btn_zero_current.
function btn_zero_current_Callback(hObject, eventdata, handles)
% hObject    handle to btn_zero_current (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DAQ_constants_include;

DAQ_autozerocurrent(handles)





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

DAQ_updateDAC(handles);


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
DAQ_updateDAC(handles);





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




% --- Executes on button press in btn_zero_voltage.
function btn_zero_voltage_Callback(hObject, eventdata, handles)
% hObject    handle to btn_zero_voltage (see GCBO)
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

daq_initialized = 1;

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

    DAQ_updateDAC(handles);
    DAQ_updateDPOT(handles);

    % turn on ADC stream
    ADCcaptureenable = 1;
    set(handles.checkbox5,'Value',1);

    
    % select filtered signal mux
    set(handles.popupmenu2,'Value',ADCMUXDEFAULT);
    popupmenu2_Callback(handles.popupmenu2, [], handles)

    % init complete, change button to green
    set(handles.pushbuttonOKinit,'BackgroundColor',lightgreen)

    start(handles.bandwidthtimer);
    start(handles.triggertimer);
    
   
end

enable_compensations(hObject, eventdata, handles)



% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentbias = str2double(get(handles.text_biasvoltage,'String'));
set(handles.text_biasvoltage,'String',currentbias+10);
DAQ_updateDAC(handles);



% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentbias = str2double(get(handles.text_biasvoltage,'String'));
set(handles.text_biasvoltage,'String',currentbias-10);
DAQ_updateDAC(handles);


% --- Executes on button press in pushbutton30.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentbias = str2double(get(handles.text_biasvoltage,'String'));
set(handles.text_biasvoltage,'String',currentbias+1);
DAQ_updateDAC(handles);



% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentbias = str2double(get(handles.text_biasvoltage,'String'));
set(handles.text_biasvoltage,'String',currentbias-1);
DAQ_updateDAC(handles);



% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',1000);
DAQ_updateDAC(handles);

% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DAQ_constants_include;

set(handles.text_biasvoltage,'String',DACprevious*1e3);
DAQ_updateDAC(handles);



% --- Executes on button press in pushbutton35.
function pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',500);
DAQ_updateDAC(handles);

% --- Executes on button press in pushbutton36.
function pushbutton36_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',400);
DAQ_updateDAC(handles);

% --- Executes on button press in pushbutton37.
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',300);
DAQ_updateDAC(handles);

% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',200);
DAQ_updateDAC(handles);

% --- Executes on button press in pushbutton39.
function pushbutton39_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',100);
DAQ_updateDAC(handles);

% --- Executes on button press in pushbutton40.
function pushbutton40_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',50);
DAQ_updateDAC(handles);

% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',-1000);
DAQ_updateDAC(handles);

% --- Executes on button press in pushbutton42.
function pushbutton42_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',-500);
DAQ_updateDAC(handles);

% --- Executes on button press in pushbutton43.
function pushbutton43_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',-400);
DAQ_updateDAC(handles);

% --- Executes on button press in pushbutton44.
function pushbutton44_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',-300);
DAQ_updateDAC(handles);

% --- Executes on button press in pushbutton45.
function pushbutton45_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',-200);
DAQ_updateDAC(handles);

% --- Executes on button press in pushbutton46.
function pushbutton46_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',-100);
DAQ_updateDAC(handles);

% --- Executes on button press in pushbutton47.
function pushbutton47_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_biasvoltage,'String',-50);
DAQ_updateDAC(handles);





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

DAQ_updateDPOT(handles);




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

% 1234:
% getbiasmV = str2double(get(handles.text_biasvoltage,'String'));
% zapbiasmV = str2double(get(handles.edit_zapmV,'String'));
% zapseconds = str2double(get(handles.edit_zapseconds,'String'));
% 
% set(handles.text_biasvoltage,'String',zapbiasmV);
% DAQ_updateDAC(handles);
% 
% t = timer('StartDelay',zapseconds);
% t.TimerFcn = {@DAQ_auto_zap, handles, getbiasmV};
% start(t);

 DAQ_manual_zap(handles)
        
        



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







function edit_Cfast_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Cfast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DAQ_updateDAC(handles);

% Hints: get(hObject,'String') returns contents of edit_Cfast as text
%        str2double(get(hObject,'String')) returns contents of edit_Cfast as a double

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbuttonOKinit.
function pushbuttonOKinit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonOKinit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes_trace_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_trace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_trace


% --- Executes during object creation, after setting all properties.
function text_adcfifolevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_adcfifolevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox29.
function checkbox29_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox29



function edit_Cslow_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Cslow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DAQ_updateDPOT(handles);

% Hints: get(hObject,'String') returns contents of edit_Cslow as text
%        str2double(get(hObject,'String')) returns contents of edit_Cslow as a double


% --- Executes during object creation, after setting all properties.
function edit_Cslow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Cslow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Rseries_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Rseries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DAQ_updateDPOT(handles);

% Hints: get(hObject,'String') returns contents of edit_Rseries as text
%        str2double(get(hObject,'String')) returns contents of edit_Rseries as a double


% --- Executes during object creation, after setting all properties.
function edit_Rseries_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Rseries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Rs_comp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Rs_comp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DAQ_updateDPOT(handles);

% Hints: get(hObject,'String') returns contents of edit_Rs_comp as text
%        str2double(get(hObject,'String')) returns contents of edit_Rs_comp as a double


% --- Executes during object creation, after setting all properties.
function edit_Rs_comp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Rs_comp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Supercharge_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Supercharge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DAQ_updateDPOT(handles);

% Hints: get(hObject,'String') returns contents of edit_Supercharge as text
%        str2double(get(hObject,'String')) returns contents of edit_Supercharge as a double


% --- Executes during object creation, after setting all properties.
function edit_Supercharge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Supercharge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in autotuneCfast.
function autotuneCfast_Callback(hObject, eventdata, handles)
% hObject    handle to autotuneCfast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
% % Set Gui Components
% set(handles.checkbox_autopreview,'Value',0);
% set(handles.text_biasvoltage,'String',0);
% DAQ_updateDAC(handles);
% 
% % Initialization
% cf1 = 1; % initial Cf [pF]
% cf2 = 50; % final Cf [pF]
% N = 10; %number of samples
% vpeaks = zeros(1,N); % intialize peak amplitudes
% caps = linspace(cf1,cf2,N);
% 
% % Acquistion
% for i = 1:1:N
%     set(handles.edit_Cfast,'String',caps(i));
%     
%     set(handles.text_biasvoltage,'String',0);
%     DAQ_updateDAC(handles);
%      
% %     pause(0.5)
%     
%     set(handles.text_biasvoltage,'String',1);
%     DAQ_updateDAC(handles);
%     
% %     pause(0.5)
%     
%     set(handles.text_biasvoltage,'String',0);
%     DAQ_updateDAC(handles);
%     
% %     childs = get(handles.figure1,'Children')
% %     allAxesInFigure = findall(handles.figure1,'type','axes')
% %     figure(handles.figure1);
% %     axes(handles.axes_trace);
%     ch=get(handles.axes_trace,'Children');
%     x=get(ch,'Xdata');
%     y=get(ch,'Ydata');
% %     y = get(childs,'YData');
% %     figure()
% %     hold on
% %     plot(y)
% end
% 
% % Restore Gui Components
% set(handles.checkbox_autopreview,'Value',1);
% 
%     
% 
% function changeV(vnew1) 
%    
%     
% function getmax(vnew1)
%     set(handles.text_biasvoltage,'String',vnew1);
%     DAQ_updateDAC(handles);






% --- Executes on button press in checkbox_enabledebugreport.
function checkbox_enabledebugreport_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_enabledebugreport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DAQ_constants_include;

show_debug_report = get(hObject,'Value');


% --- Executes on button press in pushbutton_reset_offsets.
function pushbutton_reset_offsets_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset_offsets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DAQ_constants_include;

set(handles.edit_pAoffset,'String',0);
set(handles.edit_mVoffset,'String',0);

% DAQ_autozerocurrent(handles)
% DAQ_autozerooffsetvoltage([],[],handles,0);


% --- Executes on button press in enable_comp_cfast.
function enable_comp_cfast_Callback(hObject, eventdata, handles)
% hObject    handle to enable_comp_cfast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable_comp_cfast
enable_compensations(hObject, eventdata, handles)

% --- Executes on button press in enable_comp_cslow.
function enable_comp_cslow_Callback(hObject, eventdata, handles)
% hObject    handle to enable_comp_cslow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable_comp_cslow
enable_compensations(hObject, eventdata, handles)

% --- Executes on button press in enable_comp_rseries.
function enable_comp_rseries_Callback(hObject, eventdata, handles)
% hObject    handle to enable_comp_rseries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable_comp_rseries
enable_compensations(hObject, eventdata, handles)

% --- Executes on button press in enable_comp_reseries_correction.
function enable_comp_reseries_correction_Callback(hObject, eventdata, handles)
% hObject    handle to enable_comp_reseries_correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable_comp_reseries_correction
enable_compensations(hObject, eventdata, handles)

% --- Executes on button press in enable_comp_supercharge.
function enable_comp_supercharge_Callback(hObject, eventdata, handles)
% hObject    handle to enable_comp_supercharge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable_comp_supercharge
enable_compensations(hObject, eventdata, handles)









% --- Executes on button press in enable_comp_supercharge.
function checkbox43_Callback(hObject, eventdata, handles)
% hObject    handle to enable_comp_supercharge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of enable_comp_supercharge


% --- Executes on button press in reset_param_btn.
function reset_param_btn_Callback(hObject, eventdata, handles)
% hObject    handle to reset_param_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reset_parameters = 1;
% set(handles.edit_gain_Mohm,'String',);

function enable_debug_level_Callback(hObject, eventdata, handles)
% hObject    handle to enable_debug_level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enable_debug_level as text
%        str2double(get(hObject,'String')) returns contents of enable_debug_level as a double

DAQ_constants_include;

show_debug_report = str2num(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function enable_debug_level_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enable_debug_level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in repeat_bias.
function repeat_bias_Callback(hObject, eventdata, handles)
% hObject    handle to repeat_bias (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of repeat_bias



function repeat_times_Callback(hObject, eventdata, handles)
% hObject    handle to repeat_times (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repeat_times as text
%        str2double(get(hObject,'String')) returns contents of repeat_times as a double


% --- Executes during object creation, after setting all properties.
function repeat_times_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repeat_times (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function text_triggerdetected_Callback(hObject, eventdata, handles)
% hObject    handle to text_triggerdetected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_triggerdetected as text
%        str2double(get(hObject,'String')) returns contents of text_triggerdetected as a double


% --- Executes during object creation, after setting all properties.
function text_triggerdetected_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_triggerdetected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_FSMee_Callback(hObject, eventdata, handles)
% hObject    handle to text_FSMee (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_FSMee as text
%        str2double(get(hObject,'String')) returns contents of text_FSMee as a double


% --- Executes during object creation, after setting all properties.
function text_FSMee_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_FSMee (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_FSM_Callback(hObject, eventdata, handles)
% hObject    handle to text_FSM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_FSM as text
%        str2double(get(hObject,'String')) returns contents of text_FSM as a double


% --- Executes during object creation, after setting all properties.
function text_FSM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_FSM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit52_Callback(hObject, eventdata, handles)
% hObject    handle to edit52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit52 as text
%        str2double(get(hObject,'String')) returns contents of edit52 as a double


% --- Executes during object creation, after setting all properties.
function edit52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
