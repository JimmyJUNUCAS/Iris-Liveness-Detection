clear;clc;
addpath(genpath('Sparse coding'));
%% rgb
dir = '../../swt/2016.3.2_rgb/';
fname = [dir, 'swt_2016_03_02_11_20_47/raw'];
datacube = read_raw(fname);
im1 = datacube([390:2700],:,:);
clear datacube 

fname = [dir, 'swt_2016_03_02_11_16_30/raw'];
datacube = read_raw(fname);
im2 = datacube([390:2700],:,:);
clear datacube

X = [reshape(im1,[],size(im1,3))', reshape(im2,[],size(im2,3))'];
clear im1 im2

%% Sparse Coding
load idx_rgb
X = X(idx,randperm(size(X,2),1e5));
Dim = 20;
lambda = 1e-3;
Comb = sparse_combination(X,Dim,lambda);

for ii = 1 : length(Comb);
   R(ii).val = Comb(ii).val*inv(Comb(ii).val'*Comb(ii).val)*Comb(ii).val' - eye(size(Comb(ii).val,1)); % R matrix in Eq. (13).  
end

save rgb_20_1-3.mat R Comb Dim lambda

