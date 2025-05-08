close all; clear; clc;

% Objective: plot 3D scatter and trajectories from CSV, with offsets
filename_array = {'20250408_3_barrel.csv','20250430.csv'};
legend_labels = {'3 barrel', '3 barrel reclaimed'};

offset_launch = {
    [0, 7.21*0.0254, 0.19],
    [0, 7.21*0.0254, 0.19]
};

plot_handles = gobjects(length(filename_array), 1);  % Preallocate for legend

% Define plot colors
colors = [
    0.0, 0.0, 1.0;    % Blue
    1.0, 0.0, 1.0;    % Magenta
];

figure(1); clf;
hold on; grid on;

% Preallocate for global axis range
all_x = []; all_y = []; all_z = [];

for file_n = 1:length(filename_array)
    % Load offset for this dataset
    temp_offset = offset_launch{file_n};
    z_o = temp_offset(1); x_o = temp_offset(2); y_o = temp_offset(3);

    % Read and preprocess data
    filename  = filename_array{file_n};
    M = csvread(filename, 1, 0) * 0.0254;  % Convert inches to meters
    M(1,:) = []; M(end,:) = [];

    x = M(:,1);
    y = M(:,2);
    z = M(:,3);

    % Track for axis limits
    all_x = [all_x; x];
    all_y = [all_y; y];
    all_z = [all_z; z];

    % Mean point
    x0 = mean(x);
    y0 = mean(y);
    z0 = mean(z);

    % Scatter plot of impact points
    scatter3(z, x, y, 'x', ...
        'MarkerEdgeColor', colors(file_n,:), ...
        'LineWidth', 2); 

    % Highlight center point
    scatter3(z0, x0, y0, 50, 'red', 'filled');

    % Standard deviation ellipse in X-Y at fixed Z
    a = std(x);
    b = std(y);
    theta = linspace(0, 2*pi, 100);
    xc = x0 + a * cos(theta);
    yc = y0 + b * sin(theta);
    plot3(z0 * ones(size(xc)), xc, yc, 'k--', 'LineWidth', 2, 'HandleVisibility','off');

    % Annotate spread
    %str1 = sprintf('x spread: %.3g ± %.3g\n y spread: %.3g ± %.3g\n z: %.3g', x0, a, y0, b, z0);
    %text(z0, x0 - 3*0.0254, y0, str1, 'FontSize', 8);

    % Plot trajectory line (external function)
    plot_handles(file_n) = computeInitialVelocity3DPlot_w_offset(z0, x0, y0, z_o, x_o, y_o, colors(file_n,:));
end

% === Set 3D axis limits with margin ===
offset = 0.05;  % meters
xlim([min(all_x)-offset, max(all_x)+offset]);
ylim([min(all_y)-offset, max(all_y)+offset]);
zlim([min(all_z)-offset, max(all_z)+offset]);

% Axis and plot labels
xlabel('Depth [m] (Z)');
ylabel('Horizontal Spread [m] (X)');
zlabel('Vertical Spread [m] (Y)');
title('3D Impact Points and Trajectories');

legend(plot_handles, legend_labels, 'Location', 'best');

% Ensure good view and scaling
axis equal
axis tight;
axis vis3d;
view(3);
