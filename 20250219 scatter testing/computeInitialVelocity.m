function v0 = computeInitialVelocity(x, y, z)
% function v0 = computeInitialVelocity(x, y, z)
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
    
    % Now we solve for the total initial speed v0 using projectile motion
    % z = r_xy * tan(angle) - (g * r_xy^2) / (2 * v0^2 * cos(angle)^2)
    % Solve this equation for v0
    
    numerator = g * r_xy^2;
    denominator = 2 * (r_xy * tan(angle_rad) - z) * cos(angle_rad)^2;
    
    if denominator <= 0
        error('Invalid target location for given angle. Try a higher target or lower angle.');
    end
    
    v0_mag = sqrt(numerator / denominator);  % total speed magnitude
    
    % Components of velocity
    vx = v0_mag * cos(angle_rad) * cos(azimuth);
    vy = v0_mag * cos(angle_rad) * sin(azimuth);
    vz = v0_mag * sin(angle_rad);
    
    v0 = [vx, vy, vz];
    
    fprintf('Initial velocity vector [vx, vy, vz] = [%.2f, %.2f, %.2f] m/s\n', vx, vy, vz);
end
