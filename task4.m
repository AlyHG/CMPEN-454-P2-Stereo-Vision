load 'Task3_pixel_coords.mat'

% Read images
img1 = imread('im1corrected.jpg');
img2 = imread('im2corrected.jpg');

% Using 8 points of correspondence (3 for Floor, 3 for Wall, 2 for Door)
points_img1 = [floor_1; Door_1; Wall_1];
points_img2 = [floor_2; Door_2; Wall_2];

% Estimate the Fundamental Matrix
[F, inliers] = estimateFundamentalMatrix(points_img1, points_img2, 'Method', 'Norm8Point');

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
