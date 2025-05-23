clear; close all; clc;

%% === Cam Design Parameters ===
export_cam_contour = false;
cam_contour_filename = 'cam1_profile.txt';
export_animation = false;
animation_filename = 'cam1_animation.gif';

% Constants
r_follower = 5.714/2 *.001;            % [m]
r_prime = 6.875 *.001;                % [m]
omega = 1000 * 2 * pi / 60;    % [rad/sec]
r_base = r_prime - r_follower;
dt = deg2rad(2);               % angle step in radians

% Displacement profile parameters
r_offset = 1.643*0.001 -(0.59-.106) *0.001;
r1 = 9.875 / 1000;    % initial radius
r2 = 13.857 / 1000;    % peak radius
r3 = 13.5 / 1000;    % dwell after rise (discontinuity)


r1 = r1 - r_offset-r_follower;
r2 = r2 - r_offset-r_follower;
r3 = r3 - r_offset-r_follower;

% Symbolic polynomial rise
syms theta beta L
poly = L * (10/beta^3 * theta^3 - 15/beta^4 * theta^4 + 6/beta^5 * theta^5);

%% === Base Segment Motion Profile ===

% Segment 1: Dwell 0–30°
beta1 = deg2rad(30);
t1 = 0:dt:beta1 - dt;
y1 = r1 * ones(size(t1));
v1 = zeros(size(t1));
a1 = zeros(size(t1));
j1 = zeros(size(t1));

% Segment 2: Polynomial Rise 30–120°
beta2 = deg2rad(120);
delta_rise = r2 - r1;
t2 = beta1:dt:beta2 - dt;
y2 = r1 + subs(poly, {theta, beta, L}, {t2 - t2(1), beta2 - beta1, delta_rise});
v2 = subs(diff(poly, theta) * omega, {theta, beta, L}, {t2 - t2(1), beta2 - beta1, delta_rise});
a2 = subs(diff(poly, theta, 2) * omega^2, {theta, beta, L}, {t2 - t2(1), beta2 - beta1, delta_rise});
j2 = subs(diff(poly, theta, 3) * omega^3, {theta, beta, L}, {t2 - t2(1), beta2 - beta1, delta_rise});

% Segment 3: Dwell with Discontinuity 120–146.7°
beta3 = deg2rad(146.7);
t3 = beta2:dt:beta3 - dt;
y3 = r3 * ones(size(t3));
v3 = zeros(size(t3));
a3 = zeros(size(t3));
j3 = zeros(size(t3));

% Base segment (0–146.7°)
t_seg = [t1, t2, t3];
dis_seg = eval([y1, y2, y3]);
vel_seg = eval([v1, v2, v3]);
acc_seg = eval([a1, a2, a3]);
jerk_seg = eval([j1, j2, j3]);

%% === Replicate to Create 3-Lobe Cam (0–360°) ===
t = []; dis = []; vel = []; acc = []; jerk = [];

for i = 0:2
    offset = deg2rad(120 * i);
      t = [t, t_seg + offset, NaN];
    dis = [dis, dis_seg, NaN];
    vel = [vel, vel_seg, NaN];
    acc = [acc, acc_seg, NaN];
    jerk = [jerk, jerk_seg, NaN];

end

theta_deg = rad2deg(t);

%% === Cam Geometry ===
e = 0; % offset
phi = atan((vel / omega - e) ./ (sqrt(r_prime^2 - e^2) + dis));

x_pitch = (r_prime + dis) .* sin(t);
y_pitch = (r_prime + dis) .* cos(t);

x_cam = x_pitch - r_follower * sin(t - phi);
y_cam = y_pitch - r_follower * cos(t - phi);

x_base = r_base * sin(t);
y_base = r_base * cos(t);

x_prime = r_prime * sin(t);
y_prime = r_prime * cos(t);

% Store profiles (with curve closure)
pitch_in = [x_pitch; y_pitch];
cam_in   = [x_cam; y_cam];
base_in  = [x_base; y_base];
prime_in = [x_prime; y_prime];

pitch_in(:, end+1) = pitch_in(:,1);
cam_in(:, end+1)   = cam_in(:,1);
base_in(:, end+1)  = base_in(:,1);
prime_in(:, end+1) = prime_in(:,1);

%% === Motion Profile Plots ===
figure('Units','inches','Position',[1 1 14 10]);

subplot(4,1,1)
plot(theta_deg, dis*1000, 'k', 'LineWidth', 2);
ylabel('Displacement [mm]');
xlabel('\theta [°]');
title('3-Lobe Cam Displacement Profile');
grid on; box on;

subplot(4,1,2)
plot(theta_deg, vel*1000, 'k', 'LineWidth', 2);
ylabel('Velocity [mm/s]');
xlabel('\theta [°]');
title('3-Lobe Cam Velocity Profile');
grid on; box on;

subplot(4,1,3)
plot(theta_deg, acc*1000, 'k', 'LineWidth', 2);
ylabel('Acceleration [mm/s²]');
xlabel('\theta [°]');
title('3-Lobe Cam Acceleration Profile');
grid on; box on;

subplot(4,1,4)
plot(theta_deg, jerk*1000, 'k', 'LineWidth', 2);
ylabel('Jerk [mm/s³]');
xlabel('\theta [°]');
title('3-Lobe Cam Jerk Profile');
grid on; box on;

%% === Cam Profile Geometry Plot ===
width  = 1000; % Width of figure
height = 1000; % Height of figure (by default in pixels)
x      = 0;   % Screen position
y      = 0;   % Screen position
figure('Position', [x y width height]);

plot(pitch_in(1,:) * 1000, pitch_in(2,:) * 1000, '--k'); hold on;
plot(cam_in(1,:) * 1000, cam_in(2,:) * 1000, 'r', 'LineWidth', 2);
plot(prime_in(1,:) * 1000, prime_in(2,:) * 1000, 'g');
plot(base_in(1,:) * 1000, base_in(2,:) * 1000, 'b');

% plotting OD of cam
[~, idx] = min(cam_in(1,:));

% Get x and y in mm
x = cam_in(1, idx) * 1000;
y = cam_in(2, idx) * 1000;

% Compute radius from origin
r = sqrt(x^2 + y^2);

% Generate circle
theta = linspace(0, 2*pi, 100);
x_circle = r * cos(theta);
y_circle = r * sin(theta);
od_cam = sprintf('OD of cam: %0.5g mm',2*r);

% Plot circle
plot(x_circle, y_circle)
hold on
plot(x, y, 'ro') % mark the perimeter point
plot(0, 0, 'k+') % mark the origin


axis equal; box on; grid on;
xlabel('X [mm]');
ylabel('Y [mm]');
legend({'Pitch Curve', 'Cam Contour', 'Prime Circle', 'Base Circle',od_cam}, 'Location', 'best');
title('3-Lobe Cam Contour');



%% === Pressure Angle Plot ===
figure;
plot(theta_deg, rad2deg(phi), 'k');
xlabel('\theta [°]');
ylabel('Pressure Angle [°]');
title('Pressure Angle Across 3-Lobe Cam');
grid on; box on;

%% === Export Cam Profile (Optional) ===
if export_cam_contour
    solid_out = zeros(3, length(cam_in));
    solid_out(1:2,:) = cam_in * 1000;  % Convert to mm
    writematrix(solid_out', cam_contour_filename);
end
