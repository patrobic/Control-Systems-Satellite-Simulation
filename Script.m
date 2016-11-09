clear;
clc;
close all;

% Parametric variables
A = 36000; %% km
I = 400; %% Nms^2
T = 1000; %% sec (86400)
W = 0.0000728; %% rad/s
G = tf(1, [I 0 0]);

Figures = [figure('name', 'Controller K1') figure('name', 'Controller K2') figure('name', 'Controller K3')];
t = table([0.1 0.01; 1 0], [12 0.15; 4 1], [35 0.875; 1 2], 'VariableNames', {'K1' 'K2' 'K3'});

for i = 1:1:3 % call function for each controller
Function(G, t{1,i}, t{2,i}, T, i, Figures(i));
end