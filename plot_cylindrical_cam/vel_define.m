clear; clc; close all;

% === Parameters ===
S = 38.10;                    % Total rise [mm]
theta_seg = 120;             % Segment duration [deg]
n_points = 1000;
v_follower = 183.2412455;            % Desired constant follower velocity [mm/s]
r_cyl = 31.75;                  % Radius of cylindrical cam [mm]
epsilon = 1e-6;              % Small value to avoid division by zero

% === Angle vector ===
theta_deg = linspace(0, theta_seg, n_points);
theta_rad = deg2rad(theta_deg);

% === Follower displacement: Cycloidal motion ===
s = S * (theta_rad/theta_rad(end) - (1/(2*pi)) * sin(2*pi*theta_rad/theta_rad(end)));

% === Derivatives wrt theta ===
dtheta = theta_rad(2) - theta_rad(1);
v = gradient(s, dtheta);           % ds/dθ
a = gradient(v, dtheta);           % d²s/dθ²
j = gradient(a, dtheta);           % d³s/dθ³

% === Angular velocity ω(θ) based on desired follower speed ===
omega = v_follower ./ (v + epsilon);  % rad/s

% === Time from angular velocity ===
time_theta = cumtrapz(theta_rad, 1 ./ omega);  % integrate dθ / ω(θ)

% === Interpolation wrt displacement ===
[s_unique, idx_unique] = unique(s, 'stable');
theta_s = interp1(s, theta_rad, s_unique, 'pchip');
omega_s = interp1(s, omega, s_unique, 'pchip');
alpha_s = gradient(omega_s, s_unique);       % α = dω/ds
jerk_s = gradient(alpha_s, s_unique);        % jerk = dα/ds
time_s = interp1(theta_rad, time_theta, theta_s, 'pchip');

% === Convert for plotting ===
theta_s_deg = rad2deg(theta_s);

% === Plot kinematics ===
figure;

subplot(5,1,1)
plot(s_unique, time_s, 'm','LineWidth',2); ylabel('Time (s)'); grid on;

subplot(5,1,2)
plot(s_unique, theta_s_deg, 'b','LineWidth',2); ylabel('\theta (deg)'); grid on;

subplot(5,1,3)
plot(s_unique, omega_s, 'g','LineWidth',2); ylabel('\omega (rad/s)'); grid on;

subplot(5,1,4)
plot(s_unique, alpha_s, 'r','LineWidth',2); ylabel('\alpha (rad/s/mm)'); grid on;

subplot(5,1,5)
plot(s_unique, jerk_s, 'k','LineWidth',2); ylabel('Jerk'); xlabel('Follower travel s (mm)'); grid on;

sgtitle('Cylindrical Cam Kinematics with Velocity-Based Omega');

% === Pressure angle ===
phi = atan(v ./ r_cyl);         % Pressure angle in radians
phi_deg = rad2deg(phi);         % Convert to degrees

figure;
plot(theta_deg, phi_deg, 'LineWidth', 2);
xlabel('\theta [°]');
ylabel('Pressure Angle [°]');
title('Pressure Angle for Cylindrical Cam');
grid on; box on;
