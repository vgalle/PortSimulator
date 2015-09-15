function varargout = simple_GUI(varargin)
% SIMPLE_GUI MATLAB code for simple_GUI.fig
%      SIMPLE_GUI, by itself, creates a new SIMPLE_GUI or raises the existing
%      singleton*.
%
%      H = SIMPLE_GUI returns the handle to a new SIMPLE_GUI or the handle to
%      the existing singleton*.
%
%      SIMPLE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLE_GUI.M with the given input arguments.
%
%      SIMPLE_GUI('Property','Value',...) creates a new SIMPLE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simple_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simple_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simple_GUI

% Last Modified by GUIDE v2.5 05-Feb-2015 23:30:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simple_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @simple_GUI_OutputFcn, ...
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


% --- Executes just before simple_GUI is made visible.
function simple_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simple_GUI (see VARARGIN)

% Choose default command line output for simple_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simple_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simple_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Block_Callback(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text1 as text
%        str2double(get(hObject,'String')) returns contents of text1 as a double

% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Row_Callback(hObject, eventdata, handles)
% hObject    handle to Row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Row as text
%        str2double(get(hObject,'String')) returns contents of Row as a double


% --- Executes during object creation, after setting all properties.
function Row_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Column_Callback(hObject, eventdata, handles)
% hObject    handle to Column (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Column as text
%        str2double(get(hObject,'String')) returns contents of Column as a double


% --- Executes during object creation, after setting all properties.
function Column_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Column (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tier_Callback(hObject, eventdata, handles)
% hObject    handle to Tier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tier as text
%        str2double(get(hObject,'String')) returns contents of Tier as a double


% --- Executes during object creation, after setting all properties.
function Tier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function radiobutton1_Callback(hObject, eventdata, handles)
is_full_info = get(handles.radiobutton1,'Value');

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global maxZone

% is_full_info = get(handles.radiobutton1,'Value');
num_blocks = str2double(get(handles.Block,'String'));
num_rows = str2double(get(handles.Row,'String'));
num_cols = str2double(get(handles.Column,'String'));
num_tiers = str2double(get(handles.Tier,'String'));

Lambda = str2double(get(handles.Lambda,'String'));
Mu = str2double(get(handles.Mu,'String'));
Gamma = str2double(get(handles.Gamma,'String'));
Horizon = str2double(get(handles.Horizon,'String'));

num_ships = str2double(get(handles.num_vessels,'String'));
container_per_ship = str2double(get(handles.cont_per_vessel,'String'));

display('Initialization complete!')

[Blocks,Rows,Containers, maxZone] = Initialization2(is_full_info,Lambda, Mu,num_ships,container_per_ship,...
    num_blocks,num_rows,num_cols, num_tiers,Gamma,Horizon);

assignin('base', 'Blocks', Blocks)
assignin('base', 'Rows', Rows)
assignin('base', 'Containers', Containers)

set(handles.log,'String','Initialization complete!')


function Lambda_Callback(hObject, eventdata, handles)
% hObject    handle to Lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Lambda as text
%        str2double(get(hObject,'String')) returns contents of Lambda as a double


% --- Executes during object creation, after setting all properties.
function Lambda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Mu_Callback(hObject, eventdata, handles)
% hObject    handle to Mu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mu as text
%        str2double(get(hObject,'String')) returns contents of Mu as a double


% --- Executes during object creation, after setting all properties.
function Mu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Gamma_Callback(hObject, eventdata, handles)
% hObject    handle to Gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Gamma as text
%        str2double(get(hObject,'String')) returns contents of Gamma as a double


% --- Executes during object creation, after setting all properties.
function Gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Horizon_Callback(hObject, eventdata, handles)
% hObject    handle to Horizon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Horizon as text
%        str2double(get(hObject,'String')) returns contents of Horizon as a double


% --- Executes during object creation, after setting all properties.
function Horizon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Horizon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Block_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_vessels_Callback(hObject, eventdata, handles)
% hObject    handle to num_vessels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_vessels as text
%        str2double(get(hObject,'String')) returns contents of num_vessels as a double


% --- Executes during object creation, after setting all properties.
function num_vessels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_vessels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cont_per_vessel_Callback(hObject, eventdata, handles)
% hObject    handle to cont_per_vessel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cont_per_vessel as text
%        str2double(get(hObject,'String')) returns contents of cont_per_vessel as a double


% --- Executes during object creation, after setting all properties.
function cont_per_vessel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cont_per_vessel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in simulate.
function simulate_Callback(hObject, eventdata, handles)
% hObject    handle to simulate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[N_reloc,N_retrieval,Time,Blocks,Rows,Containers,Blocksi,Rowsi,Containersi] = ...
    Simulator(Blocks,Rows,Containers,20,5,'Myopic',1)
display('kqwjdd')
