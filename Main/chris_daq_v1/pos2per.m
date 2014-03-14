% Convert DPOT Position value to Percent
function per = pos2per(pos)
    DAQ_constants_include;

    per = double(pos)*100*2^(-DPOTbits);
end