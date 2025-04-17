function v0 = computeInitialVelocity3DPlot(x, y, z,z_offset)
% function v0 = computeInitialVelocity3DPlot(x, y, z)
% takex x y (azimuth) z (elevation
% v0 is the initla velocity 
% fixed able 25
% assumes 0,0,0 is the origin 

    % Constants
    g = 9.81;            % gravity (m/s^2)
    angle_deg = 25;      % launch elevation angle
    angle_rad = deg2rad(angle_deg);  % convert to radians
    
    % Compute horizontal distance and azimuth
    r_xy = sqrt(x^2 + y^2);              % distance in horizontal plane
    r_total = sqrt(x^2 + y^2 + z^2);     % total distance
    
    % Azimuth angle (horizontal direction)
    azimuth = atan2(y, x);  % direction in x-y plane
    
    % Solve for required speed using projectile motion
    numerator = g * r_xy^2;
    denominator = 2 * (r_xy * tan(angle_rad) - z) * cos(angle_rad)^2;
    
    if denominator <= 0
        error('Invalid target location for given angle. Try a higher target or lower angle.');
    end
    
    v0_mag = sqrt(numerator / denominator);  % total speed magnitude
    
    % Velocity components
    vx = v0_mag * cos(angle_rad) * cos(azimuth);
    vy = v0_mag * cos(angle_rad) * sin(azimuth);
    vz = v0_mag * sin(angle_rad);
    
    v0 = [vx, vy, vz];
    
    % --- Trajectory Simulation ---
    t_flight = (vz + sqrt(vz^2 + 2 * g * z)) / g;  % approximate flight time
    t = linspace(0, t_flight, 1000);
    
    % Position equations
    x_t = vx * t;
    y_t = vy * t;
    z_t = vz * t - 0.5 * g * t.^2;

    % Impact point (where z=0 again)
    impact_x = vx * t_flight;
    impact_y = vy * t_flight;
    horizontal_range = sqrt(impact_x^2 + impact_y^2);
    
    % Plot 3D trajectory
    %figure;
    plot3(x_t, y_t, z_t, 'black--', 'LineWidth', 1); hold on;
    plot3(x, y, z, 'ro', 'MarkerSize', 10, 'LineWidth', 2);  % target point
    %plot3(impact_x, impact_y, 0, 'go', 'MarkerSize', 10, 'LineWidth', 2);  % impact point

    %xlabel('X (m)');
    %ylabel('Y (m)');
    %zlabel('Z (m)');
    %title('3D Racquetball Trajectory');
    %grid on;
    %axis equal;
    %legend('Trajectory', 'Target Point');
    %view(45, 30);  % 3D angle for better visibility
    
    % Display result
    fprintf('Initial velocity vector [vx, vy, vz] = [%.2f, %.2f, %.2f] m/s\n', vx, vy, vz);
    fprintf('resultant %.2f m/s\n', sqrt(vx^2 + vy^2 + vz^2));

    fprintf('Impact point at z=0: [x, y] = [%.2f, %.2f] m\n', impact_x, impact_y);
    fprintf('Horizontal distance from origin to impact point: %.2f m\n', horizontal_range);
end
