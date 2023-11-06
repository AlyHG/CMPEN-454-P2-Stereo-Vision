% Must Run Task 1 First to get necessary variables
run("task1.m")


load 'Task3_pixel_coords.mat'

% Code for Selecting Coordinates 3 Coordinates for Floor
%figure, imshow('im1corrected.jpg');
%title('Select 3 points for the floor on the first image.');
%floor_1 = ginput(3);  % Select 3 points for the floor
%figure, imshow('im2corrected.jpg');
%title('Select the corresponding 3 points on the floor in the second image.');
%floor_2 = ginput(3);  % Select the same 3 points in the second image.

% Using Triangulation to compute the 3 points in 3D space 
Floor3D = triangulate_function(floor_1, floor_2,Rmat_im1, Rmat_im2, t_im1, t_im2, Kmat_im1, Kmat_im2);

% Compute the two vectors along the floor plane using the 3D coordinates
Floor_vec1 = Floor3D(2,:) - Floor3D(1,:);
Floor_vec2 = Floor3D(3,:) - Floor3D(1,:);

% Compute the normal vector to the floor plane via cross product
Floor_normal = cross(Floor_vec1, Floor_vec2);
% Normalizing the vector
Floor_normal = Floor_normal / norm(Floor_normal);
% Solving for 'd' in Plane Equation using the normal and the first point
Floor_d = -dot(Floor_normal, Floor3D(1,:));

disp(['Floor Plane equation: ', num2str(Floor_normal(1)), '*x + ', num2str(Floor_normal(2)), '*y + ', num2str(Floor_normal(3)), '*z + ', num2str(Floor_d), ' = 0']);

% Code for Selecting 3 Coordinates for Wall Plane 
%figure, imshow('im1corrected.jpg');
%title('Select 3 points for the Wall on the first image.');
%Wall_1 = ginput(3);  % Select 3 points for the floor
% figure, imshow('im2corrected.jpg');
% title('Select the corresponding 3 points on the Wall in the second image.');
% Wall_2 = ginput(3);  % Select the same 3 points in the second image.

% Using Triangulation to compute the 3 points in 3D space 
Wall3D = triangulate_function(Wall_1, Wall_2, Rmat_im1, Rmat_im2, t_im1, t_im2, Kmat_im1, Kmat_im2);

% Compute the two vectors along the Wall plane using the 3D coordinates
Wall_vec1 = Wall3D(2,:) - Wall3D(1,:);
Wall_vec2 = Wall3D(3,:) - Wall3D(1,:);

% Compute the normal vector to the floor plane via cross product
Wall_normal = cross(Wall_vec1, Wall_vec2);
% Normalizing the vector
Wall_normal = Wall_normal / norm(Wall_normal);
% Solving for 'd' in Plane Equation using the normal and the first point
Wall_d = -dot(Wall_normal, Floor3D(1,:));

disp(['Wall Plane equation: ', num2str(Wall_normal(1)), '*x + ', num2str(Wall_normal(2)), '*y + ', num2str(Wall_normal(3)), '*z + ', num2str(Wall_d), ' = 0']);

% Code for Selecting Coordinates of Center of Camera
% figure; imshow('im1corrected.jpg');
% title('Select the center of the camera in the first image.');
% camera_1 = ginput(1);
% figure; imshow('im2corrected.jpg');
% title('Select the center of the camera in the second image.');
% camera_2 = ginput(1);

% Using Triangulation to compute the point in 3D space
Camera3D = triangulate_function(camera_1, camera_2, Rmat_im1, Rmat_im2, t_im1, t_im2, Kmat_im1, Kmat_im2);
disp(['3D location of the camera center: [', num2str(Camera3D), ']']);


% figure; imshow('im1corrected.jpg');
% title('Select the bottom THEN Top points of the Person in Image.');
% Person_1 = ginput(2);
% figure; imshow('im2corrected.jpg');
% title('Select the corresponding bottom THEN Top points of the Person in Image.');
% Person_2 = ginput(2);

% Using Triangulation to compute the points in 3D space (bottom and top of
% the person)
Person3D = triangulate_function(Person_1, Person_2, Rmat_im1, Rmat_im2, t_im1, t_im2, Kmat_im1, Kmat_im2);

% Calculating the vertical difference (diff in z axis) to get height of
% person
Person_height = abs(Person3D(2,3) - Person3D(1,3));
disp(['Height of Person: ', num2str(Person_height), ' mm']);

% Code for Selecting 2 points in each image corresponding to bottom and top
% of doorway to calculate height
% figure; imshow('im1corrected.jpg');
% title('Select the bottom THEN Top points of the Doorway in Image.');
% Door_1 = ginput(2);
% figure; imshow('im2corrected.jpg');
% title('Select the corresponding bottom THEN Top points of the Doorway in Image.');
% Door_2 = ginput(2);

% Using Triangulation to compute the points in 3D space (bottom and top of
% the Doorway)
Door3D = triangulate_function(Door_1, Door_2, Rmat_im1, Rmat_im2, t_im1, t_im2, Kmat_im1, Kmat_im2);
% Calculating the vertical difference (diff in z axis) to get height of
% Door
Door_height = abs(Door3D(2,3) - Door3D(1,3));
disp(['Height of Doorway: ', num2str(Door_height), ' mm']);
