clear;clc;
%% 可见光
dir = '../../陕文投书画数据/2016.3.2初次实验_可见光/';
fname = [dir, 'swt_2016_03_02_11_16_30/raw'];
datacube = read_raw(fname);
A = datacube(:,:,[176,115,62]);
imshow(A*10);

for k = 1:size(datacube,3)
    figure(1),imshow(datacube(:,:,k)*2);
    title([num2str(k)]);
    pause(0.05)
end


clear;clc;
%% 红外光
dir = '../../陕文投书画数据/2016.3.2初次实验_红外/';
fname = [dir, 'swt-bottom_10000_us_2016-03-02T124348_corr'];
datacube = read_hyspex(fname);
A = datacube(:,:,[21,118,58]);
imshow(A*1);




