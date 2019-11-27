function varargout = proyecto(varargin)
% PROYECTO MATLAB code for proyecto.fig
%      PROYECTO, by itself, creates a new PROYECTO or raises the existing
%      singleton*.
%
%      H = PROYECTO returns the handle to a new PROYECTO or the handle to
%      the existing singleton*.
%
%      PROYECTO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROYECTO.M with the given input arguments.
%
%      PROYECTO('Property','Value',...) creates a new PROYECTO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before proyecto_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to proyecto_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help proyecto

% Last Modified by GUIDE v2.5 25-Nov-2019 04:45:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @proyecto_OpeningFcn, ...
                   'gui_OutputFcn',  @proyecto_OutputFcn, ...
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

% --- Proyecto de Teoría de Control ---
% Temperatura de procesador controlada por cooler
% Integrantes: Boglioli, Alan; Pringles, Juan Manuel.

% --- Utils ---
function checkNumberInEdit(editSrc)
str = get(editSrc, 'String');
if isempty(str2num(str))
    set(editSrc, 'String', '0');
    warndlg('Debe ingresar sólo números');
end

function checkBackground(hObject)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function num = editToDouble(editSrc)
str = get(editSrc, 'String');
num = str2double(str);

% --- End utils ---

% --- Main functions ---
function [A, B, C] = generateMatrixes(handles)
Tmin = editToDouble(handles.TminInput);
Tmax = editToDouble(handles.TmaxInput);
Vmin = editToDouble(handles.VminInput);
Vmax = editToDouble(handles.VmaxInput);
Cdt = editToDouble(handles.CdtInput);
Cdv = editToDouble(handles.CdvInput);
Fct = editToDouble(handles.FctInput);
Trango = Tmax - Tmin; % [ºC]
Vrango = Vmax - Vmin; % [RPM]
Cct = Fct*(Trango/Vrango); % [ºC/RPM]
Cvc = Vrango/Trango; % [RPM/ºC]
b1 = editToDouble(handles.b1Input);

A = [Cdt Cct; Cvc Cdv];
B = [b1; 0];
C = [1 0];

function [Gs, num, den, ceros, polos] = generateTransferFunction(A, B, C)
D = 0;
[num, den] = ss2tf(A, B, C, D);
ceros = roots(num);
polos = roots(den);
Gs = tf(num, den);

function handles = updateFromParameters(handles)
[A, B, C] = generateMatrixes(handles);
[Gs, num, den, ceros, polos] = generateTransferFunction(A, B, C);

% Update internal Data
handles.A = A;
handles.B = B;
handles.C = C;
handles.Gs = Gs;
handles.num = num;
handles.den = den;
handles.ceros = ceros;
handles.polos = polos;

% Set text in text boxes
GsStr = evalc('Gs');
set(handles.TransferFunctionText, 'String', GsStr);

set(handles.ZeroesText, 'String', num2str(ceros));
set(handles.PolesText, 'String', num2str(polos));

set(handles.MatrixA, 'Data', A);
set(handles.MatrixB, 'Data', B);
set(handles.MatrixC, 'Data', C);

% - Formas canónicas -
% Forma canónica controlable
Afcc = [0 1; -den(3) -den(2)];
Bfcc = [0; 1];
Cfcc = [num(3) num(2)];
set(handles.MatrixAfcc, 'Data', Afcc);
set(handles.MatrixBfcc, 'Data', Bfcc);
set(handles.MatrixCfcc, 'Data', Cfcc);
% Forma canónica observable
Afco = transpose(Afcc);
Bfco = transpose(Cfcc);
Cfco = transpose(Bfcc);
set(handles.MatrixAfco, 'Data', Afco);
set(handles.MatrixBfco, 'Data', Bfco);
set(handles.MatrixCfco, 'Data', Cfco);
% Forma canónica diagonal
Afcd = [polos(1) 0; 0 polos(2)];
Bfcd = [1; 1];
[r, ~, ~] = residue(num, den);
Cfcd=[r(1) r(2)];
set(handles.MatrixAfcd, 'Data', Afcd);
set(handles.MatrixBfcd, 'Data', Bfcd);
set(handles.MatrixCfcd, 'Data', Cfcd);

