function[samples, lines, bands, dataType, interleave, byteOrder] = ...
   read_hdr( headerFilename)

   headerFID = fopen( headerFilename );
   if headerFID == -1
      error( 'Error opening header file, bad file ID' );
   end

   while 1

      tline = fgetl( headerFID );

      if ~ischar( tline )
         break;
      end

      [parameter, value] = strtok( tline, '=' );

      if strncmpi( parameter, 'samples', length( 'samples' ) )
         [delimeter, value] = strtok( value );
         samples = str2num( value );
      end

      if strncmpi( parameter, 'lines', length( 'lines' ) )
         [delimeter, value] = strtok( value );
         lines = str2num( value );
      end

      if strncmpi( parameter, 'bands', length( 'bands' ) )
         [delimeter, value] = strtok( value );
         bands = str2num( value );
      end

      if strncmpi( parameter, 'data type', length( 'data type' ) )
         [delimeter, value] = strtok( value );
         dataType = str2num( value );

         switch dataType
            case 1
               dataType = 'uint8';
            case 2
               dataType = 'int16';
            case 3
               dataType = 'int32';
            case 4
               dataType = 'float32';
            case 5
               dataType = 'float64';
            case 12
               dataType = 'uint16';
            case 13
               dataType = 'uint32';
            case 14
               dataType = 'int64';
            case 15
               dataType = 'uint64';
            otherwise
               error( 'Unknown data type' );
         end

      end

      if strncmpi( parameter, 'interleave', length( 'interleave' ) )
         [delimeter, value] = strtok( value );
         interleave = strtrim( char( value ) );
      end

      if strncmpi( parameter, 'byte order', length( 'byte order' ) )
         [delimeter, value] = strtok( value );
         byteOrder = str2num( value );
      end

   end

   fclose( headerFID );