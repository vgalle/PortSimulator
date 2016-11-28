function varargout = simple_GUI(varargin)
global stop
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

% Last Modified by GUIDE v2.5 10-May-2015 12:33:26

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
handles.initialized = 0;

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
set(handles.RTG,'String',str2double(get(hObject, 'String')));

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

% --- Executes on button press in pushbutton1.
function initialize_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

err=0;

if get(handles.complete,'value')
%     set(handles.Block, 'String', '1');
    handles.isFullInfo = 1;
else
%     set(handles.Block, 'String', '2');
    handles.isFullInfo = 0;
end

handles.heuristic_relocation_value = get(handles.heu_rel, 'value');
handles.heuristic_stacking_value = get(handles.heu_stack, 'value');

switch handles.heuristic_relocation_value
    case 1
        msgbox('Select a relocation heuristic.');
        return
    case 2
        handles.heuristic_relocation = 'Myopic';
    case 3
        handles.heuristic_relocation = 'RI';
    case 4
        handles.heuristic_relocation = 'Lowest_Height';
end

switch handles.heuristic_stacking_value
    case 1
        msgbox('Select a stacking heuristic.');
        err=1;
    case 2
        handles.heuristic_stacking = 'Myopic';
    case 3
        handles.heuristic_stacking = 'RI';
    case 4
        handles.heuristic_stacking = 'Lowest_Height';
end

% Update handles structure
guidata(hObject, handles);

if ~err
    
    handles.initialized = 1;

    % Update handles structure
    guidata(hObject, handles);

    is_full_info = handles.isFullInfo;
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
    n_BC = str2double(get(handles.BC,'String'));
    n_RTG = str2double(get(handles.RTG,'String'));
    n_trucks = str2double(get(handles.Trucks,'String'));
    
    display('Initialization complete!')

    [Blocks,Rows,Containers, Ships, BerthCranes, RTGs, max_zone, defined_horizon] = Initialization...
        (is_full_info,Lambda,Mu,num_ships,container_per_ship,num_blocks,num_rows,num_cols,num_tiers,Gamma,Horizon,n_BC,n_RTG,n_trucks,numDays)
    % assignin('base', 'Blocks', Blocks)
    % assignin('base', 'Rows', Rows)
    % assignin('base', 'Containers', Containers)
    % assignin('base', 'Ships', Ships)
    % assignin('base', 'BerthCranes', BerthCranes)
    % assignin('base', 'RTGs', RTGs)
    % assignin('base', 'max_zone', max_zone)
    % assignin('base', 'defined_horizon', defined_horizon)

    handles.Blocks = Blocks;
    handles.Rows= Rows;
    handles.Containers= Containers;
    handles.Ships= Ships;
    handles.BerthCranes= BerthCranes;
    handles.RTGs= RTGs;
    handles.max_zone= max_zone;
    handles.defined_horizon= defined_horizon;

    % Update handles structure
    guidata(hObject, handles);


    set(handles.log,'String','Initialization complete!')
end

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

% Heuristic_reloc='Myopic';
% Heuristic_stack='Myopic';

global stop
handles.stop = 0;
% Update handles structure
guidata(hObject, handles);
stop = handles.stop;

if handles.initialized
    within_same_row=get(handles.sameRow,'value');

    [N_reloc,N_retrieval,N_stacked,Time,FinalBlocks,FinalRows,FinalContainers,FinalRTGs, FinalBerthCranes] = ...
        Simulator(handles.Blocks,handles.Rows,handles.Containers, handles.BerthCranes, handles.RTGs,handles.Ships,... 
                  handles.heuristic_relocation,handles.heuristic_stacking,within_same_row);

    handles.N_reloc = N_reloc;
    handles.N_retrieval=N_retrieval;
    handles.N_stacked=N_stacked;
    handles.Time=Time;
    handles.FinalBlocks=FinalBlocks;
    handles.FinalRows=FinalRows;
    handles.FinalContainers=FinalContainers;
    handles.FinalRTGs=FinalRTGs;
    handles.FinalBerthCranes=FinalBerthCranes;

    set(handles.log,'String','Simulation complete!')
    handles.initialized = 0;
    
    % Update handles structure
    guidata(hObject, handles);
else
    msgbox('First initialize the problem!');
end


% --- Executes when selected object is changed in info.
function info_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in info 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if (hObject == handles.complete)
%     set(handles.Block, 'String', '1');
    handles.isFullInfo = 1;
else
%     set(handles.Block, 'String', '2');
    handles.isFullInfo = 0;
end

% Update handles structure
guidata(hObject, handles);



function BC_Callback(hObject, eventdata, handles)
% hObject    handle to BC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BC as text
%        str2double(get(hObject,'String')) returns contents of BC as a double


% --- Executes during object creation, after setting all properties.
function BC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RTG_Callback(hObject, eventdata, handles)
% hObject    handle to RTG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RTG as text
%        str2double(get(hObject,'String')) returns contents of RTG as a double


% --- Executes during object creation, after setting all properties.
function RTG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RTG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in 
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.complete,'value',1);
set(handles.Block,'String','');
set(handles.Row,'String','');
set(handles.Column,'String','');
set(handles.Tier,'String','');
set(handles.Lambda,'String','');
set(handles.Mu,'String','');
set(handles.Gamma,'String','');
set(handles.Horizon,'String','');
set(handles.num_vessels,'String','');
set(handles.cont_per_vessel,'String','');
set(handles.BC,'String','');
set(handles.RTG,'String','');


% --- Executes on button press in sample.
function sample_Callback(hObject, eventdata, handles)
% hObject    handle to sample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
% if (hObject == handles.complete)
% %     set(handles.Block, 'String', '1');
%     handles.isFullInfo = 1;
% else
% %     set(handles.Block, 'String', '2');
%     handles.isFullInfo = 0;
% end

% Update handles structure
guidata(hObject, handles);

set(handles.complete,'value',1);
set(handles.Block,'String','5');
set(handles.Row,'String','10');
set(handles.Column,'String','7');
set(handles.Tier,'String','4');
set(handles.Lambda,'String','0.2');
set(handles.Mu,'String','0.05');
set(handles.Gamma,'String','0.8');
set(handles.Horizon,'String','30');
set(handles.num_vessels,'String','5');
set(handles.cont_per_vessel,'String','100');
set(handles.BC,'String','1');
set(handles.RTG,'String','5');


% --- Executes on selection change in heu_rel.
function heu_rel_Callback(hObject, eventdata, handles)
% hObject    handle to heu_rel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns heu_rel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from heu_rel


% --- Executes during object creation, after setting all properties.
function heu_rel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to heu_rel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in heu_stack.
function heu_stack_Callback(hObject, eventdata, handles)
% hObject    handle to heu_stack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns heu_stack contents as cell array
%        contents{get(hObject,'Value')} returns selected item from heu_stack


% --- Executes during object creation, after setting all properties.
function heu_stack_CreateFcn(hObject, eventdata, handles)
% hObject    handle to heu_stack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in checkbox1.
function sameRow_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

handles.initialized = 0;
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop
handles.stop = 1;
% Update handles structure
guidata(hObject, handles);
stop= handles.stop;


% --- Executes on button press in results.
function results_Callback(hObject, eventdata, handles)
% hObject    handle to results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
results
assignin('base', 'handles1', handles)



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
