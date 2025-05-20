% lecture 9 inverting the matrix problem

%inv([0 0 0 1; 1 1 1 1; 0 0 1 0; 3 2 1 0])

clear
close all
clc
format longg
format compact

name = 'Colin Szeto';
id = 'A16933158';
hw_num = 2;
if false
    
    y = @(x) x.^2;
    x = -2:0.01:2;
    
    c = [x; y(x)];
    
    coeff = @(x,d) d./sqrt(1+4.*x.^2);
    
    figure(1); hold on;
    plot(x,y(x))
    axis equal
    off = [.25 .5 .75 1];
    for n = 1:4
        offset = c + coeff(x,off(n)).*[-2.*x; ones(1,length(x))];
        plot(offset(1,:),offset(2,:))
    end
    title('Offset Curves of a Parabola')
    xlabel('x')
    ylabel('y')
    lg = legend({'original curve' 'offset: .25' 'offset: .5' 'offset: .75' 'offset: 1'});
    lg.Location = 'best';
    p1a = 'See figure 1'
    
    syms x
    k = @(x) (2.*ones(1,length(x)))./abs(1 + (2*x).^2).^(3/2);
    
    x = -2:0.01:2;
    
    figure(2); hold on
    subplot(2,1,1) % radius curvature R
    plot(x,ones(1,length(x))./k(x))
    xlabel('Input x')
    ylabel('Radius of Curvature R')
    title('Radius of Curvature of Parabolic Curve')
    legend('Radius of Curvature Curve')
    subplot(2,1,2) % curvature K 
    plot(x,k(x))
    xlabel('Input x')
    ylabel('Curvature K')
    legend('Curvature Curve')
    title('Curvature of Parabolic Curve')
    
    p1b = 'See figure 2'
    p1c = 'when the offset distance D exceed the radius of curvature undercutting occurs'
end
%% problem 2

if false
    points1 = [-1 0   10; % data for curve 1
               0  1 -10];
    
    points2 = [0 1 -10; % data for curve 2
               1 0 -10];
    
    points3 = [1 0 5; % data for curve 2
               -1 0 -5];
    
    n1 = @(t) 2.*t.^3 - 3.*t.^2 + ones(1,length(t));
    n2 = @(t) -2.*t.^3 + 3.*t.^2;
    n3 = @(t) t.^3 - 2.*t.^2 + t;
    n4 = @(t) t.^3 - t.^2;
    
    x_spline = @(t,x1,x2) (x2-x1).*t + x1.*ones(1,length(t));
    y_spline = @(t,x1,x2,y1,y2,dydx1,dydx2) y1.*n1(t) + y2.*n2(t) + (dydx1*(x2-x1)).*n3(t) + (dydx2*(x2-x1)).*n4(t);
    
    t = -10:0.001:10;
    
    % collecting data 
    x_val = x_spline(t,points1(1,1),points1(2,1));
    y_val = y_spline(t,points1(1,1),points1(2,1),points1(1,2),points1(2,2),points1(1,3),points1(2,3));
    
    x_val2 = x_spline(t,points2(1,1),points2(2,1));
    y_val2 = y_spline(t,points2(1,1),points2(2,1),points2(1,2),points2(2,2),points2(1,3),points2(2,3));
    
    x_val3 = x_spline(t,points3(1,1),points3(2,1));
    y_val3 = y_spline(t,points3(1,1),points3(2,1),points3(1,2),points3(2,2),points3(1,3),points3(2,3));
    
    % applying the inequality -1 < x < 0
    index_to_plot = x_val <= 0;
    index_to_plot2 = x_val >= -1;
    index_to_plot_f = find(index_to_plot == index_to_plot2);
    
    figure(3); hold on
    plot(x_val(index_to_plot_f),y_val(index_to_plot_f))
    
    % applying the inequality 0 < x < 1
    index_to_plot = x_val2 >= 0;
    index_to_plot2 = x_val2 <= 1;
    index_to_plot_f = find(index_to_plot == index_to_plot2);
    
    plot(x_val2(index_to_plot_f),y_val2(index_to_plot_f))
    
    % applying the inequality from -1 < x < 1
    index_to_plot = x_val3 >= -1;
    index_to_plot2 = x_val3 <= 1;
    index_to_plot_f = find(index_to_plot == index_to_plot2);
    
    plot(x_val3(index_to_plot_f),y_val3(index_to_plot_f)); hold off
    
    legend({'curve 1' 'curve 2' 'curve 3'})
    xlabel('x')
    ylabel('y')
    title('Plotting with Hermite Spline Meathod')
    p2 = 'See figure 3'
