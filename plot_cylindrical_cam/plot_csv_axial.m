clear; close all; clc; 


% Load s(θ) data from CSV

T = readtable('cam_displacement_from_dxf_plot.csv');

figure(1)
plot(T.theta_deg, T.linear_travel_mm)
grid on

figure(2)
% Define angle range
n_points = 1000;
theta_deg = linspace(0, 360, n_points);
theta_rad = deg2rad(theta_deg);

% Interpolate s(θ) from CSV
s = interp1(T.theta_deg, T.linear_travel_mm, theta_deg, 'pchip');

% Derivatives wrt θ
dtheta = theta_rad(2) - theta_rad(1);
v_theta = gradient(s, dtheta);           % Velocity
a_theta = gradient(v_theta, dtheta);     % Acceleration
j_theta = gradient(a_theta, dtheta);     % Jerk

% Angular velocity from desired follower velocity
v_follower = 100;       % mm/s
epsilon = 1e-6;
omega = v_follower ./ (v_theta + epsilon);  % rad/s
time = cumtrapz(theta_rad, 1 ./ omega);     % Time

% === Plotting ===
tiledlayout(5,1, 'TileSpacing', 'compact', 'Padding', 'compact');

nexttile
plot(theta_deg, s, 'Color', [0 0.6 0], 'LineWidth', 2);
ylabel('s (mm)', 'FontWeight', 'bold'); grid on; box on;

nexttile
plot(theta_deg, time, 'm', 'LineWidth', 2);
ylabel('Time (s)', 'FontWeight', 'bold'); grid on; box on;

nexttile
plot(theta_deg, omega, 'b', 'LineWidth', 2);
ylabel('\omega (rad/s)', 'FontWeight', 'bold'); grid on; box on;

nexttile
plot(theta_deg, a_theta, 'r', 'LineWidth', 2);
ylabel('\alpha (mm/rad²)', 'FontWeight', 'bold'); grid on; box on;

nexttile
plot(theta_deg, j_theta, 'k', 'LineWidth', 2);
ylabel('Jerk'); xlabel('\theta (deg)', 'FontWeight', 'bold'); grid on; box on;

sgtitle('Cam Kinematics from DXF-derived Displacement', 'FontSize', 14, 'FontWeight', 'bold');
