function rotation_matrix = PQW2ECI(arg_prg, inc_angle, RAAN)
A = [cos(arg_prg), sin(arg_prg), 0; -sin(arg_prg), cos(arg_prg), 0; 0, 0, 1];
B = [cos(inc_angle), 0, -sin(inc_angle); 0, 1, 0; sin(inc_angle), 0, cos(inc_angle)];
C = [1, 0, 0; 0, cos(RAAN), sin(RAAN); 0, -sin(RAAN), cos(RAAN)];

rotation_matrix = (A * B * C)';
end