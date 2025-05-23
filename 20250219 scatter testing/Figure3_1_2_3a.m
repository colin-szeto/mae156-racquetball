close all; clear; clc;

% File names and labels
%filename_array = {'trajectory_points_original.csv','20250408_3_barrel.csv','20250408_straight.csv','20250430.csv','short w mag.csv','long barrel.csv','short w_o mag.csv'};
%legend_labels = {'original','3 barrel', 'Straight Barrel', 'April 30', 'Short w/ Mag', 'Long Barrel', 'Short w/o Mag'};
filename_array = {'short w mag.csv','long barrel.csv','short w_o mag.csv'};
legend_labels = {'Short w/ Mag', 'Long Barrel', 'Short w/o Mag'};

% Define colors
colors = [
    %0.0, 1.0, 0.0;    
    %0.0, 0.0, 1.0;    
    %1.0, 0.75, 0.0;   
    %1.0, 0.0, 1.0;    
    0.0, 1.0, 1.0;    
    1.0, 0.0, 0.0;    
    0.5, 0.0, 1.0;    
];

figure(1); clf;
ax1 = axes; hold(ax1, 'on');
scatter_handles = gobjects(length(filename_array), 1);  % For legend

for file_n = 1:length(filename_array)
    % Read and preprocess data
    filename = filename_array{file_n};
    M = csvread(filename, 1, 0) * 0.0254; % Convert to meters
    M(1,:) = []; 
    M(end,:) = [];

    % Extract horizontal (x) and vertical (y) spread
    x = M(:,1);
    y = M(:,2);

    % Compute mean for normalization
    x0 = mean(x);
    y0 = mean(y);

    % Normalize data (center at origin)
    x_norm = x - x0;
    y_norm = y - y0;

    % Scatter plot with 'x' markers and stroke thickness 2
    scatter_handles(file_n) = plot(ax1, x_norm, y_norm, 'o', ...
        'Color', colors(file_n,:), 'LineWidth', 2, 'DisplayName', legend_labels{file_n});

    % 1-sigma ellipse (std dev) — hidden from legend
    a = std(x);
    b = std(y);
    theta = linspace(0, 2*pi, 100);
    ellipse_x = a * cos(theta);
    ellipse_y = b * sin(theta);
    plot(ax1, ellipse_x, ellipse_y, '--', 'Color', colors(file_n,:), 'LineWidth', 1.5, 'HandleVisibility', 'off');

    % Annotation
    str = sprintf('%s 1 sigma \n x ± %.3f m \n y ± %.3f m', legend_labels{file_n}, a, b);
    text(ax1, 0.2, +.15- 0.15*file_n, str, 'Color', 'k', 'FontSize', 10);
end

% Axis formatting
xlabel(ax1, 'Normalized Horizontal Spread [m]');
ylabel(ax1, 'Normalized Vertical Spread [m]');
title(ax1, '2D Normalized Scatter of Impact Points');
legend(ax1, scatter_handles, 'Location', 'best');
axis(ax1, 'equal'); grid(ax1, 'on');