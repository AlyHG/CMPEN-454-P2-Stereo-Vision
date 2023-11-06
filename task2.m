%Run Task 1 first to get the necessary variables
run("task1.m")

R_im1_transpose = transpose(Rmat_im1);
R_im2_transpose = transpose(Rmat_im2);

% finding baseline from camera 1 (right) and camera 2 (left)
O_Im1 = -R_im1_transpose * t_im1;
O_Im2 = -R_im2_transpose * t_im2;
T = O_Im1 - O_Im2;

% Defining observed matrix
P_w_matrix = ones(4, 39);

% Initiating Triangulation Process
for i = 1:size(pts3D,2)

    % Grabbing results from task 1 to create viewing rays 
    im1_FilmPoint = Im1_film_matrix(:,i);
    u_im1 = R_im1_transpose * ((Kmat_im1)\im1_FilmPoint);

    im2_FilmPoint = Im2_film_matrix(:,i);
    u_im2 = R_im2_transpose * ((Kmat_im2)\im2_FilmPoint);

    % defining viewing rays u1 and u2
    norm_u_im1 = norm(u_im1);
    norm_u_im2 = norm(u_im2);
    u1 = u_im1 / norm_u_im1;
    u2 = u_im2 / norm_u_im2;

    % defining non intersecting viewing ray u3 based on u1 and u2
    u3_A = cross(u_im1, u_im2);
    u3_B = norm(cross(u_im1, u_im2));
    u3 = u3_A/u3_B;

    % creating matrix of viewing rays
    A = [u2, -u1, u3];
    
    % defining scaling coefficients that go along with the viewing rays and
    % separated into three coefficients for each ray
    coeffs = A\T;

    a = coeffs(1,1);
    b = coeffs(2,1);
    c = coeffs(3,1);

    % creating world point coordinates from each camera 
    P_im1 = O_Im1 + b*u1;
    P_im2 = O_Im2 + a*u2;

    % Combining world coordinates from each camera to define the observed
    % world coordinates then put them into a matrix of observed point 
    % world coordinates.
    P_w = (P_im1 + P_im2)/2;
    P_w_matrix(1:3, i) = P_w;
end

% Applying Mean Squared Error Equation to find difference betweeen 
% observed and given coordinates.
World_coord_diff = P_w_matrix - pts3D_worldpoint;
World_coord_diff_squared = World_coord_diff.^2;
n = 3*size(pts3D, 2);   % 3 coordinates per point size(pts3D, 2) = # of columns = 39 hence 3*39
World_sum = sum(World_coord_diff_squared, 'all');
MeanSquaredError = World_sum./n;
display(['Mean Squared Error = ', num2str(MeanSquaredError)]);

