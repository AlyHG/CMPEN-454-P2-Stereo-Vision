<h1 align="center">

CMPEN/EE 454 Project 2
</h1>

## Overview
The goal will be to use the tools we have developed through the last few lectures by considering stereo image pairs coupled with motion capture data. You’ll be given a pair of images taken from different cameras simultaneously. The person in the image is tagged with motion capture markers which were used to get accurate 3D point measurements. In this scenario, you have all of the intrinsic and extrinsic camera information, so you’ll be able to explore the 3D scene using the methods we’ve developed and use the motion capture data as a ground truth.

## Data
1. Two images `im1corrected.jpg` and `im2corrected.jpg` which represent the stereo pair.
2. Intrinsic and Extrinsic parameters for each camera `Parameters V1 1.mat` and `Parameters V1 2.mat`. Note that you’ll need to determine what parameters are what for this data using the information you know about the pinhole camera model. This exploration is part of the project.
3. Motion capture measurements `mocapPoints3D.mat` which contains point locations of the 39 markers on the person’s body. These are given in the world coordinate system with (0, 0, 0) being the middle of the floor, positive Z-axis is up, and the units are in millimeters.

## Tasks

### Task 1
Project 3D mocap points into 2D pixel locations. Your projections should result in pixel locations which correspond to the markers on the person’s body. Provide a plot indicating the locations of your 2D point locations overlayed on the image.

### Task 2
Use the 39 2D pixel locations computed in task 1 and perform triangulation to recover the 3D points. Compare the accuracy of your computed points and the mocap data using the mean square error. The error should be small.

### Task 3
Use triangulation to measure objects in the scene. You’ll obtain the pixel coordinates by clicking on the 3D object in both images; you’ll then use these to construct the 3D point in the scene. Perform the following tasks:
- **(a)**: Measure the 3D locations of 3 points on the floor and fit a 3D plane to them. Verify that your computed floor plane is an approximation  Z = 0 . What is the equation of the floor plane?
- **(b)**: Measure the 3D locations of 3 points on the wall that has white vertical stripes painted on it and fit a plane. What is the equation of the wall plane?
- **(c)**: Answer the following additional questions:
  - How tall is the doorway?
  - How tall is the person?
  - What is the 3D location of the center of the camera that can be seen in both images?

### Task 4
Compute the Fundamental matrix using the 8-point algorithm. Show the fundamental matrix and the epipolar lines.

### Task 5
Compute the accuracy of the epipolar lines using the Symmetric Epipolar Distance. This is computed as follows. In Task 1, we generated 39 image points. For a given 3D point let \( (x_1, y_1) \) denote its location in image 1 and \( (x_2, y_2) \) its location in image 2. Use your Fundamental matrix from the previous task to compute an epipolar line in image 2 using \( (x_1, y_1) \) and compute the squared geometric distance of \( (x_2, y_2) \) from the line. Then do the reverse, compute the epipolar line in image 1 using \( (x_2, y_2) \) and compute the squared geometric distance of \( (x_1, y_1) \) from the line. The square geometric distance for a point \( (x̂, ŷ) \) is given by:

$$
d^2 = \frac{(a \hat{x} + b \hat{y} + c)^2}{a^2 + b^2}
$$


Repeat this process for each of the 39 points. To get a single number describing the accuracy of the epipolar lines, take all of the distance you have computed and report the mean of these errors. This will be a single number.

## What to turn in
1. **Your code** in the following format:
   - Separate MATLAB files for each task labeled: `task1.m`, `task2.m`, `task3a.m`, `task3b.m`, `task3c.m`, `task4.m`, `task5.m`.
   - Very descriptive comments in each file.
   - Each file should run as a demo, displaying clear results.
2. **A 5-minute video presentation** which includes:
   - Title slide with group members and their contributions.
   - Run each of your demos and explain: what is being computed, what the output is, and how questions are answered. If something didn't work, explain what you have and the issues encountered.
