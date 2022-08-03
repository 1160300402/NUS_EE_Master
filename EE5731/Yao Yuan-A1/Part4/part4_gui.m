function varargout = part4_gui(varargin)
% PART4_GUI MATLAB code for part4_gui.fig
%      PART4_GUI, by itself, creates a new PART4_GUI or raises the existing
%      singleton*.
%
%      H = PART4_GUI returns the handle to a new PART4_GUI or the handle to
%      the existing singleton*.
%
%      PART4_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PART4_GUI.M with the given input arguments.
%
%      PART4_GUI('Property','Value',...) creates a new PART4_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before part4_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to part4_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help part4_gui

% Last Modified by GUIDE v2.5 09-Oct-2021 10:08:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @part4_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @part4_gui_OutputFcn, ...
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


% --- Executes just before part4_gui is made visible.
function part4_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to part4_gui (see VARARGIN)

% Choose default command line output for part4_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

axes(handles.axes1)
path1 = '..\assg1\im02.jpg';
img_1 = imread(path1);
global global_img_1;
global_img_1 = img_1;
img1 = image(img_1);
img1.ButtonDownFcn = @img_clickFcn;
set(handles.uipanel1,'Title','Picture1')

axes(handles.axes2)
path2 = '..\assg1\im01.jpg';
img_2 = imread(path2);
global global_img_2;
global_img_2 = img_2;
img2 = image(img_2);
img2.ButtonDownFcn = @img_clickFcn;
set(handles.uipanel2,'Title','Picture2')


% --- Outputs from this function are returned to the command line.
function varargout = part4_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
uiwait(gcf)
img1_mat = return_points(handles,1);
img2_mat = return_points(handles,2);
global global_img_1 global_img_2;
img1 = global_img_1;
img2 = global_img_2;
varargout{1} = img1_mat;
varargout{2} = img2_mat;
varargout{3} = img1;
varargout{4} = img2;

% --- Click picture to chose the points.
function img_clickFcn(hObject, eventdata, handles)
    
    handles = guidata(hObject);
    currentpt = get(gca, 'CurrentPoint');
    row  = currentpt(1,2);
    col  = currentpt(1,1);
    panel = get(gca, 'Parent');
    picture_name = panel.Title;
    
    img_num = 1;
    if strcmp(picture_name,'Picture2')
        img_num = 2;
    end
    idx = 1;
    cur_point = sprintf('img%d_p%d', img_num, idx);
    colors = ['b', 'c', 'r', 'y'];
    while idx <= 4 % the index Max is 4
        if strcmp(get(handles.(cur_point),'String'),"")
            set(handles.(cur_point),'String',['Row = ', num2str(row), ', Column = ', num2str(col)]);
            hold on ; 
            plot(col,row,'o','MarkerSize',5,'MarkerFaceColor', colors(idx),'MarkerEdgeColor',colors(idx)); 
            drawnow; 
            break
        else
            idx = idx + 1;
            cur_point = sprintf('img%d_p%d', img_num, idx);
        end
    end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
[filename,pathname]=uigetfile({'*.bmp;*.jpg;*.png;*.jpeg;*.tif'},'Chose first picture','.\');
str=[pathname filename];
if isequal(filename,0)||isequal(pathname,0)
    warndlg('please select a picture first!','warning');
    return;
else
    img = imread(str);
    global global_img_1;
    global_img_1 = img;
    img1 = image(img);
    img1.ButtonDownFcn = @img_clickFcn;
end  
    
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
[filename,pathname]=uigetfile({'*.bmp;*.jpg;*.png;*.jpeg;*.tif'},'Chose second picture','.\');
str=[pathname filename];
if isequal(filename,0)||isequal(pathname,0)
    warndlg('please select a picture first!','warning');
    return;
else
    img = imread(str);
    global global_img_2;
    global_img_2 = img;
    img2 = image(img);
    img2.ButtonDownFcn = @img_clickFcn;
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles = guidata(hObject);
    x = 0;
    for num = 1:2
        for idx = 1:4
            tag = sprintf('img%d_p%d', num, idx);
            if strcmp(get(handles.(tag),'String'),"")    %if point is empty
                f = warndlg('Please choose 4 points for each image','Error');
                return
            else
                x = x + 1;
            end
        end
    end
    
    if x == 8
        uiresume(gcbf);
    end


% --- Return the selected points
function mat = return_points(handles,num)
mat = zeros(3,4);
for idx = 1:4
    cur_point = sprintf('img%d_p%d', num, idx);
    S = get(handles.(cur_point),'String');
    com = strfind(S,',');
    equ = strfind(S,'=');
    row = str2num(S(equ(1,1)+2:com-1));
    col = str2num(S(equ(1,2)+2:end));
    mat(:,idx) = [col ; row ; 1];
end
