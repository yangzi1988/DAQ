% Convert Capacitance Ratio [F/F] to a voltage ratio [V/V]
function volt = cap2volt(injection_cap, estimated_cap, volt_counter, volt_gain)
    volt = - (volt_counter ./ volt_gain) .* (estimated_cap ./ injection_cap); % compensation voltage
end