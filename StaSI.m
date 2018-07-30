function varargout = StaSI(varargin)
% STASI MATLAB code for StaSI.fig
%      STASI, by itself, creates a new STASI or raises the existing
%      singleton*.
%
%      H = STASI returns the handle to a new STASI or the handle to
%      the existing singleton*.
%
%      STASI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STASI.M with the given input arguments.
%
%      STASI('Property','Value',...) creates a new STASI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StaSI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StaSI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StaSI

% Last Modified by GUIDE v2.5 07-May-2014 16:47:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StaSI_OpeningFcn, ...
                   'gui_OutputFcn',  @StaSI_OutputFcn, ...
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


% --- Executes just before StaSI is made visible.
function StaSI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StaSI (see VARARGIN)

% Choose default command line output for StaSI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

axes(handles.logo)
load('lgo.mat'); image(lgo);
set(gca,'Visible','off','XTick',[],'YTick',[])

% UIWAIT makes StaSI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = StaSI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function range_Callback(hObject, eventdata, handles)
% hObject    handle to range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slider_plot(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Save_Analysis.
function Save_Analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile('*.mat');
raw_data = handles.eff;
all_states = handles.eff_fit;
MDL = handles.MDL;
[~, q] = min(MDL);
opt_states = all_states(q,:);
try
    save([PathName, FileName],'raw_data','all_states','MDL','opt_states');
    set(handles.status,'String','Analysis saved.')
catch ME
    set(handles.status,'String','Not saved yet, try again!')
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
numst = get(hObject,'Value');
try
    numst = min(numst, numel(handles.MDL));
    handles.current_state = numst;
    guidata(hObject, handles);
    state_plot(numst,hObject, eventdata, handles)
end


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



% --- Executes on button press in Run_StaSI.
function Run_StaSI_Callback(hObject, eventdata, handles)
% hObject    handle to Run_StaSI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%[handles.MDL, handles.eff, handles.eff_fit, handles.breaks, handles.split_tree] = Run_StaSI();
handles = Run_StaSI(hObject, handles);

try
    [~, q] = min(handles.MDL);
    handles.current_state = q;
    guidata(hObject, handles);
    state_plot(q, hObject, eventdata, handles)
    set(handles.status,'String','Done analysis.')
catch ME
    set(handles.status,'String','No data loaded.')
end



% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Save_Analysis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Save_Analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on mouse press over axes background.
function logo_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to logo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function state_plot(numst,hObject, eventdata, handles)
axes(handles.histos)
[eby, ebx] = hist(handles.eff, 50);
y1 = min(ebx)-0.01; y2 = min(1.1,max(ebx)+0.01);
barh(ebx, eby);
ylim([y1,y2]);
set(gca, 'Ytick',[],'Xtick',[]);
xlabel('Relative Population')
hold on
id = unique(handles.eff_fit(numst,:));
if numel(id)==1
    hst = numel(handles.eff);
else
    hst = hist(handles.eff_fit(numst,:), id);
end
hst = hst./round(max(hst)/max(eby));
plot([zeros(size(hst));hst],[id;id], 'r','LineWidth',5)
plot(hst, id, 'r.', 'MarkerSize', 30)
hold off

slider_plot(hObject, eventdata, handles)

axes(handles.mdl)
MDL = handles.MDL;
indx = min(max(10, numst+1),numel(handles.MDL));
plot(1:indx, handles.MDL(1:indx), 's-k','LineWidth', 3,'MarkerSize', 6)
y1 = min(MDL(1:indx)); y2 = max(MDL(1:indx));
d = y2-y1;
y1 = y1-d*0.2; y2 = y2+d*0.1;
ylim([y1,y2])
xlim([0.5, indx+0.5])
set(gca, 'XGrid','on')
ylabel('MDL value')
xlabel('# of States')
hold on
plot([1,1]*numst, [y1,y2], 'r--','LineWidth',3)
hold off


% --- Executes on slider movement.
function leftpos_Callback(hObject, eventdata, handles)
% hObject    handle to leftpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slider_plot(hObject, eventdata, handles);



% --- Executes during object creation, after setting all properties.
function leftpos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_plot(hObject, eventdata, handles)
try
    right = numel(handles.eff);
catch ME
    return
end
if right <= 100
    return
end
left = get(handles.leftpos,'Value');
left = max(1,ceil(left*(right-100)));
ratio = get(handles.range,'Value');
rg = exp((log(right-left+1)-log(100))*ratio+log(100));
rg = round(rg);
right = min(left+rg,numel(handles.eff));

axes(handles.traces)
numst = handles.current_state;
plot(left:right,handles.eff(left:right), ':','LineWidth',2)
hold on
plot(left:right,handles.eff_fit(numst,left:right), 'r','LineWidth',3)
[eby, ebx] = hist(handles.eff, 50);
y1 = min(ebx)-0.01; y2 = min(1.1,max(ebx)+0.01);
ylim([y1,y2]);
xlim([left,right]);
xlabel('Data Points')
ylabel('FRET Efficiency')
hold off
