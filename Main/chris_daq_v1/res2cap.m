% Convert Capacitance & Voltage Ratios [F/F] to Gain/Resistance
function cap = res2cap(injection_cap, volt_counter, volt_compensation, res_1, res_2)
    cap = -res_2/res_1*(volt_compensation / volt_counter)*injection_cap;
end