function [DCM] = ECI2ECEF_DCM(time)
t_target = time;
leapsecond = 18;

UTC = datetime(t_target) - seconds(leapsecond);
jd = juliandate(UTC);
GMST = deg2rad(siderealTime(jd));

DCM = [cos(GMST), sin(GMST) 0; -sin(GMST), cos(GMST), 0; 0, 0, 1];
end