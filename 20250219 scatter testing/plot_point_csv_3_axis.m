close all; clear; clc; 

% objective: plot points from csv file of columns x and y

filename_array = {'20250408_straight.csv','20250408_3_barrel.csv'};

colors = [
   % 1.0, 0.0, 0.0;  % Red
    0.0, 1.0, 0.0;  % Green
    0.0, 0.0, 1.0;  % Blue
    1.0, 1.0, 0.0;  % Yellow
    1.0, 0.0, 1.0;  % Magenta
    0.0, 1.0, 1.0   % Cyan
];


figure(1)
hold on
for file_n =1:length(filename_array)
    %load(filename)

    filename  = filename_array{file_n};
    M = csvread(filename,1,0); % skipping the labels reading one row from the top

    %M(:,1) = M(:,1) - 7.2098;
    M(1,:) = []; % remove first and second row
    M(end,:) = [];

    x = M(:,1);
    y = M(:,2);
    z = M(:,3);
    
    % plotting points of impact
    scatter3(z,x,y, 'MarkerFaceColor', colors(file_n,:)); hold on;
    grid on 
    axis equal
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

    str1 = sprintf('x spread: %0.5g \x00B1 %0.5g\ny spread: %0.5g \x00B1 %0.5g',x0,a,y0,b);
    text(z0,x0-3,y0,str1)
end
hold off;

title('Straight Barrel')
xlabel('depth spread [in]')
ylabel('horizontal spread [in]')
zlabel('vertical spread [in]')


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

sprintf('%0.5g + %0.5g',x0,a)
sprintf('%0.5g + %0.5g',y0,b)

theta = linspace(0, 2*pi, 100); 

xc = x0 + a * cos(theta);
yc = y0 + b * sin(theta);

% Plot the ellipse

plot3(xc, yc,z0*ones(length(yc)), 'black--', 'LineWidth',2); 

xlabel('horizontal spread [in]')
ylabel('vertical spread [in]')
zlabel('depth/range [in]')

str1 = sprintf('x spread: %0.5g \x00B1 %0.5g\ny spread: %0.5g \x00B1 %0.5g',0,a,y0,b)
legend({'points impact straight' '' '' 'points impact 3 barrel' 'mean' '1 std'})

%sprintf('%0.5g + %0.5g',y0,b)

%text(-1.25,6.8,str1)
text(x0-3,y0,z0,str1)

hold off

%}