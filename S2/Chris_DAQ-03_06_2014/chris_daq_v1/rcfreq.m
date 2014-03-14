% Calculates the Time Constant of an single pole RC network
function freq = rcfreq(R,C)
    freq = 1/(2*pi*R*C);
end