end
%% p3 

% Simulation parameters:
export_cam_contour = false;
cam_contour_filename = 'cam1_profile.txt';
export_animation = false;
animation_filename = 'cam1_animation.gif';

% Cam parameters
r_follower = 0.006;    % [m] follower radius
r_prime = 0.02;       % [m] radius of prime circle
omega = 1000*2*pi/60; % 	[rad/sec] convert CAM rotational speed from RPM to rad/sec
r_base =r_prime-r_follower;
dt  = deg2rad(2);      % radial resolution [rad];


%Define various displacement profiles using symbolic math cam simulator.m x 
syms theta beta L
dwell = 0;
polynomial = L*(10/beta^3*theta^3 - 15/beta^4*theta^4+ 6/beta^5*theta^5);
cycloidal = L*(theta/beta - 1/(2*pi)*sin(2*pi*theta/beta));
harmonic  = L/2 * (1 - cospi(theta ./beta));

% Note:
% v = dy/dt = dy/dtheta
% a = d2y/dt2 = d2y/dtheta2 * omega^2
% j = d3y/dt3= d2y/dtheta3 omega^3
% Updated Cam Design

% Constants
r_follower = 0.006;  % [m]
r_prime = 0.02;      % [m] base reference
omega = 1000*2*pi/60;
dt = deg2rad(2);     % resolution

% Symbolic expressions
syms theta beta L
dwell = 0;
poly = L*(10/beta^3*theta^3 - 15/beta^4*theta^4 + 6/beta^5*theta^5);

% Convert mm to meters
r1 = 10.358 / 1000;
r2 = 13.857 / 1000;
r3 = 13.249 / 1000;

% Section 1: Dwell 0–35.1°
beta1 = deg2rad(35.1);
t1 = 0:dt:beta1-dt;
y1 = r1 * ones(size(t1));
v1 = zeros(size(t1));
a1 = zeros(size(t1));
j1 = zeros(size(t1));

% Section 2: Polynomial rise 35.1–124.5°
beta2 = deg2rad(124.5);
delta_rise = r2 - r1;
t2 = beta1:dt:beta2-dt;
y2 = r1 + subs(poly, {theta, beta, L}, {t2 - t2(1), beta2 - beta1, delta_rise});
v2 = subs(diff(poly, theta)*omega, {theta, beta, L}, {t2 - t2(1), beta2 - beta1, delta_rise});
a2 = subs(diff(poly, theta, 2)*omega^2, {theta, beta, L}, {t2 - t2(1), beta2 - beta1, delta_rise});
j2 = subs(diff(poly, theta, 3)*omega^3, {theta, beta, L}, {t2 - t2(1), beta2 - beta1, delta_rise});

% Section 3: Dwell 124.5–151.2° (with discontinuity)
beta3 = deg2rad(151.2);
t3 = beta2:dt:beta3-dt;
y3 = r3 * ones(size(t3));
v3 = zeros(size(t3));
a3 = zeros(size(t3));
j3 = zeros(size(t3));

% Combine all
t = [t1, t2, t3];
dis = eval([y1, y2, y3]);
vel = eval([v1, v2, v3]);
acc = eval([a1, a2, a3]);
jerk = eval([j1, j2, j3]);



% Combine all sections 
%t = [t1, t2, t3];%,t4,t5,t6];
%dis = eval( [y1, y2, y3]);%, y4, y5, y6]);  % eval: convert symbolic type to double precision
%vel = eval( [v1, v2, v3]);%, v4, v5, v6]); 
%acc = eval( [a1, a2, a3]);%, a4, a5, a6]); 
%jerk = eval([j1, j2, j3]);%, j4, j5, j6]);

% Contruct can geometry
% Obtain pressure angle
e = 0;
phi = atan ((vel/omega-e)./(sqrt(r_prime^2-e^2)+dis));

% Pitch curve
x_pitch = (r_prime + dis).*sin(t);
y_pitch = (r_prime + dis).*cos(t);

% Cam contour
x_cam = x_pitch - r_follower*sin(t - phi); 
y_cam = y_pitch - r_follower*cos(t - phi);

