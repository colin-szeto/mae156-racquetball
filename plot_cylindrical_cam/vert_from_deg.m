degrees = [119];

for i = 1:length(degrees)
    deg = degrees(i);
    [y_val, seg] = getYFromDegree(deg);
    fprintf('Deg: %3d° → Y: %.2f mm (%s segment)\n', deg, y_val, seg);
end
