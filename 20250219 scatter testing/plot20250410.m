close all; clear; clc; 

% objective: plot points from csv file of columns x and y

filename_array = {'short w mag.csv','long barrel.csv','short w_o mag.csv'};




legend_struct = {};
figure(1)
hold on
str = plot_me(filename_array{1},1)
str1 = plot_me(filename_array{2},2)
str2 = plot_me(filename_array{3},3)

hold off;

title('Comparing Barrel Spread (normalized)')
xlabel('depth spread [in]')
ylabel('horizontal spread [in]')
zlabel('vertical spread [in]')

legend({filename_array{1} '' str filename_array{2} '' str1 filename_array{3} '' str2})
%legend({filename_array{2} '' str1 filename_array{3} '' str2})


function str1= plot_me(filename,file_n,x_off,y_off)
    colors = [
        0.0, 1.0, 1.0;    % Cyan
        1.0, 0.0, 0.0;    % Red
        0.5, 0.0, 1.0;    % Purple
        %0.0, 1.0, 0.0;  % Green
        %0.0, 0.0, 1.0;  % Blue
        %1.0, 1.0, 0.0;  % Yellow
        %1.0, 0.0, 1.0;  % Magenta
    ];

    height_off = [1 2 3 4 5];

    %filename  = filename_array{file_n};
    M = csvread(filename,1,0); % skipping the labels reading one row from the top

    %M(:,1) = M(:,1) - 7.2098;
    M(1,:) = []; % remove first and second row
    M(end,:) = [];

    x = M(:,1);
    y = M(:,2);
    %z = M(:,3);
    

    axis equal
    % plotting center point
    x0 = mean(M(:,1));
    y0 = mean(M(:,2));
    %z0 = mean(M(:,3));

    % plotting points of impact
    %scatter(x-x0,y-y0,'x', 'MarkerFaceColor', colors(file_n,:),'LineWidth', 2); hold on;

    plot(x-x0,y-y0, 'o', 'MarkerFaceColor', colors(file_n,:), 'LineWidth', 1);
    grid on 
    
    % plotting the midpoint (should be 0,0)
    scatter(x0-x0,y0-y0,MarkerFaceColor='red')

    % Plot the standard deviationellipse

    a = std(M(:,1));
    b = std(M(:,2));
    theta = linspace(0, 2*pi, 100); 
    xc = x0 + a * cos(theta);
    yc = y0 + b * sin(theta);

    plot(xc-x0, yc-y0,'--', 'Color',colors(file_n,:),'LineWidth',2);  

    %str1 = sprintf('x spread: %0.5g \x00B1 %0.5g\ny spread: %0.5g \x00B1 %0.5g',0,a,0,b);
    str1 = sprintf('x std: \x00B1 %0.5g\ny std:\x00B1 %0.5g',a,b);
    %legend_struct{file_n} = str1
    %text(-4,height_off(file_n),str1)
end

function plot_me_working(filename,file_n,x_off,y_off)
    colors = [
       % 1.0, 0.0, 0.0;  % Red
        0.0, 1.0, 0.0;  % Green
        0.0, 0.0, 1.0;  % Blue
        1.0, 1.0, 0.0;  % Yellow
        1.0, 0.0, 1.0;  % Magenta
        0.0, 1.0, 1.0   % Cyan
    ];

    %filename  = filename_array{file_n};
    M = csvread(filename,1,0); % skipping the labels reading one row from the top

    %M(:,1) = M(:,1) - 7.2098;
    M(1,:) = []; % remove first and second row
    M(end,:) = [];

    x = M(:,1);
    y = M(:,2);
    z = M(:,3);
    
    % plotting points of impact
    scatter(x,y, 'MarkerFaceColor', colors(file_n,:)); hold on;
    grid on 
    %axis equal
    % plotting center point
    x0 = mean(M(:,1));
    y0 = mean(M(:,2));
    z0 = mean(M(:,3));
    
    scatter(x0,y0,MarkerFaceColor='red')

    % Plot the standard deviationellipse

    a = std(M(:,1));
    b = std(M(:,2));
    theta = linspace(0, 2*pi, 100); 
    xc = x0 + a * cos(theta);
    yc = y0 + b * sin(theta);

    plot(xc, yc,'black--', 'LineWidth',2);  

    str1 = sprintf('x spread: %0.5g \x00B1 %0.5g\ny spread: %0.5g \x00B1 %0.5g',x0,a,y0,b);
    text(x0-8,y0,str1)
end


function plot_me_3(filename,file_n)
    colors = [
       % 1.0, 0.0, 0.0;  % Red
        0.0, 1.0, 0.0;  % Green
        0.0, 0.0, 1.0;  % Blue
        1.0, 1.0, 0.0;  % Yellow
        1.0, 0.0, 1.0;  % Magenta
        0.0, 1.0, 1.0   % Cyan
    ];

    %filename  = filename_array{file_n};
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