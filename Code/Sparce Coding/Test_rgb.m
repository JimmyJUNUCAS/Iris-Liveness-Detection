clear;clc;
addpath(genpath('Sparse coding'));
%% rgb
dir = '../../swt/2016.3.2_rgb/';
fname = [dir, 'swt_2016_03_02_11_12_46/raw'];
datacube = read_raw(fname);
Im = datacube(:,:,[176,115,62]);
% imshow(A*10);
load idx_rgb
im = datacube(:,:,idx);
clear datacube

[Height,Width,Len] = size(im);
X = reshape(im,[],Len)';
clear im

%% Sparse Coding
load rgb_20_1-3.mat R
Err = recError(X, R, 1e-3);
figure(1),plot(Err,'.')

Ab = reshape(Err,Height,Width);
figure(2),imshow(Ab>0.009);
imwrite(Ab>0.009,'result.jpg');

figure(3),imagesc(Ab)

A = 10*Im;
A(:,:,1) = A(:,:,1)+single(Ab>0.002);
figure(4),imshow(A);


