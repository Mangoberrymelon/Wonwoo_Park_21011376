clear all
close all

load("nav.mat");
prompt = "What do you want? ";
select = input(prompt);

if select == "GPS"
    semi_major_axis = nav.GPS.a;
    eccentricity = nav.GPS.e;
    inclination = nav.GPS.i;
    AOP = nav.GPS.omega;
    RAAN = nav.GPS.OMEGA;
    t_0 = datetime(nav.GPS.toc);
    Mean_anomaly_0 = nav.GPS.M0;
elseif select == "QZSS"
    semi_major_axis = nav.QZSS.a;
    eccentricity = nav.QZSS.e;
    inclination = nav.QZSS.i;
    AOP = nav.QZSS.omega;
    RAAN = nav.QZSS.OMEGA;
    t_0 = datetime(nav.QZSS.toc);
    Mean_anomaly_0 = nav.QZSS.M0;
else
    semi_major_axis = nav.BDS.a;
    eccentricity = nav.BDS.e;
    inclination = nav.BDS.i;
    AOP = nav.BDS.omega;
    RAAN = nav.GPS.OMEGA;
    t_0 = datetime(nav.BDS.toc);
    Mean_anomaly_0 = nav.BDS.M0;
end

k = 0;

period = 2 * a2period(semi_major_axis);
period_s = [1:1:period]';

[True_anomaly_1] = param2ta(semi_major_axis, eccentricity, Mean_anomaly_0, k, t_0, (t_0+seconds(period)));


rangeInPQW = solveRangeInPerifocalFrame(semi_major_axis, eccentricity, True_anomaly_1);
velocityInPQW = solveVelocityInPerifocalFrame(semi_major_axis, eccentricity, True_anomaly_1);

rangeInECI = (PQW2ECI(AOP, inclination, RAAN) * rangeInPQW(:, 1:3)')';
velocityInECI = (PQW2ECI(AOP, inclination, RAAN) * velocityInPQW(:, 1:3)')';

dcmECI2ECEF = dcmeci2ecef('IAU-2000/2006', (t_0+seconds(period_s)));

rangeInECI = reshape(rangeInECI',3,1,length(rangeInECI));
velocityInECI = reshape(velocityInECI',3,1,length(velocityInECI));

rangeInECEF = pagemtimes(dcmECI2ECEF, rangeInECI);
velocityInECEF = pagemtimes(dcmECI2ECEF, velocityInECI);

rangeInECEF = reshape(rangeInECEF,3,length(rangeInECI));
velocityInECEF = reshape(velocityInECEF,3,length(velocityInECEF));

rangeInLLA = ecef2lla(rangeInECEF(:,:,1:end)');
velocityInLLA = ecef2lla(velocityInECEF(:,:,1:end)');

start_t = nav.GPS.toc;
RadarLLA = [30, 120, 80];
start_t = datetime(start_t);
final_t = start_t + seconds(period-1);

timestep = 1;

geoscatter(rangeInLLA(1:timestep:end,1), rangeInLLA(1:timestep:end,2), [], linspace(1,10,length(rangeInLLA(1:timestep:end,1))));

ENU = (lla2enu(rangeInLLA(1:timestep:end,:), RadarLLA, 'ellipsoid'))/10^3;
ENUsquare= ENU.^2;
ENUrange = sqrt(sum(ENUsquare,2));
El = rad2deg(asin(ENU(:,3)./ENUrange));
Az = rad2deg(acos(ENU(:,2)./sqrt(ENU(:,1).^2 + ENU(:,2).^2)));

ind_1 = find(ENU(1:end,1) < 0);
Az(ind_1(1:end),1) = 360 - Az(ind_1(1:end),1);
ind_2 = find(El(1:end,1) < 0);
El(El(1:end,1) < 0) = nan;

skyplot_data = horzcat(Az, El);

skyplot(skyplot_data(:,1), skyplot_data(:,2));

%{
plot = figure;
plot = geoscatter(rangeInLLA(:,1), rangeInLLA(:,2), 'b');
hold on;
plot = geoscatter(rangeInLLA(1,1), rangeInLLA(1,2), 'r', "diamond");
%}