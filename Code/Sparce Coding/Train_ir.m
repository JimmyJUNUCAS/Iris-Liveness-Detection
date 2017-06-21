clear;clc;
%% ir
dir = '../../swt/2016.3.2_ir/';
fname = [dir, 'swt-mid_10000_us_2016-03-02T123856_corr'];
datacube = read_hyspex(fname);
% A = datacube(:,:,[21,118,58]);
% imshow(A);


im = datacube([300:1310],:,:);
clear datacube

% fname = [dir, 'swt_2016_03_02_11_16_30/raw'];
% datacube = read_raw(fname);
% im2 = datacube([390:2700],:,:);
% clear datacube

% X = [reshape(im1,[],size(im1,3))', reshape(im2,[],size(im2,3))'];
% clear im1 im2

X = reshape(im,[],size(im,3))';
clear im
% idx = find(sum(X,2)>1e5);

%% Sparse Coding
load idx_ir
X = X(idx,randperm(size(X,2),1e5));
Dim = 20;lambda = 1;
Comb = sparse_combination(X,Dim,lambda);

for ii = 1 : length(Comb);
   R(ii).val = Comb(ii).val*inv(Comb(ii).val'*Comb(ii).val)*Comb(ii).val' - eye(size(Comb(ii).val,1)); % R matrix in Eq. (13).  
end

save ir_20_1.mat R Comb Dim lambda

