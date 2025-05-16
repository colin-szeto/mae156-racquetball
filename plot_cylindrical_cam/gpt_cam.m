clear; clc; close all;

% Parameters
S = 50;                  % Total stroke [mm]
theta_max = 2*pi;        % Total cam angle [rad]
n_points = 1000;         % Resolution
omega_const = 2 * pi;    % Constant angular speed [rad/s] = 1 rev/sec

% Angular position
theta = linspace(0, theta_max, n_points);

% Motion law: cycloidal (example)
s = S * (theta/theta_max - (1/(2*pi))*sin(2*pi*theta/theta_max));

% Compute derivatives wrt theta
dtheta = theta(2) - theta(1);
v = gradient(s, dtheta);           % Linear velocity ds/dθ
a = gradient(v, dtheta);           % Linear acceleration
j = gradient(a, dtheta);           % Jerk

% Invert s(θ) to θ(s)
s_unique = linspace(min(s), max(s), n_points);
theta_s = interp1(s, theta, s_unique, 'pchip');
omega_s = interp1(s, v, s_unique, 'pchip');
alpha_s = interp1(s, a, s_unique, 'pchip');
jerk_s = interp1(s, j, s_unique, 'pchip');

% Time calculation (assuming constant angular speed)
time_s = theta_s / omega_const;  % t = θ / ω

% Convert to degrees for theta
theta_s_deg = rad2deg(theta_s);

% Plot all quantities over follower position s
figure;

subplot(5,1,1)
plot(s_unique, time_s, 'm'); ylabel('Time (s)'); grid on;

subplot(5,1,2)
plot(s_unique, theta_s_deg, 'b'); ylabel('\theta (deg)'); grid on;

subplot(5,1,3)
plot(s_unique, omega_s, 'g'); ylabel('\omega (mm/rad)'); grid on;

subplot(5,1,4)
plot(s_unique, alpha_s, 'r'); ylabel('\alpha (mm/rad^2)'); grid on;

subplot(5,1,5)
plot(s_unique, jerk_s, 'k'); ylabel('jerk (mm/rad^3)'); xlabel('Follower position s (mm)'); grid on;

sgtitle('Cylindrical Cam Kinematics vs Follower Displacement');
