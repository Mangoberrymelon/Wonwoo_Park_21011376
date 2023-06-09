function rangeInPQW = solveRangeInPerifocalFrame(semimajor_axis, eccentricity, true_anomaly)
r = (semimajor_axis*(1-eccentricity^2)) ./ (1+eccentricity*cos(true_anomaly));

PQ_P = r .* cos(true_anomaly);
PQ_Q = r .* sin(true_anomaly);

rangeInPQW = [PQ_P, PQ_Q];
rangeInPQW(:,3) = 0;
end

