% get, limit, and set a value in the gui to a certain range
function val = get_limit_n_set_val(val_handle, val_name, val_unit, val_unit_scale_factor, lowerlimit, upperlimit)
    val = max(lowerlimit, min(upperlimit, str2double(get(val_handle,'String'))*val_unit_scale_factor));
    val_scaled = val/val_unit_scale_factor;
    set(val_handle,'String',val_scaled)
    if not(isempty(val_name))
       fprintf([ val_name '=%d' val_unit '\n'],val_scaled); 
    end
end