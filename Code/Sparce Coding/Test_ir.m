clear;clc;
%% ir
dir = '../../swt/2016.3.2_ir/';
fname = [dir, 'swt_5000_us_2016-03-02T122357_corr'];
datacube = read_hyspex(fname);
Im = datacube(:,:,[21,118,58]);
figure(10),imshow(Im,[]);
imwrite(Im,'ir_T122357.jpg');

load idx_ir
im = datacube(:,:,idx);
clear datacube

[Height,Width,Len] = size(im);
X = reshape(im,[],Len)';
clear im


%% Sparse Coding
load ir_20_1.mat R
Err = recError(X, R, 1);
figure(1),plot(Err,'.')

Ab = reshape(Err,Height,Width);
figure(2),imshow(Ab>2e6);
% imwrite(Ab>2e6,'ir_result.jpg');

figure(3),imagesc(Ab)

A = 1*Im;
A(:,:,1) = A(:,:,1)+single(Ab>2e6);
figure(4),imshow(A);


