% Convert a position value on the potentiometer to a Resistance [X]
function res = pos2res(pos)
    DAQ_constants_include;

    res = R_nominal_W + R_nominal_AB*(1-double(pos)/(2^DPOTbits));
end
