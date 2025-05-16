clear; clc; close all;

% Parameters
S = 38.10;                     % Total rise [mm]
theta_seg = 120;            % Segment duration [deg]
n_points = 1000;
omega_const = 2 * pi;       % Constant cam angular speed [rad/s] (1 rev/sec)

% Angle vector in degrees and radians
theta_deg = linspace(0, theta_seg, n_points);
theta_rad = deg2rad(theta_deg);

% Define follower displacement s(θ): Cycloidal motion
s = S * (theta_rad/theta_rad(end) - (1/(2*pi))*sin(2*pi*theta_rad/theta_rad(end)));

% Compute derivatives wrt θ
dtheta = theta_rad(2) - theta_rad(1);
v = gradient(s, dtheta);           % Velocity: ds/dθ
a = gradient(v, dtheta);           % Acceleration: d²s/dθ²
j = gradient(a, dtheta);           % Jerk: d³s/dθ³

% Invert s(θ) to get θ(s)
[s_unique, idx_unique] = unique(s, 'stable');
theta_s = interp1(s_unique, theta_rad(idx_unique), s_unique, 'pchip');
omega_s = interp1(s_unique, v(idx_unique), s_unique, 'pchip');
alpha_s = interp1(s_unique, a(idx_unique), s_unique, 'pchip');
jerk_s = interp1(s_unique, j(idx_unique), s_unique, 'pchip');
time_s = theta_s / omega_const;

% Convert to degrees for plotting
theta_s_deg = rad2deg(theta_s);

% === Plot ===
figure;

subplot(5,1,1)
plot(s_unique, time_s, 'm','LineWidth',2); ylabel('Time (s)'); grid on;

subplot(5,1,2)
plot(s_unique, theta_s_deg, 'b','LineWidth',2); ylabel('\theta (deg)'); grid on;

subplot(5,1,3)
plot(s_unique, omega_s, 'g','LineWidth',2); ylabel('\omega (mm/rad)'); grid on;

subplot(5,1,4)
plot(s_unique, alpha_s, 'r','LineWidth',2); ylabel('\alpha (mm/rad^2)'); grid on;

subplot(5,1,5)
plot(s_unique, jerk_s, 'k','LineWidth',2); ylabel('Jerk'); xlabel('Follower travel s (mm)'); grid on;

sgtitle('Cylindrical Cam Kinematics for 120° Rise Segment');
