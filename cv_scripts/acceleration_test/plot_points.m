clear all;
close all;
clc;

% Load CSV data
data = readtable('sharpie_rotation_data_og.csv');

upper_bound = 1000
% Extract and smooth
t = data.time(1:1:upper_bound);
x = movmean(data.centroid_x(1:1:upper_bound), 20);
y = movmean(data.centroid_y(1:1:upper_bound), 20);

% Estimate rough frequency using FFT
N = length(t);
dt = mean(diff(t));
Fs = 1 / dt;
X_fft = fft(x - mean(x));
frequencies = (0:N-1)*(Fs/N);
[~, idx] = max(abs(X_fft(2:floor(N/2))));
omega_guess = 2 * pi * frequencies(idx + 1);

% Spiral model: returns Nx2 matrix
spiral_model = @(p, t_vals) [ ...
    p(1) * cos(p(2)*t_vals + p(3)) + p(4), ...
    p(1) * sin(p(2)*t_vals + p(3)) + p(5)];

% Error function (use temp variable to avoid indexing issue)
error_fn = @(p) ...
    sum(sum((spiral_model(p, t) - [x y]).^2));

% Initial guess: [Amplitude, omega, phase, x0, y0]
p0 = [range(x)/2, omega_guess, 0, mean(x), mean(y)];

% Optimization
opts = optimset('Display','iter','MaxFunEvals',10000);
p_fit = fminsearch(error_fn, p0, opts);

% Generate fitted spiral
t_fit = linspace(min(t), max(t), 500);
x_fit = p_fit(1) * cos(p_fit(2)*t_fit + p_fit(3)) + p_fit(4);
y_fit = p_fit(1) * sin(p_fit(2)*t_fit + p_fit(3)) + p_fit(5);
z_fit = t_fit;

% Plot
figure;
plot3(x, y, t, 'b.', 'DisplayName', 'Filtered Data'); hold on;
plot3(x_fit, y_fit, z_fit, 'r-', 'LineWidth', 2, 'DisplayName', 'Fitted Spiral');
xlabel('Centroid X');
ylabel('Centroid Y');
zlabel('Time');
grid on;
axis equal;
title('Spiral Fit to Sharpie Rotation');
legend;
