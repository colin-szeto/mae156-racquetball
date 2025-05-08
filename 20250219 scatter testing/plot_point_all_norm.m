close all; clear; clc;

% File names and labels
filename_array = {'trajectory_points_original.csv','20250408_3_barrel.csv','20250408_straight.csv','20250430.csv','short w mag.csv','long barrel.csv','short w_o mag.csv'};
legend_labels = {'original','3 barrel', 'Straight Barrel', 'April 30', 'Short w/ Mag', 'Long Barrel', 'Short w/o Mag'};

% Define colors
colors = [
    0.0, 1.0, 0.0;    
    0.0, 0.0, 1.0;    
    1.0, 0.75, 0.0;   
    1.0, 0.0, 1.0;    
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
    %str = sprintf('%s\nx ± %.3f m\ny ± %.3f m', legend_labels{file_n}, a, b);
    %text(ax1, 0, -0.05 - 0.06*file_n, str, 'Color', colors(file_n,:), 'FontSize', 8);
end

% Axis formatting
xlabel(ax1, 'Normalized Horizontal Spread [m]');
ylabel(ax1, 'Normalized Vertical Spread [m]');
title(ax1, '2D Normalized Scatter of Impact Points');
legend(ax1, scatter_handles, 'Location', 'best');
axis(ax1, 'equal'); grid(ax1, 'on');

%% Add secondary x and y axes for inches
%ax2 = axes('Position', ax1.Position, ...
%           'XAxisLocation','top', ...
%           'YAxisLocation','right', ...
%           'Color','none', ...
%           'XColor','k','YColor','k');
%
%% Match limits and convert ticks to inches
%ax2.XLim = ax1.XLim * 39.3701;
%ax2.YLim = ax1.YLim * 39.3701;
%
%% Set tick marks to match ax1
%ax2.XTick = ax1.XTick * 39.3701;
%ax2.YTick = ax1.YTick * 39.3701;
%
%xlabel(ax2, 'Horizontal Spread [in]');
%ylabel(ax2, 'Vertical Spread [in]');
