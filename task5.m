load 'Task3_pixel_coords.mat';

% run('task4.m')  % To load necessary variables
% run('task1.m')

% Fundamental Matrix already computed in Task 4

% Compute the symmetric epipolar distance
num_points = size(Im1_film_matrix, 2);
distances = zeros(num_points, 1);

for i = 1:num_points
    % Point from image 1
    x1 = Im1_film_matrix(1, i);
    y1 = Im1_film_matrix(2, i);
    
    % Corresponding point from image 2
    x2 = Im2_film_matrix(1, i);
    y2 = Im2_film_matrix(2, i);
    
    % Epipolar line in image 2 for point from image 1
    l2 = F * [x1; y1; 1];
    
    % Squared distance from point in image 2 to epipolar line
    d2_1 = (l2(1)*x2 + l2(2)*y2 + l2(3))^2 / (l2(1)^2 + l2(2)^2);
    
    % Epipolar line in image 1 for point from image 2
    l1 = F' * [x2; y2; 1];
    
    % Squared distance from point in image 1 to epipolar line
    d2_2 = (l1(1)*x1 + l1(2)*y1 + l1(3))^2 / (l1(1)^2 + l1(2)^2);
    
    % Sum of squared distances
    distances(i) = d2_1 + d2_2;
end


% Compute the mean of the squared distances
mean_distance = mean(distances);
disp([newline,'Mean Symmetric Epipolar Distance: ', num2str(mean_distance)]);