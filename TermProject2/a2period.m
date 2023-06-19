function period = a2period(semi_major_axis)
semi_major_axis = semi_major_axis/10^3;
mu = 3.986004418*10^5;
period = 2*pi * sqrt(semi_major_axis^3/mu);
end

