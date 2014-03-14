
% limit a value in the gui to a certain range
function val = limit_val(val_unlimited, lowerlimit, upperlimit)
    val = max(lowerlimit, min(upperlimit, val_unlimited));
end
