%% Murat Ambarkutuk PS-3
clc; close all; clear all; profile on;
% 1- Programming: Image Mosaics
%% 1-1
% Load data set
input = {'../submission/crop1.jpg', '../submission/wdc1.jpg','../submission/snapshot1.jpg'};
ref = {'../submission/crop2.jpg', '../submission/wdc2.jpg','../submission/snapshot2.jpg'};
k=1;
image.input = imread(input{k});
image.ref = imread(ref{k});

cc1=[0;0];
cc2=[0;0];

if k==1
    load('../submission/cc1.mat');
    load('../submission/cc2.mat');
end

% init points
points.input.raw = cc1';
points.ref.raw = cc2';
nPoints = size(points.input.raw,1);
% Choose, confirm and/or correct correspondences
while(nPoints<4) 
    [points.input.raw, points.ref.raw] = cpselect(image.input, image.ref, points.input.raw, points.ref.raw, 'Wait', true);
    nPoints = size(points.input.raw,1);
end

% N-by-2 to 2-by-N
points.input.raw = points.input.raw';
points.ref.raw = points.ref.raw';
points.input.homogeneous = [points.input.raw; ones(1,nPoints)];
points.ref.homogeneous = [points.ref.raw; ones(1,nPoints)];

%% 1-2
% Scale the points
% T1 = calculateNormalization(points.input.homogeneous);
% T2 = calculateNormalization(points.ref.homogeneous);
% points.input.scaled = T1*points.input.homogeneous;
% points.ref.scaled = T2*points.ref.homogeneous;
% points.input.scaled = points.input.scaled(1:2,:);
% points.ref.scaled = points.ref.scaled(1:2,:);
% Calculate the homography matrix
H = computeH(points.input.raw, points.ref.raw);
% H = inv(T2)*H;
points.warped = H*points.input.homogeneous;
points.warped = normalizeHomogeneous(points.warped);
%% 1-3
% Warp Image 
[warpedIm, mergeIm] = warpImage(image.input, image.ref, H);
%% Visualizations and Figures
% Show the images
figure(1); imshow(image.input); hold on;
plot(points.input.raw(1,:), points.input.raw(2,:), 'r+','MarkerSize',10);
figure(2); imshow(image.ref); hold on;
plot(points.ref.raw(1,:), points.ref.raw(2,:), 'r+','MarkerSize',10);
figure(3); imshow(warpedIm);  hold on;
plot(points.warped(1,:)+offsetX, points.warped(2,:)+offsetY, 'b+','MarkerSize',10);
figure(4); imshow(mergeIm); hold on;
plot(points.warped(1,:)+offsetX, points.warped(2,:)+offsetY, 'b+','MarkerSize',10);
title('Warped + Merged Images (Blue crosses represent the chosen points');
saveas(1, ['../submission/input-k-',num2str(k),'.png'],'png');
saveas(2, ['../submission/base-k-',num2str(k),'.png'],'png');
saveas(3, ['../submission/warpIm-k-',num2str(k),'.png'],'png');
saveas(4, ['../submission/mergeIm-k-',num2str(k),'.png'],'png');
% imwrite(outputImage.RGB, ['../submission/Q2-1/RGB', num2str(nCluster),'.jpg']);
% imwrite(hsv2rgb(double(outputImage.HSV)/255.0), ['../submission/Q2-1/HSV', num2str(nCluster),'.jpg']);
% profile viewer