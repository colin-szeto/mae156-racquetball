clear; close all; clc; 
x = [3,0,0.25,151.230228,31.227994,163.351666,456.690461,318.50607,409.416854,470.243465,205.205281,328.507275,590.523298,358.447302,-34.792581,332.66108,396.052208,362.745005,454.865525,319.380211];
y = [-3,-5,1122.519685,833.925825,607.254938,656.952833,673.922846,550.284181,534.526312,525.765953,437.90484,414.848369,261.476639,-31.841634,-60.851134,-241.354686,-220.940594,-333.755315,-652.102931,-751.566356];

%length(x)
%length(y)
plot(x./72,y./72,'o',MarkerFaceColor="Blue") % assume 72 ppi
axis equal
xlabel("x spread [inches]")
ylabel("y spread [inches]")

x2 =   [3.000000,   0.000000,  34.594955, 220.345655, 496.355498, 682.106198, 383.858595, 228.194276,-102.414060,  59.993924,  28.490034, 188.725335, 237.610681, 128.433408, 646.779499, 147.324647, 426.984605, 598.102758, 431.565976, 431.565976, 420.964165];
y2 =     [-3.000000,   -5.000000, 1047.977500,  961.398609, 1095.859400,  954.321617,  781.284477,  725.197147,  548.416040,  475.962068,  422.206487,  390.506568,  238.310929,  254.737865,  377.171230,  -11.915590,  -57.789944, -245.326138, -502.314146, -549.153594, -603.936862];

hold on

plot(x2./72,y2./72,'o',MarkerFaceColor="Red") % assume 72 ppi

 x3 =  [3.000000,  0.000000, 12.767888, 88.868438,810.391102,491.100187,534.876668,491.100187,132.026269,547.335713,564.841904,547.335713,552.539685,632.415149,795.291638,364.768979,520.475522,523.140426,392.560122,523.140426,557.022779,603.235913];
 y3 =  [-3.000000,   -5.000000,  752.513365,  662.894954,  860.447995,  188.243281,  117.239964,   77.200499,  -72.386941, -131.426811, -171.731761, -361.597072, -399.103811, -493.565230, -493.565230, -549.320920, -584.726076, -614.420722, -694.748548, -713.783577, -713.783577, -858.049468];


hold on

plot(x3./72,y3./72,'o',MarkerFaceColor="Green") % assume 72 ppi

 x4 = [3.000000,  0.000000,  3.546831,509.220074,734.868273, 85.154952, 70.006145,303.435494,429.446028,539.619172,450.792074,434.266103,368.850799,355.767738,297.926837,227.002876,532.650721,505.447509];
 y4 = [-3.000000,  -5.000000,1000.180767, 995.379475, 954.568578, 534.596238, 439.571902, 417.537273, 340.416072, 306.675547, 275.000768, 247.457482, 205.453970, 109.052469, 134.530009, 115.938291,  35.622069,-536.176825];



hold on

plot(x4./72,y4./72,'o',MarkerFaceColor="Yellow") % assume 72 ppi
grid on

y_all = [y y2 y3 y4];
x_all = [x x2 x3 x4];


mean(x_all./72)
mean(y_all./72)

plot(mean(x_all./72),mean(y_all./72),'o',MarkerFaceColor="Magenta",Markersize=10)

std(x_all./72)
std(y_all./72)


% Define ellipse parameters

a = std(x_all./72);  % Semi-major axis
b = std(y_all./72);  % Semi-minor axis

x0 = mean(x_all./72); % Center x-coordinate
y0 = mean(y_all./72); % Center y-coordinate



% Generate points on the ellipse

theta = linspace(0, 2*pi, 100); 

xc = x0 + a * cos(theta);
yc = y0 + b * sin(theta);



% Plot the ellipse

plot(xc, yc, 'black--', 'LineWidth',2);  % 'r' for red color

axis equal;  % Set equal aspect ratio for proper ellipse shape

grid on;
title("Rev1 Racquet Ball Tests")
legend({'test 1' 'test 2' 'test 3' 'test 4' 'mean position' '1 stardard deviation'})



