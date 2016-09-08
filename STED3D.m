function varargout = STED3D(varargin)
% STED3D MATLAB code for STED3D.fig
%      STED3D, by itself, creates a new STED3D or raises the existing
%      singleton*.
%
%      H = STED3D returns the handle to a new STED3D or the handle to
%      the existing singleton*.
%
%      STED3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STED3D.M with the given input arguments.
%
%      STED3D('Property','Value',...) creates a new STED3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before STED3D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to STED3D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help STED3D

% Last Modified by GUIDE v2.5 22-Aug-2012 16:51:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @STED3D_OpeningFcn, ...
                   'gui_OutputFcn',  @STED3D_OutputFcn, ...
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


% --- Executes just before STED3D is made visible.
function STED3D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to STED3D (see VARARGIN)

% Choose default command line output for STED3D
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes STED3D wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clear
clear all glbal
global NA n f r0 z0 rsteps zsteps lambda1 lambda2 Ie0 Id0 betae0 betad0 Ids saturationformula phip0 zp0 polarizatione polarizationd IIe1 IIe2 IIe3 IId1 IId2 IId3 IId4 IId5 Eefield Eefield2 Edfield Edfield2 residue
global Sexcitation Sdepletion Sdrawexcitationimage Sdrawdepletionimage Ssaturation Srandommask Smeasure Sexcitationintegrationcalculated Sdepletionintegrationcalculated Sresiduefieldcalculated Sexcitationfieldcalculated Sdepletionfieldcalculated Sresiduefieldcalculated

%%%%%%%%%%%%变量输入%%%%%%%%%%%
%%%%系统参数%%%
%数值孔径
NA=1.4;
%折射率
n=1.5;
f=1;
%探测区间的范围，单位为波长
r0=1;
z0=1;
%探测区间的分辨率，单位为步/波长
rsteps=20;
zsteps=10;

%%%%激光参数%%%%%%%

%excitation和sted的波长，单位为纳米
lambda1=635;
lambda2=760;
%激发和退激发的光强|E|^2
Ie0=1;
Id0=10;
%y方向相对x方向的偏振幅度大小tan(beta)=ey/ex0,beta在0到90°之间，45°表示等幅，0度偏振仅沿x方向
betae0=45;
betad0=45;
%y和x方向的偏振相位差，90为左旋，0为线偏振，-90右旋
polarizatione=90; 
polarizationd=90;

%饱和光强
Ids=1;
%选择激发方式，1为连续，2 为脉冲，3为自定义
saturationformula=1;


%%%%%%输出参数%%%%%%%%
%xz观察平面旋转角
phip0=0;
zp0=0;
Sexcitation=1;
Sdepletion=1;

Sdrawexcitationimage=1;
Sdrawdepletionimage=1;
Ssaturation=1;

Smeasure=1;

Srandommask=0;
Sexcitationintegrationcalculated=0;
Sdepletionintegrationcalculated=0;
Sexcitationfieldcalculated=0;
Sdepletionfieldcalculated=0;
Sresiduefieldcalculated=0;






% --- Outputs from this function are returned to the command line.
function varargout = STED3D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
global Srandommask
Srandommask=get(handles.listbox1,'value')-1;
if Srandommask==1
    open 'maskfunction.m'
    msgbox('Input your mask function in maskfunction.m.Then save and close it to continue.','modal')    
