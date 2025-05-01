close all; clear; clc; 

% objective: plot points from csv file of columns x and y

filename_array = {'trajectory_points_original.csv','20250408_3_barrel.csv','20250408_straight.csv','20250430.csv','short w mag.csv','long barrel.csv','short w_o mag.csv'}; %,'20250408_3_barrel.csv'
% z0,x0,y0 (meters)
offset_launch = {[0, 7.21*0.0254,0.19],[0, 7.21*0.0254,0.19],[0, 7.21*0.0254,0.19], [0,5.12*0.0254,0.19], [0 0 0.19], [0 0 0.19], [0 0 0.19]} %, [0 0 0]
%offset_launch = {[10, -7.21*0.0254,0], [0.02,-5.12*0.0254,0]}

legend_labels = {'original','3 barrel', 'Straight Barrel', 'April 30', 'Short w/ Mag', 'Long Barrel', 'Short w/o Mag'};
plot_handles = gobjects(length(filename_array), 1); % Preallocate for plot handles


colors = [
    0.0, 1.0, 0.0;    % Green
    0.0, 0.0, 1.0;    % Blue
    1.0, 0.75, 0.0;   % Amber
    1.0, 0.0, 1.0;    % Magenta
    0.0, 1.0, 1.0;    % Cyan
    1.0, 0.0, 0.0;    % Red
    0.5, 0.0, 1.0;    % Purple
    0.5, 0.5, 0.0;    % Olive
    0.25, 0.75, 0.5;  % Teal green
    0.85, 0.33, 0.1;  % Orange-brown
    0.6, 0.6, 0.6;    % Gray
];



figure(1)
hold on
for file_n =1:length(filename_array)
    % Assuming offset_launch{file_n} = [z_o, x_o, y_o]
    temp_offset = offset_launch{file_n};
    z_o = temp_offset(1);
    x_o = temp_offset(2);
    y_o = temp_offset(3);
    %load(filename)

    filename  = filename_array{file_n};
    M = csvread(filename,1,0)*0.0254; % skipping the labels reading one row from the top

    %M(:,1) = M(:,1) - 7.2098;
    M(1,:) = []; % remove first and second row
    M(end,:) = [];

    x = M(:,1);
    y = M(:,2);
    z = M(:,3);
    
    % plotting points of impact
    scatter3(z,x,y, 'MarkerFaceColor', colors(file_n,:)); hold on;
    grid on 
    %axis equal
    % plotting center point
    x0 = mean(M(:,1));
    y0 = mean(M(:,2));
    z0 = mean(M(:,3));
    
    scatter3(z0,x0,y0,MarkerFaceColor='red')

    % Plot the standard deviationellipse

    a = std(M(:,1));
    b = std(M(:,2));
    theta = linspace(0, 2*pi, 100); 
    xc = x0 + a * cos(theta);
    yc = y0 + b * sin(theta);

    plot3(z0*ones(length(yc)),xc, yc,'black--', 'LineWidth',2);  

    str1 = sprintf('x spread: %0.3g \x00B1 %0.3g\ny spread: %0.3g \x00B1 %0.3g\nz: %0.3g',x0,a,y0,b,z0)
    text(z0,x0-3*0.0254,y0,str1)

    %computeInitialVelocity3DPlot(z0,x0,y0)
    % Store handle to trajectory for legend
    plot_handles(file_n) = computeInitialVelocity3DPlot_w_offset(z0, x0, y0, z_o,x_o,y_o,colors(file_n,:));
end
hold off;

% === Axis Limits Based on Offset ===
offset = 0.05;  % change this value as needed

% Collect all x, y, z values from all files
all_x = []; all_y = []; all_z = [];

for file_n = 1:length(filename_array)
    filename = filename_array{file_n};
    M = csvread(filename,1,0)*0.0254; 
    M(1,:) = []; 
    M(end,:) = [];

    all_z = [all_x; M(:,1)];
    all_x = [all_y; M(:,2)];
    all_y = [all_z; M(:,3)];
end

xlim([min(all_x)-offset, max(all_x)+offset])
ylim([min(all_y)-offset, max(all_y)+offset])
zlim([min(all_z)-offset, max(all_z)+offset])

%title('Straight Barrel')
xlabel('depth [m] z')
ylabel('horizontal spread [m] x')
zlabel('vertical spread [m] y')
legend(plot_handles, legend_labels, 'Location', 'best');



%
%
%{
%hold off

% 3 barrel
filename = '20250408_3_barrel.csv';
%load(filename)
M = csvread(filename,1,0); % skipping the labels reading one row from the top
M(:,1) = M(:,1) -5.1245;
%M(:,2) = M(:,2) +0.787402; % moving the 0,0 point up to barrel

M(1,:) = []; % remove first and second row
M(end,:) = [];


%figure(2)
scatter3(M(:,1), M(:,2),M(:,3),MarkerFaceColor='blue')
grid on 
axis equal
title('3 barrel')
%hold on

x0 = mean(M(:,1));
y0 = mean(M(:,2));
z0 = mean(M(:,3));

scatter3(x0,y0,z0,MarkerFaceColor='red')


a = std(M(:,1));
b = std(M(:,2));

sprintf('%0.5g + %0.3g',x0,a)
sprintf('%0.5g + %0.3g',y0,b)

theta = linspace(0, 2*pi, 100); 

xc = x0 + a * cos(theta);
yc = y0 + b * sin(theta);

% Plot the ellipse

plot3(xc, yc,z0*ones(length(yc)), 'black--', 'LineWidth',2); 

xlabel('horizontal spread [in]')
ylabel('vertical spread [in]')
zlabel('depth/range [in]')

str1 = sprintf('x spread: %0.3g \x00B1 %0.3g\ny spread: %0.3g \x00B1 %0.3g',0,a,y0,b)
legend({'points impact straight' '' '' 'points impact 3 barrel' 'mean' '1 std'})

%sprintf('%0.5g + %0.3g',y0,b)

%text(-1.25,6.8,str1)
text(x0-3,y0,z0,str1)

hold off

%}