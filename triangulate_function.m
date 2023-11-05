function world_points = triangulate_function(points_img1, points_img2,Rmat_im1, Rmat_im2, t_im1, t_im2, Kmat_im1, Kmat_im2)
    % custom_triangulate: Triangulates 3D world points from corresponding 2D image points
    % using two camera views.
    %
    % Inputs:
    % - points_img1: 2D points from the first image [Nx2 matrix where N is the number of points]
    % - points_img2: Corresponding 2D points from the second image [Nx2 matrix]
    % - Rmat_im1, Rmat_im2: Rotation matrices for the two cameras
    % - t_im1, t_im2: Translation vectors for the two cameras
    % - Kmat_im1, Kmat_im2: Intrinsic matrices (calibration matrices) for the two cameras
    %
    % Outputs:
    % - world_points: Triangulated 3D world points [Nx3 matrix]

    % Get the number of points to triangulate
    num_points = size(points_img1, 1);

    % Compute the transposes of the rotation matrices for each camera
    % This helps in finding the camera centers (optical centers)
    R_im1_transpose = transpose(Rmat_im1);
    R_im2_transpose = transpose(Rmat_im2);

    % Compute the optical centers of each camera
    % These represent the locations of camera lenses in the world
    O_Im1 = -R_im1_transpose * t_im1;
    O_Im2 = -R_im2_transpose * t_im2;

    % Compute the baseline vector T
    % This is the vector connecting the optical centers of the two cameras
    T = O_Im1 - O_Im2;

    % Initialize the output matrix to store triangulated 3D world points
    world_points = zeros(num_points, 3);

    % Start the triangulation process for each corresponding point pair
    for i = 1:num_points
        % Compute the viewing ray for the point in the first image
        % This ray starts from the optical center and passes through the image point
        im1_FilmPoint = [points_img1(i,:)'; 1];
        u_im1 = R_im1_transpose * (inv(Kmat_im1) * im1_FilmPoint);

        % Compute the viewing ray for the point in the second image
        im2_FilmPoint = [points_img2(i,:)'; 1];
        u_im2 = R_im2_transpose * (inv(Kmat_im2) * im2_FilmPoint);

        % Normalize the viewing rays
        % This step ensures that the rays have a unit length
        u1 = u_im1 / norm(u_im1);
        u2 = u_im2 / norm(u_im2);

        % Compute a third ray that is orthogonal to both u1 and u2
        % This represents the direction of the shortest line connecting the two viewing rays
        u3 = cross(u1, u2);
        u3 = u3 / norm(u3);

        % Construct a matrix A using the viewing rays and the orthogonal ray
        A = [u2, -u1, u3];

        % Solve for the scaling coefficients a, b, and c
        % These coefficients help in determining the 3D points on each viewing ray
        coeffs = A \ T;
        a = coeffs(1);
        b = coeffs(2);

        % Compute 3D points on each viewing ray using the scaling coefficients
        P_im1 = O_Im1 + b * u1;
        P_im2 = O_Im2 + a * u2;

        % The triangulated 3D point is the midpoint of the segment connecting the 3D points on the viewing rays
        P_w = (P_im1 + P_im2) / 2;

        % Store the triangulated 3D point in the output matrix
        world_points(i,:) = P_w(1:3)';
    end
end
