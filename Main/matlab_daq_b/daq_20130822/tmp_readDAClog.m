

readfid = fopen('logfiles\20130926\test8_DAC_20130926_180024.log','r');
rawvalues1 = fread(readfid,'uint16');
fclose(readfid);



readfid = fopen('logfiles\20130926\test10_20130926_181119.log','r');
rawvalues2 = fread(readfid,'uint16');
fclose(readfid);

