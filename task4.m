% 8 Point Algorithm
im = imread('im1corrected.jpg');
im2 = imread('im2corrected.jpg');

% Commented Out this section of the Code so Points do not have to be
% selected every single time.

% figure(1); imagesc(im); axis image; drawnow;
% figure(2); imagesc(im2); axis image; drawnow;
% 
% 
% figure(1); [x1,y1] = getpts;
% figure(1); imagesc(im); axis image; hold on
% for i=1:length(x1)
%    h=plot(x1(i),y1(i),'*'); set(h,'Color','g','LineWidth',2);
%    text(x1(i),y1(i),sprintf('%d',i));
% end
% hold off
% drawnow;
% 
% 
% figure(2); imagesc(im2); axis image; drawnow;
% [x2,y2] = getpts;
% figure(2); imagesc(im2); axis image; hold on
% for i=1:length(x2)
%    h=plot(x2(i),y2(i),'*'); set(h,'Color','g','LineWidth',2);
%    text(x2(i),y2(i),sprintf('%d',i));
% end
% hold off
% drawnow;
% 
% % Saving the points
% save('Task4_points_img1.mat', 'x1', 'y1');
% save('Task4_points_img2.mat', 'x2', 'y2');

% Pre-loading the 8 points of correspondence from each Image
load('Task4_points_img1.mat')
load('Task4_points_img2.mat')

% Hartley preconditioning normalizes the points so that
% they have a mean of zero and a standard deviation of one, which
% makes numerical computations more stable.

% Save original x and y coordinates for both images
savx1 = x1; savy1 = y1; savx2 = x2; savy2 = y2;

% Compute the mean of the x and y coordinates for image 1
mux = mean(x1);
muy = mean(y1);
% Compute the average standard deviation for x and y coordinates of image 1
stdxy = (std(x1)+std(y1))/2;
% Create a transformation matrix for image 1 based on the mean and average standard deviation
T1 = [1 0 -mux; 0 1 -muy; 0 0 stdxy]/stdxy;
% Normalize the coordinates for image 1
nx1 = (x1-mux)/stdxy;
ny1 = (y1-muy)/stdxy;

% Repeat the above normalization process for image 2
mux = mean(x2);
muy = mean(y2);
stdxy = (std(x2)+std(y2))/2;
T2 = [1 0 -mux; 0 1 -muy; 0 0 stdxy]/stdxy;
nx2 = (x2-mux)/stdxy;
ny2 = (y2-muy)/stdxy;

% Construct matrix A based on the normalized points which will be used to compute the Fundamental matrix
A = [];
for i=1:length(nx1);
    A(i,:) = [nx1(i)*nx2(i) nx1(i)*ny2(i) nx1(i) ny1(i)*nx2(i) ny1(i)*ny2(i) ny1(i) nx2(i) ny2(i) 1];
end

% Compute the eigenvector associated with the smallest eigenvalue of A' * A. This will be used to shape the Fundamental matrix.
[u,d] = eigs(A' * A,1,'SM');
F = reshape(u,3,3);

% Enforce rank-2 constraint on the Fundamental matrix because it is inherently rank-2
oldF = F;
[U,D,V] = svd(F);
D(3,3) = 0;
F = U * D * V';

% Undo the normalization to obtain the actual Fundamental matrix
F = T2' * F * T1;

% Define a sequence of colors for plotting epipolar lines
colors =  'bgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmyk';

% Compute and overlay epipolar lines on image 2 based on points from image 1
L = F * [x1' ; y1'; ones(size(x1'))];
[nr,nc,nb] = size(im2);
figure(2); clf; imagesc(im2); axis image;
hold on; plot(x2,y2,'*'); hold off
% Plot each epipolar line
for i=1:length(L)
    a = L(1,i); b = L(2,i); c=L(3,i);
    % Determine endpoints of the line segment to plot based on the dominant direction
    % and then plot the line
    if (abs(a) > (abs(b)))
       ylo=0; yhi=nr; 
       xlo = (-b * ylo - c) / a;
       xhi = (-b * yhi - c) / a;
       hold on
       h=plot([xlo; xhi],[ylo; yhi]);
       set(h,'Color',colors(i),'LineWidth',2);
       hold off
       drawnow;
    else
       xlo=0; xhi=nc; 
       ylo = (-a * xlo - c) / b;
       yhi = (-a * xhi - c) / b;
       hold on
       h=plot([xlo; xhi],[ylo; yhi],'b');
       set(h,'Color',colors(i),'LineWidth',2);
       hold off
       drawnow;
    end
end

% Repeat the above process but overlay epipolar lines on image 2 based on points from image 1
L = ([x2' ; y2'; ones(size(x2'))]' * F)' ;
[nr,nc,nb] = size(im);
figure(1); clf; imagesc(im); axis image;
hold on; plot(x1,y1,'*'); hold off
% Plot each epipolar line
for i=1:length(L)
    a = L(1,i); b = L(2,i); c=L(3,i);
    % Determine endpoints of the line segment to plot based on the dominant direction
    % and then plot the line
    if (abs(a) > (abs(b)))
       ylo=0; yhi=nr; 
       xlo = (-b * ylo - c) / a;
       xhi = (-b * yhi - c) / a;
       hold on
       h=plot([xlo; xhi],[ylo; yhi],'b');
       set(h,'Color',colors(i),'LineWidth',2);
       hold off
       drawnow;
    else
       xlo=0; xhi=nc; 
       ylo = (-a * xlo - c) / b;
       yhi = (-a * xhi - c) / b;
       hold on
       h=plot([xlo; xhi],[ylo; yhi],'b');
       set(h,'Color',colors(i),'LineWidth',2);
       hold off
       drawnow;
    end
end

% Display Fundamental matrix, Scaled by 1000
disp([newline,'Fundamental Matrix * 1000'])
for j=1:3
    for i=1:3
        fprintf('%10g ',10000*F(j,i));
    end
    fprintf('\n');
end
