% Limits DPOT position to between 0 & 256 (inclusive) 
function [ satpos ] = satpotpos( pos ) 
    DAQ_constants_include;
    
    upperpos = 2^DPOTbits;
    lowerpos = 0;
    
    satpos = uint16(min(upperpos, max(lowerpos, pos)));
end

