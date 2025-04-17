% 3D Projectile Motion with Euler-Cromer Method (No Spin, Multiple Shots)
clear; clc; close all;

%-------------------------------
% Parameters
%-------------------------------
m = 0.04252;              % mass (kg) - racquet ball
r = 0.055 / 2;            % radius (m)
A = pi * r^2;             % cross-sectional area (m^2)
Cd = 0.47;                % drag coefficient
rho = 1.225;              % air density (kg/m^3)
g = -9.81;                % gravity (m/s^2)
dt = 0.001;               % time step (s)
t_max = 10;               % max simulation time (s)

%-------------------------------
% Initial Velocity Sets [Horizontal, Vertical]
%-------------------------------
velocities = [
    11.60825411, 5.413013368;
    13.92990494, 6.495616041;
    16.25155576, 7.578218715;
    18.57320658, 8.660821389
];

colors = lines(size(velocities, 1)); % Different colors for each trajectory

figure; hold on;
title('3D Projectile Trajectories (No Spin, With Drag)');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
grid on; view(45, 25);
legendEntries = {'' '' '' '' '' '' '' ''};

%-------------------------------
% Loop Through Each Velocity Set
%-------------------------------
for i = 1:size(velocities, 1)
    U0 = velocities(i, 1);
    V0 = 0;
    W0 = velocities(i, 2);
    
    % Initial positions
    X0 = 0; Y0 = 0; Z0 = 0;
    
    % Initialization
    N = ceil(t_max / dt);
    U = zeros(1, N); V = zeros(1, N); W = zeros(1, N);
    X = zeros(1, N); Y = zeros(1, N); Z = zeros(1, N);
    T = zeros(1, N);

    % Set initial values
    U(1) = U0; V(1) = V0; W(1) = W0;
    X(1) = X0; Y(1) = Y0; Z(1) = Z0;

    % Euler-Cromer Integration Loop
    for n = 1:N-1
        Vmag = sqrt(U(n)^2 + V(n)^2 + W(n)^2);
        fric_coeff = Cd * rho * A / (2 * m);

        % Update velocities
        U(n+1) = U(n) - dt * (fric_coeff * Vmag * U(n));
        V(n+1) = V(n) - dt * (fric_coeff * Vmag * V(n));
        W(n+1) = W(n) - dt * (fric_coeff * Vmag * W(n) - g);

        % Update positions
        X(n+1) = X(n) + dt * U(n+1);
        Y(n+1) = Y(n) + dt * V(n+1);
        Z(n+1) = Z(n) + dt * W(n+1);

        T(n+1) = T(n) + dt;

        % Stop if projectile hits the ground
        if Z(n+1) < 0
            break;
        end
    end

    % Trim
    X = X(1:n); Y = Y(1:n); Z = Z(1:n);

    % Plot trajectory
    plot3(X, Y, Z, '-', 'LineWidth', 2, 'Color', colors(i, :));
    plot3(X(end), Y(end), 0, 'o', 'MarkerSize', 6, ...
          'MarkerFaceColor', colors(i, :), 'Color', colors(i, :));
    
    % Legend entry
    %legendEntries{end} = ' ';
    legendEntries{2*i -1} = sprintf('U=%.2f, W=%.2f, Lin Dist=%.2f', U0, W0, sqrt(X(end)^2 +Y(end)^2));
    
end

plot3([1,1],[0,0],[0,2.5],'--b','LineWidth',2)

legend(legendEntries, 'Location', 'northeast');
axis equal;
