function [K, H] = Function(G, N, D, T, n, fig)
figure(fig);

disp(['OLTF K', num2str(n), ':']);
K = tf(N, D); % find Input OLTF 

disp(['CLTF K', num2str(n), ':']);
H = feedback(G*K, 1); % find Input CLTF

subplot(4,1,1);
stepresponse = StepResponse(H, n, T); % calculate and plot step response

subplot(4,1,2);
TorqueResponse(n, stepresponse); % calculate and plot step torque response

%subplot(5,1,3);
%PoleZeroPlot(H, n); % calculate and display poles/zeros

disp(['DTF K', num2str(n), ':']);
He = feedback(G, K); % find Disturbance CLTF

subplot(4,1,3);
distresponse = DistResponse(He, n, T); % calculate and plot disturbance response

subplot(4,1,4);
TDistResponse(n, distresponse); % calculate and plot disturbance torque response
end

function [y] = StepResponse(H, n, T)
disp(['Stability = ', num2str(isstable(H))]);

t = 0:1:T; % set time range
opt = stepDataOptions('StepAmplitude',5*pi/180); % set step amplitude to 5pi/180
y = step(H, t, opt);  % perform TF response simulation
y = y*180/pi; % convert axis from radians to degrees

plot(t, y); % Plot step response
title(['Step Response of K', num2str(n)]); xlabel('Time (seconds)'); ylabel('Output (degrees)'); % label graphs
end

function [] = TorqueResponse(n, stepresponse)
torqueresponse = 400*diff(diff(stepresponse)); % calculate torque step response using 2nd derivative (T=I*alpha)

plot(torqueresponse);
title(['Step Torque Response of K', num2str(n)]); xlabel('Time '); ylabel('Torque (Nms^2)'); % label graphs
end

function [] = PoleZeroPlot(H, n)
[z,p,k] = zpkdata(H); % find poles and zeros
disp(['k = ', num2str(k)]); % 'z = ', num2str(z), ', p = ', num2str(p), 

S = stepinfo(H); % find settling time and percent overshoot
disp(['SettlingTime = ', num2str(S.SettlingTime), ', PercentOvershoot = ', num2str(S.Overshoot), ' %, Peak Value = ', num2str(S.Peak)]);

pzplot(H); % plot pole/zero plot
title(['Pole/Zero plot of K', num2str(n)]); xlabel('Real'); ylabel('Imaginary'); %axis([-2 0 -1 1]); axis normal;
end

function [x] = DistResponse(H, n, T)
t = 0:1:T; % set time range
u = 0.0001*cos(0.0000728*t); % generate disturbance sine signal
x = lsim(H, u, t); % perform TF response simulation
x = x'*180/pi; % transpose to match 'u' for difference
diff = abs(x-u); % find difference for steady state error
sserror = max(diff); % find maximum steady state error

plot(t, x); % plot disturbance response
title(['Disturbance Response of K', num2str(n)]); xlabel('Time '); ylabel('Output (degrees)'); % label graphs
end

function [] = TDistResponse(n, distresponse)
tdistresponse = 400*diff(diff(distresponse)); % calculate torque disturbance response using 2nd derivative (T=I*alpha)

plot(tdistresponse);
title(['Disturbance Torque Response of K', num2str(n)]); xlabel('Time '); ylabel('Torque (Nms^2)'); % label graphs
end