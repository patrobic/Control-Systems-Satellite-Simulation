function [K, H] = Function(G, N, D, T, n, figure)
global Rs PZs Rd;

% find Input OLTF 
disp(['OLTF K', num2str(n), ':']);
K = tf(N, D); % display

% find Input CLTF
disp(['CLTF K', num2str(n), ':']);
H = feedback(G*K, 1); % display
StepResponse(H, n, T, Rs, PZs);

% find Disturbance CLTF
He = feedback(G, K)
DisturbanceResponse(He, n, T, Rd);
end

function [] = StepResponse(H, n, T, response, polezero)
disp(['Stability = ', num2str(isstable(H))]);
figure(response);
subplot(3,1,n);

% Plot step response
t = 0:1:T; % set time range
opt = stepDataOptions('StepAmplitude',5*pi/180); % set step amplitude to 5pi/180
y = step(H, t, opt);  % perform TF response simulation
y = y*180/pi; % convert axis from radians to degrees
plot(t, y); % plot resulting graphs
title(['Step Response of K', num2str(n)]); xlabel('Time (seconds)'); ylabel('Output (degrees)'); % label graphs

% find poles and zeros
[z,p,k] = zpkdata(H);
disp(['k = ', num2str(k)]); % 'z = ', num2str(z), ', p = ', num2str(p), 
celldisp(z);
celldisp(p);

% plot pole/zero plot
figure(polezero);
subplot(3,1,n);
pzplot(H);
title(['Pole/Zero plot of K', num2str(n)]); xlabel('Real'); ylabel('Imaginary'); %axis([-2 0 -1 1]); axis normal;

% find settling time and percent overshoot
S = stepinfo(H);
disp(['SettlingTime = ', num2str(S.SettlingTime), ', PercentOvershoot = ', num2str(S.Overshoot), ' %, Peak Value = ', num2str(S.Peak)]);
end

function [] = DisturbanceResponse(H, n, T, response)
disp(['Stability = ', num2str(isstable(H))]);
figure(response);
subplot(3,1,n);

% Plot disturbance response
t = 0:1:T; % set time range
u = 0.0001*cos(0.0000728*t); % generate disturbance sine signal
x = lsim(H, u, t); % perform TF response simulation
x = x'*180/pi; % transpose to match 'u' for difference
diff = abs(x-u); % find difference for steady state error
max(diff) % find maximum steady state error
plot(t, x); % plot resulting graphs
title(['Disturbance Response of K', num2str(n)]); xlabel('Time '); ylabel('Output \theta(t)'); % label graphs
end