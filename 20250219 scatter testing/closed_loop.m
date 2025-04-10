clear; close all; clc;

figure(10)

hold on
x5 =   [-87.487765 , 55.848824 ,  3.650459 , -2.612386 ,-23.804988 , 13.811880 ,-23.804988 , 38.713187 , 51.428748 ,134.079893 ,225.183248 ,308.969701 ,-39.840940 ];
y5 =   -1*[-1081.066797,-1166.053978,-1669.302146,-1630.000332,-1587.085314,-1555.826227,-1513.441024,-1605.099025,-1520.328619,-1520.328619,-1403.621532,-1562.997936,-1351.781708];
plot(x5./72,y5./72 ,'o',MarkerFaceColor="Black") % as    sume 72 ppi

plot(mean(x5./72),mean(y5./72  ),'o',MarkerFaceColor="Magenta",Markersize=10)

disp('closed loop')

mean(x5./72)
mean(y5./72)
std(x5./72)
std(y5./72)


% Define ellipse parameters

a = std(x5./72);  % Semi-major axis
b = std(y5./72 );  % Semi-minor axis

x0 = mean(x5./72); % Center x-coordinate
y0 = mean(y5./72 ); % Center y-coordinate



% Generate points on the ellipse

theta = linspace(0, 2*pi, 100); 

xc = x0 + a * cos(theta);
yc = y0 + b * sin(theta);

grid on


str1 = sprintf('x spread: %0.5g \x00B1 %0.5g\ny spread: %0.5g \x00B1 %0.5g',x0,a,y0,b);
%sprintf('%0.5g + %0.5g',y0,b)

text(2,17,str1)

% Plot the ellipse

plot(xc, yc, 'blue--', 'LineWidth',2);  % 'r' for red color

legend({'points impact' 'mean' '1 std'})
xlabel('horizontal spread [in]')
ylabel('vertical spread [in]')
title('Closed Loop Gravity Fed')