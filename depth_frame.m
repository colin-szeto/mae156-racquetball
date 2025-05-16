clear; close all; clc; 

% Load the data from the CSV file, skipping the first 13 rows
data = readmatrix('data.csv');  % Use full path if not in current folder
data = data(14:end, :);         % Adjust if your data starts later

% Remove any completely empty rows or columns
data(all(isnan(data), 2), :) = [];  % Remove empty rows
data(:, all(isnan(data), 1)) = [];  % Remove empty columns

% Get the size of the matrix
[numRows, numCols] = size(data);

% Create X and Y grids
[x, y] = meshgrid(1:numCols, 1:numRows);

% Create the surface plot
surf(-x, y, -data);
xlabel('X (Column Index)');
ylabel('Y (Row Index)');
zlabel('Z (Cell Value)');
title('Surface Plot from Cell Values');
colorbar;
shading interp;
