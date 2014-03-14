% Convert Resistance [X] to a position value on the potentiometer
function pos = res2pos(res)
    DAQ_constants_include;
    
    pos = satpotpos(2^DPOTbits*(1 - ((res - (R_nominal_W))/(R_nominal_AB))));
end