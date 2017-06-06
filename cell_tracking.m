function varargout = cell_tracking(varargin)
% CELL_TRACKING MATLAB code for cell_tracking.fig
%      CELL_TRACKING, by itself, creates a new CELL_TRACKING or raises the existing
%      singleton*.
%
%      H = CELL_TRACKING returns the handle to a new CELL_TRACKING or the handle to
%      the existing singleton*.
%
%      CELL_TRACKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELL_TRACKING.M with the given input arguments.
%
%      CELL_TRACKING('Property','Value',...) creates a new CELL_TRACKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cell_tracking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cell_tracking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cell_tracking

% Last Modified by GUIDE v2.5 28-Feb-2017 18:04:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cell_tracking_OpeningFcn, ...
                   'gui_OutputFcn',  @cell_tracking_OutputFcn, ...
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


% --- Executes just before cell_tracking is made visible.
function cell_tracking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cell_tracking (see VARARGIN)

% Choose default command line output for cell_tracking
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cell_tracking wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cell_tracking_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1 - Select file to analyze
function pushbutton1_Callback(hObject, eventdata, handles)
global path file
% hObject    handle to pushbutton1 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile({'*.tif;*.czi'},'Select your image stack:');
set(handles.edit2,'String',file)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1 - WATERSHED option
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global water
water = get(hObject,'Value');

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in pushbutton2 - COUNT!
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
global file path filter_size size_thresh keep cmap
filter_size = get(handles.edit1,'String');
size_thresh = get(handles.edit3,'String');
fname = [path,file];
[mat,struct,original] = count_cells_watershed(fname);
% plot ROI counts
r = numel(mat);
time = 1:r;
axes(handles.axes1);
plot(time,mat);
xlabel('Time point'); ylabel('Number of ROIs');
if keep == 1
    hold on
end
% Save the data from count_cells in the handles structure
handles.cell_counts = mat;
handles.roi_data = struct;
handles.original_stack = original;
% Display first image of stack
axes(handles.axes2);
handles.axes2 = imshow(handles.original_stack{1},'ColorMap',cmap); %,'Parent',handles.imageDisplay);
% Update slider
set(handles.slider1,'Min',1,'Max',size(original,1),'SliderStep',[1 1]./(numel(original)-1),'Value',1)
% Update handles structure
guidata(hObject,handles);


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- pushbutton3 - Export Data
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
global file
counts_matrix = handles.cell_counts;
filen = [file(1:end-3),'csv'];
csvwrite(filen,counts_matrix)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla reset


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
global keep
keep = get(hObject,'Value');


% pushbutton6 - EXPORT FIGURE
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file
axes(handles.axes1);
ax = gca;
e_fig = figure;
copyobj(ax,e_fig);
roi_name = get(handles.edit5,'String');
fig_file = [file(1:end-4),'_',roi_name,'.fig'];
hgsave(e_fig,fig_file)



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% pushbutton7 - TRACKING BUTTON
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
roi_info = handles.roi_data;
stack_one = handles.original_stack;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
index = get(hObject,'Value');
set(handles.axes2,'CData',handles.original_stack{index});


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Min',1);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf)



a
