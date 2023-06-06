function [DCM] = ECI2ECEF_DCM(time)
t_0 = [2000 01 01 12 00 00];
t_target = time;
t_diff = datetime(t_target) - datetime(t_0);
t_diff = seconds(t_diff);

theta_0 = juliandate(t_0);
theta_0 = sideralTime(theta_0);

rad = theta_0 + 7.292115856 * 10^-5 * t_diff;

DCM = [cos(rad), sin(rad) 0; -sin(rad), cos(rad), 0; 0, 0, 1];
end