% - Estabilidad -
% Autovalores
syms lambda
polinomio = det(lambda*eye(2)-A);
raices = roots(sym2poly(polinomio));
if raices < 0
    set(handles.Autovalores, 'String', "Estable: todas las raíces < 0");
else
    set(handles.Autovalores, 'String', "Inestable: alguna raíz > 0");
end

% Routh-Hurwitzh
% Para 3 términos (ecuación de grado 2) el criterio es sencillo.
% para s^2 + a1*s + a2:
% | 1 a2
% | a1 0
% | r    --> r = a1*a2 / a1 = a2
% Sin cambios de signo
if den > 0
    set(handles.RouthHurwitz, 'String', sprintf("Estable: %s", mat2str(den)));
elseif den < 0
    set(handles.RouthHurwitz, 'String', sprintf("Estable: %s", mat2str(den)));
else 
    set(handles.RouthHurwitz, 'String', sprintf("Inestable: %s", mat2str(den)));
end

% - Error relativo -
% Escalón unitario
% No se puede utilizar lím s->0 1/(1+Gs), por lo que se realimenta el
% sistema y se siluma con la función step (escalón) con paso unitario.
% Luego, para calcular el error, sólo será necesario restar de la unidad el
% último valor estacionario que toma la función al aplicar esta entrada.
% GH = feedback(Gs, 1);
Amp = 1;
[y, ~] = step(Amp*Gs);
y(end)
essEscalon=abs(Amp-y(end));
set(handles.essEscalon, 'String', sprintf("ess = %f", essEscalon));

%t=0:0.1:Inf
%ramp=2*t
%lsim(model, ramp, t)
    
% - Controlabilidad y Observabilidad -
Cont = [B A*B];
if rank(Cont) == 2
    set(handles.Controlable, 'String', sprintf("Sí: rng(C)= %d", rank(Cont)));
else
    set(handles.Controlable, 'String', sprintf("No: rng(C)= %d", rank(Cont)));
end

Obs = [C; C*A];
if rank(Obs) == 2
    set(handles.Observable, 'String', sprintf("Sí: rng(O)= %d", rank(Obs)));
else
    set(handles.Observable, 'String', sprintf("No: rng(O)= %d", rank(Obs)));
end
% --- End functions ---

% --- Executes just before proyecto is made visible.
function proyecto_OpeningFcn(hObject, eventdata, handles, varargin)
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)

