% Load the image correspondences
load 'Task3_pixel_coords.mat'

% Read the images
img1 = imread('im1corrected.jpg');
img2 = imread('im2corrected.jpg');

% Using 8 points of correspondence (3 for Floor, 3 for Wall, 2 for Door)
points_img1 = [floor_1; Door_1; Wall_1];
points_img2 = [floor_2; Door_2; Wall_2];

% % Estimate the Fundamental Matrix
% [F, inliers] = estimateFundamentalMatrix(points_img1, points_img2, 'Method', 'Norm8Point');


% --- Begin: Eight-Point Algorithm for Fundamental Matrix ---

% Extract the x and y coordinates from the image points
x1 = points_img1(:, 1);
y1 = points_img1(:, 2);
x2 = points_img2(:, 1);
y2 = points_img2(:, 2);

% Hartley Preconditioning
% Calculate the mean and standard deviation for the points in the first image
mux = mean(x1);
muy = mean(y1);
stdxy = (std(x1) + std(y1)) / 2;

% Define a transformation matrix T1 based on the mean and standard deviation
T1 = [1 0 -mux; 0 1 -muy; 0 0 stdxy] / stdxy;

% Normalize the points in the first image
nx1 = (x1 - mux) / stdxy;
ny1 = (y1 - muy) / stdxy;

% Repeat the above normalization process for the points in the second image
mux = mean(x2);
muy = mean(y2);
stdxy = (std(x2) + std(y2)) / 2;
T2 = [1 0 -mux; 0 1 -muy; 0 0 stdxy] / stdxy;
nx2 = (x2 - mux) / stdxy;
ny2 = (y2 - muy) / stdxy;

% Construct the matrix A, based on the normalized points
A = [];
for i=1:length(nx1)
    A(i,:) = [nx1(i)*nx2(i) nx1(i)*ny2(i) nx1(i) ny1(i)*nx2(i) ny1(i)*ny2(i) ny1(i) nx2(i) ny2(i) 1];
end

% Calculate the Fundamental Matrix F from A using the smallest eigenvalue
[u,d] = eigs(A' * A,1,'SM');
F = reshape(u,3,3);

% Enforce a rank-2 constraint on F. This is because the Fundamental matrix is inherently rank-2
[U,D,V] = svd(F);
D(3,3) = 0;
F = U * D * V';

% Undo the normalization to obtain the actual Fundamental matrix
F = T2' * F * T1;
% --- End:  Eight-Point Algorithm for Fundamental Matrix ---

% Display the epipolar lines in the first image
figure, imshow(img1);
title('Epipolar Lines in First Image');
hold on;
epiLines1 = epipolarLine(F', points_img2);
points = lineToBorderPoints(epiLines1, size(img1));
line(points(:, [1,3])', points(:, [2,4])', 'Color', 'g', 'LineWidth', 1.5);
hold off;

% Display the equations of the epipolar lines for the first image
disp('Epipolar Lines for First Image:');
for i = 1:size(epiLines1, 1)
    fprintf('Line %d: %fx + %fy + %f = 0\n', i, epiLines1(i,1), epiLines1(i,2), epiLines1(i,3));
end

% Display the epipolar lines in the second image
figure, imshow(img2);
title('Epipolar Lines in Second Image');
hold on;
epiLines2 = epipolarLine(F, points_img1);
points = lineToBorderPoints(epiLines2, size(img2));
line(points(:, [1,3])', points(:, [2,4])', 'Color', 'g', 'LineWidth', 1.5);
hold off;

% Display the equations of the epipolar lines for the second image
disp('Epipolar Lines for Second Image:');
for i = 1:size(epiLines2, 1)
    fprintf('Line %d: %fx + %fy + %f = 0\n', i, epiLines2(i,1), epiLines2(i,2), epiLines2(i,3));
end

% Display the Fundamental Matrix
disp('Fundamental Matrix:');
disp(F);
