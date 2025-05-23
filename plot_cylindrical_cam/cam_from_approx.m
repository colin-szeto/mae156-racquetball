clear; clc; close all;

% Add getYFromDegree as a local function at the end

% Parameters
n_points = 1000;
theta_deg = linspace(0, 360, n_points);
theta_rad = deg2rad(theta_deg);
s = zeros(size(theta_deg));
segments = strings(size(theta_deg));

% Get s(θ) from your piecewise function
for i = 1:length(theta_deg)
    [s(i), segments(i)] = getYFromDegree(theta_deg(i));
end

% Derivatives wrt theta
dtheta = deg2rad(theta_deg(2) - theta_deg(1));
v_theta = gradient(s, dtheta);            % ds/dθ
a_theta = gradient(v_theta, dtheta);      % d²s/dθ²
j_theta = gradient(a_theta, dtheta);      % d³s/dθ³

% Angular velocity omega based on desired linear follower velocity
v_follower = 100;       % mm/s
epsilon = 1e-6;
omega = v_follower ./ (v_theta + epsilon);     % rad/s
time = cumtrapz(theta_rad, 1 ./ omega);        % s

% Plot results
tiledlayout(5,1, 'TileSpacing', 'compact', 'Padding', 'compact');

nexttile
plot(theta_deg, s, 'Color', [0 0.6 0], 'LineWidth', 2);
ylabel('s (mm)', 'FontWeight', 'bold');
grid on; box on;

nexttile
plot(theta_deg, time, 'm', 'LineWidth', 2);
ylabel('Time (s)', 'FontWeight', 'bold');
grid on; box on;

nexttile
plot(theta_deg, omega, 'b', 'LineWidth', 2);
ylabel('\omega (rad/s)', 'FontWeight', 'bold');
grid on; box on;

nexttile
plot(theta_deg, a_theta, 'r', 'LineWidth', 2);
ylabel('\alpha (mm/rad²)', 'FontWeight', 'bold');
grid on; box on;

nexttile
plot(theta_deg, j_theta, 'k', 'LineWidth', 2);
ylabel('Jerk'); xlabel('\theta (deg)', 'FontWeight', 'bold');
grid on; box on;

sgtitle('Cam Kinematics from getYFromDegree() Profile', 'FontSize', 14, 'FontWeight', 'bold');

% Sampling parameters
n_points = 1000;
theta_deg = linspace(0, 360, n_points);
s = zeros(size(theta_deg));
segments = strings(size(theta_deg));

% Compute displacement for each degree using your function
for i = 1:length(theta_deg)
    [s(i), segments(i)] = getYFromDegree(theta_deg(i));
end

% Plot movement
figure;
hold on;

% Plot red and green segments separately for clarity
is_red = segments == "red";
is_green = segments == "green";

plot(theta_deg(is_red), s(is_red), '-', 'Color', [0.85 0.33 0.1], 'LineWidth', 2);   % red
plot(theta_deg(is_green), s(is_green), '-', 'Color', [0.13 0.55 0.13], 'LineWidth', 2); % green

xlabel('\theta (degrees)', 'FontWeight', 'bold');
ylabel('Linear travel (mm)', 'FontWeight', 'bold');
title('Follower Displacement from getYFromDegree()', 'FontSize', 14, 'FontWeight', 'bold');
grid on;
box on;
xlim([0 360]);

legend({'Red Segment', 'Green Segment'}, 'Location', 'northwest');


% === Local Function ===
function [y, segment] = getYFromDegree(degree)
    % Normalize degree to [0, 120)
    local_deg = mod(degree, 120);

    % Parameters
    y_start = 0;
    y_end = 37.5;
    green_start = 10;
    green_end = 110;

    if local_deg < green_start
        t = local_deg / green_start;
        y = y_start + (y_end / 3) * (t^2);
        segment = "red";
    elseif local_deg <= green_end
        slope = (y_end - y_start) / (green_end - green_start);
        y = y_start + slope * (local_deg - green_start);
        segment = "green";
    else
        t = (local_deg - green_end) / (120 - green_end);
        y = y_end - (y_end / 3) * (t^2);
        segment = "red";
    end
end
