% Convert voltage ratio [V/V] to Capacitance Ratio [F/F]
function cap = volt2cap(injection_cap, volt_compensation, volt_counter, volt_gain)
    cap = - volt_gain * (volt_compensation / volt_counter) * injection_cap; % compensation voltage
end