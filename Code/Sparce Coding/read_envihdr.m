function info = read_envihdr(hdrfile)
% READ_ENVIHDR read and return ENVI image file header information.
%   INFO = READ_ENVIHDR('HDR_FILE') reads the ASCII ENVI-generated image
%   header file and returns all the information in a structure of
%   parameters.
% 
%   Example:
%   >> info = read_envihdr('my_envi_image.hdr')
%   info = 
%          description: [1x101 char]
%              samples: 658
%                lines: 749
%                bands: 3
%        header_offset: 0
%            file_type: 'ENVI Standard'
%            data_type: 4
%           interleave: 'bsq'
%          sensor_type: 'Unknown'
%           byte_order: 0
%             map_info: [1x1 struct]
%      projection_info: [1x102 char]
%     wavelength_units: 'Unknown'
%           pixel_size: [1x1 struct]
%           band_names: [1x154 char]
%
%   NOTE: This function is used by ENVIREAD to import data.
% Ian M. Howat, Applied Physics Lab, University of Washington
% ihowat@apl.washington.edu
% Version 1: 19-Jul-2007 00:50:57
fid = fopen(hdrfile);
while fid;
    line = fgetl(fid);
    if line == -1
        break
    else
        eqsn = findstr(line,'=');
        if ~isempty(eqsn)
            param = strtrim(line(1:eqsn-1));
            param(findstr(param,' ')) = '_';
            value = strtrim(line(eqsn+1:end));
            if isempty(str2num(value))
                if ~isempty(findstr(value,'{')) && isempty(findstr(value,'}'))
                    while isempty(findstr(value,'}'))
                        line = fgetl(fid);
                        value = [value,strtrim(line)];
                    end
                end
                eval(['info.',param,' = ''',value,''';'])
            else
                eval(['info.',param,' = ',value,';'])
            end
        end
    end
end
fclose all;

if isfield(info,'map_info')
    line = info.map_info;
    line(line == '{' | line == '}') = [];
    line = strtrim(split(line,','));
    info.map_info = [];
    info.map_info.projection = line{1};
    info.map_info.image_coords = [str2num(line{2}),str2num(line{3})];
    info.map_info.mapx = str2num(line{4});
    info.map_info.mapy = str2num(line{5});
    info.map_info.dx  = str2num(line{6});
    info.map_info.dy  = str2num(line{7});
    if length(line) == 9
        info.map_info.datum  = line{8};
        info.map_info.units  = line{9}(7:end);
    elseif length(line) == 11
        info.map_info.zone  = str2num(line{8});
        info.map_info.hemi  = line{9};
        info.map_info.datum  = line{10};
        info.map_info.units  = line{11}(7:end);
    end
end

if isfield(info,'pixel_size')
    line = info.pixel_size;
    line(line == '{' | line == '}') = [];
    line = strtrim(split(line,','));
    info.pixel_size = [];
    info.pixel_size.x = str2num(line{1});
    info.pixel_size.y = str2num(line{2});
    info.pixel_size.units = line{3}(7:end);
end

function A = split(s,d)
%This function by Gerald Dalley (dalleyg@mit.edu), 2004
A = {};
while (length(s) > 0)
    [t,s] = strtok(s,d);
    A = {A{:}, t};
end