% Base circle
x_base = r_base*sin(t); 
y_base = r_base*cos(t);

% Prime circle
x_prime = r_prime*sin(t);
y_prime = r_prime*cos(t);
 
 
% Plot motion profiles and animate cam motion
base_in(1,:) = x_base;
base_in(2,:) = y_base;
prime_in(1,:) = x_prime;
prime_in(2,:) = y_prime;
cam_in(1,:) = x_cam;
cam_in(2,:) = y_cam;
pitch_in(1,:) = x_pitch;
pitch_in (2,:) = y_pitch;
cam_in(:, end) = cam_in(:,1);
pitch_in(:, end) = pitch_in(:,1);
prime_in(:,end) = prime_in(:,1);
base_in(:,end) = base_in(:,1);

theta_val = rad2deg(t); % degrees to plot
index_to_plot_1 = theta_val<110;

index_to_plot = theta_val >= 110;
index_to_plot2 = theta_val <= 120;
index_to_plot_2 = find(index_to_plot == index_to_plot2);

index_to_plot = theta_val >= 120;
index_to_plot2 = theta_val <= 200;
index_to_plot_3 = find(index_to_plot == index_to_plot2);

index_to_plot = theta_val >= 200;
index_to_plot2 = theta_val <= 220;
index_to_plot_4 = find(index_to_plot == index_to_plot2);

index_to_plot = theta_val >= 220;
index_to_plot2 = theta_val <= 340;
index_to_plot_5 = find(index_to_plot == index_to_plot2);


index_to_plot = theta_val >= 340;
index_to_plot2 = theta_val <= 360;
index_to_plot_6 = find(index_to_plot == index_to_plot2);

figure('Units','inches','Position',[1 1 15 10]);
%for nt = 1:1:length(t)

sp(1) = subplot (4,1,1);
plot(theta_val(index_to_plot_1), dis(index_to_plot_1)*1000, 'b','LineWidth',2); hold on; %displacement
plot(theta_val(index_to_plot_2), dis(index_to_plot_2)*1000, 'r','LineWidth',2);
plot(theta_val(index_to_plot_3), dis(index_to_plot_3)*1000, 'color', '#fcba03','LineWidth',2);
plot(theta_val(index_to_plot_4), dis(index_to_plot_4)*1000, 'magenta','LineWidth',2);
plot(theta_val(index_to_plot_5), dis(index_to_plot_5)*1000, 'g','LineWidth',2);
plot(theta_val(index_to_plot_6), dis(index_to_plot_6)*1000, 'c','LineWidth',2);
ylabel('displacement [mm]');
xlabel('theta [degree]');
box on; grid on; axis tight;
title('Cam Displacement at Rotation Angle')
set(gca, 'XTick', 0:30:360, 'XTickLabel', {0:30:360}); hold off;

legend({'Polynomical Rise' 'Dwell' 'Cycloidial Rise' 'Dwell' 'Harmonic fall' 'Dwell'})

sp(2) = subplot(4,1,2);
plot(theta_val(index_to_plot_1), vel(index_to_plot_1)*1000, 'b','LineWidth',2); hold on; %velocity
plot(theta_val(index_to_plot_2), vel(index_to_plot_2)*1000, 'r','LineWidth',2);
plot(theta_val(index_to_plot_3), vel(index_to_plot_3)*1000, 'color', '#fcba03','LineWidth',2);
plot(theta_val(index_to_plot_4), vel(index_to_plot_4)*1000, 'magenta','LineWidth',2);
plot(theta_val(index_to_plot_5), vel(index_to_plot_5)*1000, 'g','LineWidth',2);
plot(theta_val(index_to_plot_6), vel(index_to_plot_6)*1000, 'c','LineWidth',2);
ylabel('velocity [mm/s]'); axis tight;
xlabel('theta [degree]');
box on; grid on;
title('Cam Velocity at Rotation Angle')
set(gca, 'XTick', 0:30:360, 'XTickLabel', {0:30:360}); hold off;

