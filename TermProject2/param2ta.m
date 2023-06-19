function [True_anomaly_1] = param2ta(semi_major_axis, eccentricity, Mean_anomaly_0, k, t_0, t_1)
a = semi_major_axis/10^3; e = eccentricity;
duration = t_1 - t_0;
duration.Format = 's';
t_diff = seconds(duration);
mu = 3.986004418*10^5;

Mean_anomaly_1(1) = Mean_anomaly_0;

for ind = 1:1:t_diff
    Mean_anomaly_1(ind+1) = ind * sqrt(mu/a^3) - 2*pi*k + Mean_anomaly_0;
    
    fun_get_E = @(E) -Mean_anomaly_1(ind) + E - e*sin(E);
    key_E_1 = Mean_anomaly_1(ind);
    E_1(ind) = fzero(fun_get_E, key_E_1);
end

E_1 = E_1';
True_anomaly_1 = atan2(sqrt(1-e^2)*sin(E_1(:,1)) ./ (1-e*cos(E_1(:,1))), (cos(E_1(:,1))-e) ./ (1-e*cos(E_1(:,1))));
end