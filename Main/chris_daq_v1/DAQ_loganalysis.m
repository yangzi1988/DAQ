function varargout = DAQ_loganalysis(varargin)
% DAQ_LOGANALYSIS M-file for DAQ_loganalysis.fig
%      DAQ_LOGANALYSIS, by itself, creates a new DAQ_LOGANALYSIS or raises the existing
%      singleton*.
%
%      H = DAQ_LOGANALYSIS returns the handle to a new DAQ_LOGANALYSIS or the handle to
%      the existing singleton*.
%
%      DAQ_LOGANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DAQ_LOGANALYSIS.M with the given input arguments.
%
%      DAQ_LOGANALYSIS('Property','Value',...) creates a new DAQ_LOGANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DAQ_loganalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DAQ_loganalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DAQ_loganalysis

% Last Modified by GUIDE v2.5 17-Aug-2012 15:08:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DAQ_loganalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @DAQ_loganalysis_OutputFcn, ...
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


% --- Executes just before DAQ_loganalysis is made visible.
function DAQ_loganalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DAQ_loganalysis (see VARARGIN)

% Choose default command line output for DAQ_loganalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DAQ_loganalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DAQ_loganalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton_browselogfolder.
function pushbutton_browselogfolder_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_browselogfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentdir = get(handles.edit_logfolder,'String');

pathname = uigetdir(currentdir,'pick log folder');

if pathname ~= 0
    set(handles.edit_logfolder,'String',pathname);
end




% --- Executes on button press in pushbutton_browselogfile.
function pushbutton_browselogfile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_browselogfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentdir = get(handles.edit_logfolder,'String');

[filename, pathname, filterindex] = uigetfile(fullfile(currentdir,'*.log'), 'pick log file');

if filename ~= 0
    set(handles.edit_logfilename,'String',filename);
    set(handles.edit_logfolder,'String',pathname);
end




function edit_logfilename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_logfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_logfilename as text
%        str2double(get(hObject,'String')) returns contents of edit_logfilename as a double


% --- Executes during object creation, after setting all properties.
function edit_logfilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_logfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_exportcsv.
function pushbutton_exportcsv_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_exportcsv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_status,'String','[EXPORTING]');
set(handles.text_status,'BackgroundColor','yellow');

startindex = 1+ceil(str2double(get(handles.edit_savestarttime,'String'))*handles.previewsamplerate);
endindex = 1+ceil(str2double(get(handles.edit_saveendtime,'String'))*handles.previewsamplerate);

CSVtime = handles.previewtime(startindex:endindex);
CSVdata = handles.previewtrace(startindex:endindex);

% ~~~~~~~~~~~~

datafilename = fullfile(get(handles.edit_logfolder,'String'),get(handles.edit_logfilename,'String'));

[pathname,filename,fileextension] = fileparts(datafilename);
csvfilename = fullfile(pathname,[filename '_EXPORT.csv']);
dlmwrite(csvfilename,[CSVtime CSVdata],'delimiter',',','precision','%.8e')

pause(0.5);
set(handles.text_status,'String','[DONE]');
set(handles.text_status,'BackgroundColor','green');


function edit_kHzbandwidth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kHzbandwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kHzbandwidth as text
%        str2double(get(hObject,'String')) returns contents of edit_kHzbandwidth as a double


% --- Executes during object creation, after setting all properties.
function edit_kHzbandwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kHzbandwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_outputsamplerate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outputsamplerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_outputsamplerate as text
%        str2double(get(hObject,'String')) returns contents of edit_outputsamplerate as a double


% --- Executes during object creation, after setting all properties.
function edit_outputsamplerate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outputsamplerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_loadpreview.
function pushbutton_loadpreview_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadpreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

datafilename = fullfile(get(handles.edit_logfolder,'String'),get(handles.edit_logfilename,'String'));

if(~exist(datafilename))
    msgbox('.log file does not exist','Error','error')
end

% ~~~~~~~~~~~~

[pathname,filename,fileextension] = fileparts(datafilename);
matfilename = fullfile(pathname,[filename '.mat']);

% defaults
SETUP_TIAgain=100e6;
SETUP_preADCgain=1;
SETUP_pAoffset=0;
SETUP_mVoffset=0;
SETUP_ADCVREF=2.48;
SETUP_ADCBITS=14;
% /defaults

if(exist(matfilename))
    load(matfilename);
else
    msgbox('.mat file does not exist','Error','error')
end

samplerate = ADCSAMPLERATE;
TIAgain = SETUP_TIAgain;
preADCgain = SETUP_preADCgain;
currentoffset = SETUP_pAoffset;
voltageoffset = SETUP_mVoffset;
ADCvref = SETUP_ADCVREF;
ADCbits = SETUP_ADCBITS;

