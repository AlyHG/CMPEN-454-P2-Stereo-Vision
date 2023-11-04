ProjectionMatrix_1 = Kmat_im1*Pmat_im1;
ProjectionMatrix_2 = Kmat_im2*Pmat_im2;

load 'Task3_pixel_coords.mat'
%figure, imshow('im1corrected.jpg');
%title('Select 3 points for the floor on the first image.');
%floor_1 = ginput(3);  % Select 3 points for the floor
%figure, imshow('im2corrected.jpg');
%title('Select the corresponding 3 points on the floor in the second image.');
%floor_2 = ginput(3);  % Select the same 3 points in the second image.

Floor3D = triangulate(floor_1, floor_2, ProjectionMatrix_1, ProjectionMatrix_2);

% Compute Floor plane from three 3D points
Floor_vec1 = Floor3D(2,:) - Floor3D(1,:);
Floor_vec2 = Floor3D(3,:) - Floor3D(1,:);

Floor_normal = cross(Floor_vec1, Floor_vec2);
Floor_normal = Floor_normal / norm(Floor_normal);
Floor_d = -dot(Floor_normal, Floor3D(1,:));

disp(['Floor Plane equation: ', num2str(Floor_normal(1)), '*x + ', num2str(Floor_normal(2)), '*y + ', num2str(Floor_normal(3)), '*z + ', num2str(Floor_d), ' = 0']);


%figure, imshow('im1corrected.jpg');
%title('Select 3 points for the Wall on the first image.');
%Wall_1 = ginput(3);  % Select 3 points for the floor
% figure, imshow('im2corrected.jpg');
% title('Select the corresponding 3 points on the Wall in the second image.');
% Wall_2 = ginput(3);  % Select the same 3 points in the second image.

Wall3D = triangulate(Wall_1, Wall_2, ProjectionMatrix_1, ProjectionMatrix_2);

% Compute Wall plane from three 3D points
Wall_vec1 = Wall3D(2,:) - Wall3D(1,:);
Wall_vec2 = Wall3D(3,:) - Wall3D(1,:);

Wall_normal = cross(Wall_vec1, Wall_vec2);
Wall_normal = Wall_normal / norm(Wall_normal);
Wall_d = -dot(Wall_normal, Floor3D(1,:));

disp(['Wall Plane equation: ', num2str(Wall_normal(1)), '*x + ', num2str(Wall_normal(2)), '*y + ', num2str(Wall_normal(3)), '*z + ', num2str(Wall_d), ' = 0']);
% 
% figure; imshow('im1corrected.jpg');
% title('Select the center of the camera in the first image.');
% camera_1 = ginput(1);
% figure; imshow('im2corrected.jpg');
% title('Select the center of the camera in the first image.');
% camera_2 = ginput(1);

Camera3D = triangulate(camera_1, camera_2, ProjectionMatrix_1, ProjectionMatrix_2);
disp(['3D location of the camera center: [', num2str(Camera3D), ']']);


% figure; imshow('im1corrected.jpg');
% title('Select the bottom THEN Top points of the Person in Image.');
% Person_1 = ginput(2);
% figure; imshow('im2corrected.jpg');
% title('Select the corresponding bottom THEN Top points of the Person in Image.');
% Person_2 = ginput(2);

Person3D = triangulate(Person_1, Person_2, ProjectionMatrix_1, ProjectionMatrix_2);
Person_height = abs(Person3D(2,3) - Person3D(1,3));
disp(['Height of Person: ', num2str(Person_height), ' mm']);

% figure; imshow('im1corrected.jpg');
% title('Select the bottom THEN Top points of the Doorway in Image.');
% Door_1 = ginput(2);
% figure; imshow('im2corrected.jpg');
% title('Select the corresponding bottom THEN Top points of the Doorway in Image.');
% Door_2 = ginput(2);

Door3D = triangulate(Door_1, Door_2, ProjectionMatrix_1, ProjectionMatrix_2);
Door_height = abs(Door3D(2,3) - Door3D(1,3));
disp(['Height of Doorway: ', num2str(Door_height), ' mm']);
