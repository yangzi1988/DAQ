% Convert Percent to DPOT Position value
function pos = per2pos(per)
    DAQ_constants_include;
    
    pos = satpotpos(per/100*(2^DPOTbits));
end