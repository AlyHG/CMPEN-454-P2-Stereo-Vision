load 'mocapPoints3D.mat'
load 'Parameters_V1_1.mat'

% get the matrix of pixel coordinates converted from world coordinates
Pmat_im1 = Parameters.Pmat;
Kmat_im1 = Parameters.Kmat;
Rmat_im1 = Parameters.Rmat;
t_im1 = Pmat_im1(1:3, 4);

% created point world coordinate with Homogeneous coordinate
pts3D_worldpoint = [pts3D; ones(1,39)];

% Implementing Pinpoint Camera Model for all 39 film points
Im1_film_matrix = [];
for i = 1:size(pts3D,2)
    pixel_coords_math = Kmat_im1 * Pmat_im1 * pts3D_worldpoint(:,i);
    Im1_filmcoord = [pixel_coords_math(1,1)/pixel_coords_math(3,1); pixel_coords_math(2,1)/pixel_coords_math(3,1);1];
    Im1_film_matrix = [Im1_film_matrix Im1_filmcoord];
end

% Showing film points with respect to body in image
im1corrected = imread("im1corrected.jpg");
figure; show_im1 = imshow(im1corrected);
hold on;
x1 = Im1_film_matrix(1,:);
y1 = Im1_film_matrix(2,:);
scatter(x1,y1);
hold off;

load 'Parameters_V2_1.mat'

% get the matrix of pixel coordinates converted from world coordinates
Pmat_im2 = Parameters.Pmat;
Kmat_im2 = Parameters.Kmat;
Rmat_im2 = Parameters.Rmat;
t_im2 = Pmat_im2(1:3, 4);

% created Pmat with homogeneous coordinates
Pmat_padded = [Pmat_im2; zeros(1,3) ones(1,1)];

% Created Calibrated Matrix
zero_col = zeros(size(Kmat_im2,1),1);
Kmat_adjusted = [Kmat_im2, zero_col];

% created point world coordinates with Homogeneous coordinate
pts3D_worldpoint = [pts3D; ones(1,39)];

% Implementing Pinpoint Camera Model for all 39 film points
Im2_film_matrix = [];
for i = 1:size(pts3D,2)
    pixel_coords_math2 = Kmat_im2 * Pmat_im2 * pts3D_worldpoint(:,i);
    Im2_filmcoord = [pixel_coords_math2(1,1)/pixel_coords_math2(3,1); pixel_coords_math2(2,1)/pixel_coords_math2(3,1);1];
    Im2_film_matrix = [Im2_film_matrix Im2_filmcoord];
end

% Showing film points with respect to body in image
im2corrected = imread("im2corrected.jpg");
figure; show_im2 = imshow(im2corrected);
hold on;
x2 = Im2_film_matrix(1,:);
y2 = Im2_film_matrix(2,:);
scatter(x2,y2);
hold off;