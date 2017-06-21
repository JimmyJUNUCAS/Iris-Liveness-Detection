function tmp = read_hyspex(fname)
% ������������raw�ļ���ȡ��ݵĺ���
% ���룺raw�ļ�·�����ļ���С����ʹ��read_hdr�����ã�
% samples; Image Columns
% lines: Image Rows
% bands: ���״�����
%

[samples, lines, bands, dataType, interleave, byteOrder] = ...
   read_hdr([fname,'.hdr']);

datacube = single(zeros(lines, samples, bands));
fid = fopen([fname,'.hyspex']);
for i = 1:lines    
        A = single(fread(fid, samples*bands*2));%���ֽڶ�ȡ�ļ�����Ϊ�߹��״洢�������ֽ�Uint16�����Գ���2
        data = A(1:2:end-1)+256*A(2:2:end);%A(1:2:end-1)������λ�ֽڣ�A(2:2:end)��ż��λ�ֽ�
        datacube(i,:,:) = reshape(data/4096, [samples, bands]);
end

fclose(fid);

tmp = datacube;
tmp(:,1:128,:) = datacube(:,257:end,:);
tmp(:,129:end,:) = datacube(:,1:256,:);

