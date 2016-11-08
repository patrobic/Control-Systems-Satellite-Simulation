clear;
clc;
close all;

% Parametric variables
A = 36000; %% km
I = 400; %% Nms^2
T = 1000; %% sec (86400)
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

% call function for each controller
Function(G, N1, D1, T, 1)
Function(G, N2, D2, T, 2)
Function(G, N3, D3, T, 3)