sp(3) = subplot(4,1,3); 
%plot(rad2deg(t), acc*1000, 'k'); hold on; % acceleration
%plot(rad2deg(t(nt)), acc(nt)*1000, 'ko', 'MarkerFaceColor','k'); 
plot(theta_val(index_to_plot_1), acc(index_to_plot_1)*1000, 'b','LineWidth',2); hold on; %acceleration
plot(theta_val(index_to_plot_2), acc(index_to_plot_2)*1000, 'r','LineWidth',2);
plot(theta_val(index_to_plot_3), acc(index_to_plot_3)*1000, 'color', '#fcba03','LineWidth',2);
plot(theta_val(index_to_plot_4), acc(index_to_plot_4)*1000, 'magenta','LineWidth',2);
plot(theta_val(index_to_plot_5), acc(index_to_plot_5)*1000, 'g','LineWidth',2);
plot(theta_val(index_to_plot_6), acc(index_to_plot_6)*1000, 'c','LineWidth',2);
ylabel('acceleration [mm/s^2]');
xlabel('theta [degree]');
box on; grid on; axis tight;
title('Cam Acceleration at Rotation Angle')
set(gca, 'XTick', 0:30:360, 'XTickLabel', {0:30:360}); hold off;

sp(4) = subplot(4,1,4); % jerk
%plot(rad2deg(t), jerk*1000, 'k'); hold on;
%plot(rad2deg(t(nt)), jerk(nt)*1000, 'ko', 'MarkerFaceColor', 'k'); 
plot(theta_val(index_to_plot_1), jerk(index_to_plot_1)*1000, 'b','LineWidth',2); hold on; %jerk
plot(theta_val(index_to_plot_2), jerk(index_to_plot_2)*1000, 'r','LineWidth',2);
plot(theta_val(index_to_plot_3), jerk(index_to_plot_3)*1000, 'color', '#fcba03','LineWidth',2);
plot(theta_val(index_to_plot_4), jerk(index_to_plot_4)*1000, 'magenta','LineWidth',2);
plot(theta_val(index_to_plot_5), jerk(index_to_plot_5)*1000, 'g','LineWidth',2);
plot(theta_val(index_to_plot_6), jerk(index_to_plot_6)*1000, 'c','LineWidth',2);
ylabel('jerk [mm/s^3]');
xlabel('theta [degree]');
axis tight; box on; grid on;
set(gca, 'XTick', 0:30:360, 'XTickLabel', {0:30:360}); hold off;
title('Cam Jerk at Rotation Angle')

%end
%%
if false
    
    % animating cam
    figure(5)
    
    %end
    plot(pitch_in(1, :)*1000, pitch_in(2, :)*1000, '--k'); hold on
    plot(cam_in(1, :)*1000, cam_in(2, :)*1000, 'r'); 
    plot(prime_in(1, :)*1000, prime_in(2, :)*1000, 'g'); 
    plot(base_in(1, :)*1000, base_in(2, :)*1000, 'b');
    
    
    tt =deg2rad(0:360);
    %x_follower=r_follower*cos(tt);
    %y_follower =r_follower*sin(tt) + dis (nt) + r_prime; % translate follower motion patch(x_follower*1000, y_follower 1000, 'k', 'FaceAlpha', 0.5);
    axis equal; box on; grid on; xlabel('x [mm]');
    ylabel('y [mm]');
    legend({'pitch curve' 'cam contour' 'prime circle' 'base circle'})
    title('Cam Curves');
    
    tmp = max(sqrt(x_pitch.^2 + y_pitch.^2)) + 2*r_follower; 
    axis([-1 1 -1 1]*tmp*1000);
    %end
    
    
    figure(6)
    plot(rad2deg(t), rad2deg(phi), 'k'); % pressure angle
    hold on;
    %plot(rad2deg(t(nt)), rad2deg(phi(nt)), 'ko', 'MarkerFaceColor', 'k');
    ylabel('pressure angle [degree]');
    xlabel('theta [degree]');
    axis tight; box on; grid on;
    set (gca, 'XTick', 0:30:360, 'XTickLabel', {0:30:360}); hold off;
    title('Pressure Angle over theta')
    
    p3a = 'See figure 4'
    p3b = 'See figure 5'
    p3c = 'See figure 6'
    p3d = 'This is a bad CAM design although the pressure angle does not exceed 30 degrees there are jump discontinuities at theta 110 and 200 degrees in jerk, this can be solved by replacing the cycloidal and polynomial rise with a harmonic rise'
end

%% Hw 4 
if false
    solid_out = zeros(3,length(cam_in));
    solid_out(1:2,:) = cam_in*1000;
    
    writematrix(solid_out','cam profile.txt')


end







