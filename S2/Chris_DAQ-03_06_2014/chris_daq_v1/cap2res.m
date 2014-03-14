% Convert Capacitance & Voltage Ratios [F/F] to Gain/Resistance
function res = cap2res(injection_cap, estimated_cap, volt_counter, volt_compensation, res_1)
    res = - (volt_counter / volt_compensation)*(estimated_cap / injection_cap)*res_1; % feedback resitance for cslow
end