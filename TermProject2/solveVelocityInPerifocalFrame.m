function velocityInPQW = solveVelocityInPerifocalFrame(semimajor_axis, eccentricity, true_anomaly)
mu = 3.986004418*10^5;
p = (semimajor_axis/10^3*(1-eccentricity^2));

PQ_vel_P = sqrt(mu/p) .* (-sin(true_anomaly));
PQ_vel_Q = sqrt(mu/p) .* (eccentricity+cos(true_anomaly));

velocityInPQW = [PQ_vel_P, PQ_vel_Q];
velocityInPQW(:,3) = 0;
end