closedloop_gain = TIAgain*preADCgain;

% ~~~~~~~~~~~~

LPfiltercutoff = 1e3*str2double(get(handles.edit_kHzbandwidth,'String'));
outputsamplerate = 1e3*str2double(get(handles.edit_outputsamplerate,'String'));

% ~~~~~~~~~~~~
set(handles.text_status,'String','[LOADING]');
set(handles.text_status,'BackgroundColor','red');
plot(handles.axes_tracepreview,[0 1],[0 0],'r');
xlabel('Time (s)');
ylabel('Current (A)');
pause(0.1);
% ~~~~~~~~~~~~


readfid = fopen(datafilename,'r');

%right-justified
%logdata = ( -ADCvref + (2*ADCvref) * double(mod(fread(readfid,'uint16'),2^ADCbits)) / 2^ADCbits ) / (TIAgain*preADCgain);

%left-justified
%     bitmask = (2^16 - 1) - (2^(16-ADCbits) - 1);
%     rawvalues = fread(readfid,'uint16');
%     readvalues = bitand(cast(rawvalues,'uint16'),bitmask);
%     logdata = ( -ADCvref + (2*ADCvref) * double(readvalues) / 2^16 ) / (TIAgain*preADCgain);
    
bitmask = (2^16 - 1) - (2^(16-ADCbits) - 1);
rawvalues = fread(readfid,'uint16');
readvalues = bitand(cast(rawvalues,'uint16'),bitmask);
logdata = -ADCvref + (2*ADCvref) * double(readvalues) / 2^16;
    
    
logdata = -logdata./closedloop_gain + currentoffset;

fclose(readfid);

filterorder = floor(samplerate/LPfiltercutoff*16);      % EDITED 8/15/2012
myLPfilter = fir1(filterorder, LPfiltercutoff/(0.5*samplerate), 'low');
logdata = filter(myLPfilter,1,logdata);

[P,Q] = rat(outputsamplerate/samplerate,0.02);
set(handles.edit_outputsamplerate,'String',samplerate*P/Q*1e-3)
%logdata = resample(logdata,P,Q);

logdata = resample(logdata,P,Q,0);

logdata = logdata(filterorder:(length(logdata)-filterorder));

t = (1:length(logdata))' ./ outputsamplerate;

plot(handles.axes_tracepreview,t*1e3,logdata*1e12);
xlabel('Time (ms)');
ylabel('Current (pA)');


handles.LPfiltercutoff = LPfiltercutoff;
handles.outputsamplerate = outputsamplerate;
handles.previewtrace = logdata;
handles.previewtime = t;
handles.previewsamplerate = outputsamplerate;
handles.samplerate = samplerate;
handles.TIAgain = TIAgain;
handles.preADCgain = preADCgain;
handles.ADCvref = ADCvref;
handles.bits = ADCbits;

guidata(hObject, handles);

% ~~~~~~~~~~~~

set(handles.text_status,'String','[DONE]');
set(handles.text_status,'BackgroundColor','green');

% ~~~~~~~~~~~~



function edit_savestarttime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_savestarttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_savestarttime as text
%        str2double(get(hObject,'String')) returns contents of edit_savestarttime as a double


% --- Executes during object creation, after setting all properties.
function edit_savestarttime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_savestarttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_saveendtime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_saveendtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_saveendtime as text
%        str2double(get(hObject,'String')) returns contents of edit_saveendtime as a double


% --- Executes during object creation, after setting all properties.
function edit_saveendtime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_saveendtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_logfolder_Callback(hObject, eventdata, handles)
% hObject    handle to edit_logfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_logfolder as text
%        str2double(get(hObject,'String')) returns contents of edit_logfolder as a double


% --- Executes during object creation, after setting all properties.
function edit_logfolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_logfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



set(handles.text_status,'String','[EXPORTING]');
set(handles.text_status,'BackgroundColor','yellow');

startindex = 1+ceil(str2double(get(handles.edit_savestarttime,'String'))*handles.previewsamplerate);
endindex = 1+ceil(str2double(get(handles.edit_saveendtime,'String'))*handles.previewsamplerate);

%MATtime = handles.previewtime(startindex:endindex);
MATdata = handles.previewtrace(startindex:endindex);

% ~~~~~~~~~~~~

datafilename = fullfile(get(handles.edit_logfolder,'String'),get(handles.edit_logfilename,'String'));

[pathname,filename,fileextension] = fileparts(datafilename);
matfilename = fullfile(pathname,[filename '_EXPORT.mat']);

save(matfilename,'MATdata');


pause(0.5);
set(handles.text_status,'String','[DONE]');
set(handles.text_status,'BackgroundColor','green');
