function velocityInPQW = solveVelocityInPerifocalFrame(semimajor_axis, eccentricity, true_anomaly)
mu = 3.986004418*10^5;
p = (semimajor_axis*(1-eccentricity^2));

PQ_vel_P = sqrt(mu/p) * (-sin(deg2rad(true_anomaly)));
PQ_vel_Q = sqrt(mu/p) * (eccentricity+cos(deg2rad(true_anomaly)));

velocityInPQW = [PQ_vel_P, PQ_vel_Q 0]';
end