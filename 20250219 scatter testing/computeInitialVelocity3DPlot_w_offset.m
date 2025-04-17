function v0 = computeInitialVelocity3DPlot_w_offset(x, y, z, x_offset, y_offset, z_offset)
% computeInitialVelocity3DPlot_w_offset(x, y, z, x_offset, y_offset, z_offset)
% x, y, z = target position in space
% x_offset, y_offset, z_offset = launcher origin position
% v0 = initial velocity vector [vx, vy, vz] from launcher origin

    % Constants
    g = 9.81;                  % gravity (m/s^2)
    angle_deg = 25;            % fixed elevation launch angle
    angle_rad = deg2rad(angle_deg);

    % === Compute relative displacement from launch point ===
    dx = x - x_offset;
    dy = y - y_offset;
    dz = z - z_offset;

    % Horizontal distance and azimuth
    r_xy = sqrt(dx^2 + dy^2);        % horizontal distance
    azimuth = atan2(dy, dx);         % horizontal direction

    % Solve for initial speed magnitude using projectile formula
    numerator = g * r_xy^2;
    denominator = 2 * (r_xy * tan(angle_rad) - dz) * cos(angle_rad)^2;

    if denominator <= 0
        error('Invalid target for given angle. Try a closer/higher target or lower angle.');
    end

    v0_mag = sqrt(numerator / denominator);

    % Decompose initial velocity into components
    vx = v0_mag * cos(angle_rad) * cos(azimuth);
    vy = v0_mag * cos(angle_rad) * sin(azimuth);
    vz = v0_mag * sin(angle_rad);
    v0 = [vx, vy, vz];

    % === Simulate Trajectory ===
    t_flight = (vz + sqrt(vz^2 + 2 * g * dz)) / g;
    t = linspace(0, t_flight, 200);

    % Full trajectory relative to the launch origin
    x_t = x_offset + vx * t;
    y_t = y_offset + vy * t;
    z_t = z_offset + vz * t - 0.5 * g * t.^2;

    % Final impact point (when it reaches z again)
    impact_x = x_offset + vx * t_flight;
    impact_y = y_offset + vy * t_flight;
    horizontal_range = sqrt((impact_x - x_offset)^2 + (impact_y - y_offset)^2);

    % === Plot Trajectory and Target ===
    plot3(x_t, y_t, z_t, 'k--', 'LineWidth', 1); hold on;
    plot3(x, y, z, 'ro', 'MarkerSize', 10, 'LineWidth', 2);  % target point

    % === Print Results ===
    fprintf('Initial velocity vector [vx, vy, vz] = [%.2f, %.2f, %.2f] m/s\n', vx, vy, vz);
    
    fprintf('Resultant speed: %.2f m/s\n', norm(v0));
    fprintf('Impact point at z=%.2f m: [x, y] = [%.2f, %.2f] m\n', z_offset, impact_x, impact_y);
    fprintf('Horizontal distance from origin to impact point: %.2f m\n', horizontal_range);
end