end;

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculatebutton.
function calculatebutton_Callback(hObject, eventdata, handles)
% hObject    handle to calculatebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in resetbutton.
function resetbutton_Callback(hObject, eventdata, handles)
% hObject    handle to resetbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Confocalswich.
function Confocalswich_Callback(hObject, eventdata, handles)
% hObject    handle to Confocalswich (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Confocalswich
global Sexcitation Sdrawexcitationimage
Sexcitation=get(handles.Confocalswich,'value');
Sdrawexcitationimage=get(handles.Confocalswich,'value');
if Sdrawexcitationimage==0
    figure(1); figure(2);close fugure 1;close figure 2;
else updateimage();
end;

    


% --- Executes on button press in SSTED.
function SSTED_Callback(hObject, eventdata, handles)
% hObject    handle to SSTED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SSTED
global Sdepletion Sdrawdepletionimage
Sdepletion=get(handles.SSTED,'value');
Sdrawdepletionimage=get(handles.SSTED,'value');
if Sdrawdepletionimage==0
    figure(3); figure(4);close fugure 3;close figure 4;
else updateimage();
end;

function NAinput_Callback(hObject, eventdata, handles)
% hObject    handle to NAinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NAinput as text
%        str2double(get(hObject,'String')) returns contents of NAinput as a double
global NA
NA=str2num(get(handles.NAinput,'string'));

% --- Executes during object creation, after setting all properties.
function NAinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NAinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ninput_Callback(hObject, eventdata, handles)
% hObject    handle to ninput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ninput as text
%        str2double(get(hObject,'String')) returns contents of ninput as a double
global n
n=str2num(get(handles.ninput,'string'));

% --- Executes during object creation, after setting all properties.
function ninput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ninput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function finput_Callback(hObject, eventdata, handles)
% hObject    handle to finput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of finput as text
%        str2double(get(hObject,'String')) returns contents of finput as a double
global f
f=str2num(get(handles.finput,'string'));

% --- Executes during object creation, after setting all properties.
function finput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to finput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function r0input_Callback(hObject, eventdata, handles)
% hObject    handle to r0input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r0input as text
%        str2double(get(hObject,'String')) returns contents of r0input as a double
global r0
r0=str2num(get(handles.r0input,'string'));

% --- Executes during object creation, after setting all properties.
function r0input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r0input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z0input_Callback(hObject, eventdata, handles)
% hObject    handle to z0input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z0input as text
%        str2double(get(hObject,'String')) returns contents of z0input as a double
global zp0 z0
z0=str2num(get(handles.z0input,'string'));
zp0=str2num(get(handles.zpinput,'string'));
if zp0<-z0 zp0=-z0;set(handles.zpinput,'string',-z0);
else if zp0>z0 zp0=z0;set(handles.zpinput,'string',z0);
    end;
end;
set(handles.zslider,'max',z0+eps);
set(handles.zslider,'min',-z0-eps);
set(handles.zslider,'value',zp0);
% --- Executes during object creation, after setting all properties.
function z0input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z0input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rstepsinput_Callback(hObject, eventdata, handles)
% hObject    handle to rstepsinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rstepsinput as text
%        str2double(get(hObject,'String')) returns contents of rstepsinput as a double
global rsteps
rsteps=str2num(get(handles.rstepsinput,'string'));

% --- Executes during object creation, after setting all properties.
function rstepsinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rstepsinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zstepsinput_Callback(hObject, eventdata, handles)
% hObject    handle to zstepsinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zstepsinput as text
%        str2double(get(hObject,'String')) returns contents of zstepsinput as a double
global zsteps
zsteps=str2num(get(handles.zstepsinput,'string'));

% --- Executes during object creation, after setting all properties.
function zstepsinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zstepsinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lambdaeinput_Callback(hObject, eventdata, handles)
% hObject    handle to lambdaeinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambdaeinput as text
%        str2double(get(hObject,'String')) returns contents of lambdaeinput as a double
global lambda1
lambda1=str2num(get(handles.lambdaeinput,'string'));

% --- Executes during object creation, after setting all properties.
function lambdaeinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambdaeinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lambdadinput_Callback(hObject, eventdata, handles)
% hObject    handle to lambdadinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambdadinput as text
%        str2double(get(hObject,'String')) returns contents of lambdadinput as a double
global lambda2
lambda2=str2num(get(handles.lambdadinput,'string'));

% --- Executes during object creation, after setting all properties.
function lambdadinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambdadinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ie0input_Callback(hObject, eventdata, handles)
% hObject    handle to Ie0input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ie0input as text
%        str2double(get(hObject,'String')) returns contents of Ie0input as a double
global Ie0
Ie0=str2num(get(handles.Ie0input,'string'));

% --- Executes during object creation, after setting all properties.
function Ie0input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ie0input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Id0input_Callback(hObject, eventdata, handles)
% hObject    handle to Id0input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Id0input as text
%        str2double(get(hObject,'String')) returns contents of Id0input as a double
global Id0
Id0=str2num(get(handles.Id0input,'string'));

% --- Executes during object creation, after setting all properties.
function Id0input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Id0input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function betad0input_Callback(hObject, eventdata, handles)
% hObject    handle to betad0input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of betad0input as text
%        str2double(get(hObject,'String')) returns contents of betad0input as a double
global betad0
betad0=str2num(get(handles.betad0input,'string'));

% --- Executes during object creation, after setting all properties.
function betad0input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betad0input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function polarizationeinput_Callback(hObject, eventdata, handles)
% hObject    handle to polarizationeinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of polarizationeinput as text
%        str2double(get(hObject,'String')) returns contents of polarizationeinput as a double
global polarizatione
polarizatione=str2num(get(handles.polarizationeinput,'string'));

% --- Executes during object creation, after setting all properties.
function polarizationeinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polarizationeinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function polarizationdinput_Callback(hObject, eventdata, handles)
% hObject    handle to polarizationdinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of polarizationdinput as text
%        str2double(get(hObject,'String')) returns contents of polarizationdinput as a double
global polarizationd
polarizationd=str2num(get(handles.polarizationdinput,'string'));

% --- Executes during object creation, after setting all properties.
function polarizationdinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polarizationdinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function phipinput_Callback(hObject, eventdata, handles)
% hObject    handle to phipinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phipinput as text
%        str2double(get(hObject,'String')) returns contents of phipinput as a double
global phip0 Sdepletionfieldcalculated
phip0=str2num(get(handles.phipinput,'string'));
set(handles.phislider,'value',str2num(get(hObject,'string')));
if Sdepletionfieldcalculated==1
updateimage();
end;

% --- Executes during object creation, after setting all properties.
function phipinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phipinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zpinput_Callback(hObject, eventdata, handles)
% hObject    handle to zpinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zpinput as text
%        str2double(get(hObject,'String')) returns contents of zpinput as a double
global zp0 z0 Sdepletionfieldcalculated
zp0=str2num(get(handles.zpinput,'string'));
if zp0<-z0 zp0=-z0;set(handles.zpinput,'string',-z0);
else if zp0>z0 zp0=z0;set(handles.zpinput,'string',z0);
    end;
end;
set(handles.zslider,'max',z0+eps);
set(handles.zslider,'min',-z0-eps);
set(handles.zslider,'value',zp0);
if Sdepletionfieldcalculated==1
    updateimage();
end;


% --- Executes during object creation, after setting all properties.
function zpinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zpinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in drawbutton.
function drawbutton_Callback(hObject, eventdata, handles)
% hObject    handle to drawbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NA n f r0 z0 rsteps zsteps lambda1 lambda2 Ie0 Id0 betae0 betad0 Ids saturationformula phip0 zp0 polarizatione polarizationd IIe1 IIe2 IIe3 IId1 IId2 IId3 IId4 IId5 Eefield Eefield2 Edfield Edfield2 residue
global Sexcitation Sdepletion Sdrawexcitationimage Sdrawdepletionimage Ssaturation Srandommask Smeasure Sexcitationintegrationcalculated Sdepletionintegrationcalculated Sresiduefieldcalculated Sexcitationfieldcalculated Sdepletionfieldcalculated Sresiduefieldcalculated



draw();













% --- Executes on button press in Clearbutton.
function Clearbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Clearbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(1); figure(2);figure(3); figure(4);figure(5); figure(7);figure(8); 
close fugure 1;close figure 2;close fugure 3;close figure 4;close fugure 5;close figure 7;close fugure 8;

% --- Executes on slider movement.
function phislider_Callback(hObject, eventdata, handles)
% hObject    handle to phislider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global Sdepletionfieldcalculated;
set(handles.phipinput,'string',num2str(get(hObject,'value')));
if Sdepletionfieldcalculated==1 updateimage();end;
% --- Executes during object creation, after setting all properties.
function phislider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phislider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function zslider_Callback(hObject, eventdata, handles)
% hObject    handle to zslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global z0 zp0 Sdepletionfieldcalculated;
zp0=get(handles.zslider,'value');
set(handles.zslider,'max',z0+eps);
set(handles.zslider,'min',-z0-eps);
set(handles.zpinput,'string',num2str(get(hObject,'value')));
if Sdepletionfieldcalculated==1
updateimage();
end;
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function zslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in measurechoose.
function measurechoose_Callback(hObject, eventdata, handles)
% hObject    handle to measurechoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of measurechoose
global NA n f r0 z0 rsteps zsteps lambda1 lambda2 Ie0 Id0 betae0 betad0 Ids saturationformula phip0 zp0 polarizatione polarizationd IIe1 IIe2 IIe3 IId1 IId2 IId3 IId4 IId5 Eefield Eefield2 Edfield Edfield2 residue
global Sexcitation Sdepletion Sdrawexcitationimage Sdrawdepletionimage Ssaturation Srandommask Smeasure Sexcitationintegrationcalculated Sdepletionintegrationcalculated Sresiduefieldcalculated Sexcitationfieldcalculated Sdepletionfieldcalculated Sresiduefieldcalculated
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%变量初始化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%转角换成弧度单位phi=phi0/180*3.14;
alpha=asin(NA/n);             
%计算需要计算的矩形区域大小
    %沿着光轴方向
zmaxstep=floor(z0*zsteps*n);      %z方向的最大步数
ztotalsteps=zmaxstep+2; %循环从格子zmaxstep-2做到zminstep+2以防止溢出，总步数为ztotalsteps
%垂直于光轴方向
rmaxstep=floor(r0*rsteps*n);
rtotalsteps=rmaxstep+2;
rlabel1=(-rtotalsteps+1:rtotalsteps-1)/rsteps/n*lambda1;   
rlabel2=(-rtotalsteps+1:rtotalsteps-1)/rsteps/n*lambda2;   

Smeasure=get(handles.measurechoose,'value');
if Smeasure==1
     measureFWHMexcitation(rlabel1,ztotalsteps,Eefield);
    measureFWHMdepletion(rlabel2,ztotalsteps,Edfield);
   measureFWHMresidue(rlabel1,ztotalsteps,residue);
else figure(5);close figure 5;
end;

% --- Executes on button press in saturationchoose.
function saturationchoose_Callback(hObject, eventdata, handles)
% hObject    handle to saturationchoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saturationchoose
global Ssaturation 
Ssaturation=get(handles.saturationchoose,'value');
if Ssaturation==0
    figure(7); figure(8);close fugure 7;close figure 8;
else updateimage();

end;

function Isinput_Callback(hObject, eventdata, handles)
% hObject    handle to Isinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Isinput as text
%        str2double(get(hObject,'String')) returns contents of Isinput as a double
global Ids Sdepletionfieldcalculated Smeasure
Ids=str2num(get(handles.Isinput,'string'));
if Sdepletionfieldcalculated==1 
    if Smeasure==1
        figure(5);
        close figure 5;
        updateimage();
    end;
end;

% --- Executes during object creation, after setting all properties.
function Isinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Isinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
global saturationformula
saturationformula=get(handles.listbox2,'value');
if saturationformula==3
    open 'saturationfunction.m'
    msgbox('Input your mask function in saturationfunction.m.Then save and close it to continue.','modal')
end;

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function betae0input_Callback(hObject, eventdata, handles)
% hObject    handle to betae0input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of betae0input as text
%        str2double(get(hObject,'String')) returns contents of betae0input as a double
global betae0
betae0=str2num(get(handles.betae0input,'string'));

% --- Executes during object creation, after setting all properties.
function betae0input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betae0input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
