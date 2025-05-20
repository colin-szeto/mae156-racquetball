clear; close all; clc;

% Load DXF data
load('dxf_arcs.mat')
load('dxf_lines.mat')

% Set up figure
figure; hold on; %axis equal;
title_handle = title('Axial Posititon');
xlabel_handle = xlabel('\theta (degrees)');
ylabel('Linear travel (mm)');
%grid on

% ---- Compute pattern width ----
x_min = inf; x_max = -inf;

% Lines
for i = 1:length(lines_struct)
    l = lines_struct(i);
    x_min = min([x_min, l.x1, l.x2]);
    x_max = max([x_max, l.x1, l.x2]);
end

% Arcs
for i = 1:length(arcs)
    a = arcs(i);
    theta = linspace(a.start_angle, a.end_angle, 100);
    x_arc = a.cx + a.r * cosd(theta);
    x_min = min(x_min, min(x_arc));
    x_max = max(x_max, max(x_arc));
end

pattern_width = x_max - x_min;

% === Compute global Y minimum ===
y_min = inf;

% Check lines
for i = 1:length(lines_struct)
    l = lines_struct(i);
    y_min = min([y_min, l.y1, l.y2]);
end

% Check arcs
for i = 1:length(arcs)
    a = arcs(i);
    theta = linspace(a.start_angle, a.end_angle, 100);
    y_arc = a.cy + a.r * sind(theta);
    y_min = min(y_min, min(y_arc));
end

% Store vertical shift to normalize Y to start at 0
y_offset = y_min;


% ---- Plot touching patterns ----
for i = 0:2
    offset = i * pattern_width - x_min;
    plot_dxf(offset, lines_struct, arcs);
end

% ---- Adjust title and xlabel ----
xlabel_pos = get(xlabel_handle, 'Position');
xlabel_pos(2) = xlabel_pos(2) - 0.5;
set(xlabel_handle, 'Position', xlabel_pos);

title_pos = get(title_handle, 'Position');
title_pos(2) = title_pos(2) + 1;
set(title_handle, 'Position', title_pos);

% ---- Hide bottom ticks ----
set(gca, 'XTickLabel', []);

% ---- Add secondary bottom axis with custom ticks ----
ax1 = gca;
ax1_pos = ax1.Position;

ax2 = axes('Position', ax1_pos, ...
           'XAxisLocation', 'bottom', ...
           'YAxisLocation', 'right', ...
           'Color', 'none', ...
           'XColor', 'k', ...
           'YColor', 'none');

% Set number of segments (patterns shown)
num_segments = 6;

% Get current x-limits of the axis
xlims = xlim(gca);

% Generate tick positions across the full pattern span
xtick_positions = linspace(xlims(1), xlims(2), num_segments + 1);  % 4 ticks

% Generate tick labels as degree strings
xtick_labels = arrayfun(@(x) sprintf('%d°', x), linspace(0, 360, num_segments + 1), 'UniformOutput', false);

% Apply to the current axis directly
set(gca, 'XTick', xtick_positions);
set(gca, 'XTickLabel', xtick_labels);
set(gca, 'TickLength', [0.02 0.02]);  % optional: restore visible ticks

grid off;  % force redraw
grid on;
% ---- Plot function ----
function plot_dxf(offset, lines_struct, arcs)
    y_offset = evalin('base', 'y_offset');  % fetch y_offset from base workspace

    for i = 1:length(lines_struct)
        l = lines_struct(i);
        plot([l.x1 + offset, l.x2 + offset], ...
             [l.y1 - y_offset, l.y2 - y_offset],'LineWidth',2,'Color',[0 128/255 0]);
    end

    for i = 1:length(arcs)
        a = arcs(i);
        theta = linspace(a.start_angle, a.end_angle, 100);
        x = a.cx + a.r * cosd(theta);
        y = a.cy + a.r * sind(theta);
        plot(x + offset, y - y_offset, '-','LineWidth',2,'Color',[0 128/255 0]);

        % Connector to root of next arc
        if i < length(arcs)
            end_x = a.cx + a.r * cosd(a.end_angle);
            end_y = a.cy + a.r * sind(a.end_angle);

            next = arcs(i + 1);
            next_theta = linspace(next.start_angle, next.end_angle, 100);
            next_y = next.cy + next.r * sind(next_theta);
            y_root = min(next_y);

            plot([end_x + offset, end_x + offset], ...
                 [end_y - y_offset, y_root - y_offset], '-','LineWidth',2,'Color',[232/255 173/255 35/255]);
        end
    end
end