% Choose default command line simulationoutput for proyecto
handles.output = hObject;
% Create initial data
handles = updateFromParameters(handles);
% Default element properties
% set(handles.axes2, 'Visible', 'off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes proyecto wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = proyecto_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning simulationoutput args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line simulationoutput from handles structure
varargout{1} = handles.output;

% --- Create functions ---
function CheckBackground_CreateFcn(hObject, eventdata, handles)
checkBackground(hObject);
% --- End create functions

% -----------------
% --- Callbacks ---
% -----------------
function CheckNumberInEdit_Callback(hObject, eventdata, handles)
checkNumberInEdit(hObject);

function ApplyButton_Callback(hObject, eventdata, handles)
handles = updateFromParameters(handles);
guidata(hObject, handles);

function Simulation_InitialConditions_Callback(hObject, eventdata, handles)
initialX1 = str2double(get(handles.InitialX1, 'String'));
initialX2 = str2double(get(handles.InitialX2, 'String'));
x0 = [initialX1 initialX2];
v = get(handles.SimulationOutput, 'Value');
switch v
    case 1
        Sys = ss(handles.A, handles.B, handles.C, 0);
        initial(Sys, x0);
        title("Condiciones iniciales: initial(Sys, x0)")
        xlabel("Tiempo")
        ylabel("Temperatura del procesador [ºC]")
    case 2
        Sys = ss(handles.A, handles.B, [0 1], 0);
        initial(Sys, x0);
        title("Condiciones iniciales: initial(Sys, x0)")
        xlabel("Tiempo")
        ylabel("Velocidad del cooler [RPM]")
end

function Simulation_UnitStep_Callback(hObject, eventdata, handles)
v = get(handles.SimulationOutput, 'Value');
switch v
    case 1
        Sys = ss(handles.A, handles.B, handles.C, 0);
        step(Sys);
        title("Escalón unitario: step(Sys)")
        xlabel("Tiempo")
        ylabel("Temperatura del procesador [ºC]")
    case 2
        Sys = ss(handles.A, handles.B, [0 1], 0);
        step(Sys);
        title("Escalón unitario: step(Sys)")
        xlabel("Tiempo")
        ylabel("Velocidad del cooler [RPM]")
end

function Simulation_AmplStep_Callback(hObject, eventdata, handles)
v = get(handles.SimulationOutput, 'Value');
switch v
    case 1
        Sys = ss(handles.A, handles.B, handles.C, 0);
        step(100*Sys);
        title("Escalón unitario: step(Sys)")
        xlabel("Tiempo")
        ylabel("Temperatura del procesador [ºC]")
    case 2
        Sys = ss(handles.A, handles.B, [0 1], 0);
        step(100*Sys);
        title("Escalón unitario: step(Sys)")
        xlabel("Tiempo")
        ylabel("Velocidad del cooler [RPM]")
end

function Simulation_SystemSolution_Callback(hObject, eventdata, handles)
initialX1 = str2double(get(handles.InitialX1, 'String'));
initialX2 = str2double(get(handles.InitialX2, 'String'));
x0 = [initialX1; initialX2];
syms s t
inv_sIA = inv(s*eye(2)-handles.A);
x_s = inv_sIA*x0;
x1 = ilaplace(x_s(1));
x2 = ilaplace(x_s(2));

if limit(x1, t, Inf) == 0 && limit(x2, t, Inf) == 0
    set(handles.SolucionSistema, 'String', "Estable: t->inf => x1=x2->0");
else
    set(handles.SolucionSistema, 'String', "Inestable: t->inf => x1 o x2->inf");
end

x1_mf = matlabFunction(x1);
x2_mf = matlabFunction(x2);
t=0:0.1:100;
title("Solución del Sistema (por Laplace)")
plot(t, x1_mf(t), t, x2_mf(t));

log = sprintf("x1(t) = %s\nx2(t) = %s", char(x1), char(x2));
set(handles.Output,'String', log);

function Simulation_PhasePlane_Callback(hObject, eventdata, handles)
initialX1 = str2double(get(handles.InitialX1, 'String'));
initialX2 = str2double(get(handles.InitialX2, 'String'));
x0 = [initialX1; initialX2];
syms s t
inv_sIA = inv(s*eye(2)-handles.A);
x_s = inv_sIA*x0;
x1 = ilaplace(x_s(1));
x2 = ilaplace(x_s(2));

if limit(x1, t, Inf) == 0 && limit(x2, t, Inf) == 0
    set(handles.PlanoFase, 'String', "Estable: converge a (0, 0)");
else
    set(handles.PlanoFase, 'String', "Inestable: no converge a (0, 0)");
end

x1_mf = matlabFunction(x1);
x2_mf = matlabFunction(x2);
t=0:0.1:100;
title("Plano de Fase")
plot(x1_mf(t), x2_mf(t));

log = sprintf("x1(t) = %s\nx2(t) = %s", char(x1), char(x2));
set(handles.Output,'String', log);

function RootsDiagram_Callback(hObject, eventdata, handles)
title("Diagrama de polos y raíces")
rlocus(handles.num, handles.den);

function PolarDiagram_Callback(hObject, eventdata, handles)
w = 0:0.1:1000000;
[Re, Im, w] = nyquist(handles.num, handles.den, w);
title("Diagrama polar")
plot(Re, Im)
grid on;
grid minor;

function NyquistDiagram_Callback(hObject, eventdata, handles)
title("Diagrama de Nyquist")
nyquist(handles.Gs);    
