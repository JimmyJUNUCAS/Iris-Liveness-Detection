function datacube = read_raw(fname)

[samples, lines, bands, dataType, interleave, byteOrder] = ...
   read_hdr([fname,'.hdr']);

datacube = single(zeros(lines, samples, bands));
fid = fopen(fname);
for i = 1:lines
    
        A = single(fread(fid, samples*bands*2));
        data = A(1:2:end-1)+256*A(2:2:end);
        datacube(i,:,:) = reshape(data/4096, [samples, bands]);
end

fclose(fid);



