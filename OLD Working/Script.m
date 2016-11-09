clear;
clc;
close all;

% Parametric variables
A = 36000; %% km
I = 400; %% Nms^2
T = 86400; %% sec (86400)
W = 0.0000728; %% rad/s
G = tf(1, [I 0 0]);

% numerators and denominators of transfer functions
% controller K1
N1 = [0.1 0.01];
D1 = [1 0];

% controller K2
N2 = 3/20*[80 1];
D2 = [4 1];

% controller K3
N3 = 35/40*[40 1];
D3 = [1 2];

% create figures
global Rs PZs Rd;
Rs = figure('name', 'Step Response');
PZs = figure('name', 'TF Poles/Zeros');
Rd = figure('name', 'Disturbance Respone');

Figures = [figure('name', 'Controller K1') figure('name', 'Controller K2') figure('name', 'Controller K3')];
t = table([0.1 0.01; 1 0], [12 0.15; 4 1], [35 0.875; 1 2], 'VariableNames', {'K1' 'K2' 'K3'})

% call function for each controller
for i = 1:1:3
Function(G, t{1,i}, t{2,i}, T, i, Figures(i))
end