%==========================================================================
% Source Code of 우주궤도역학 Term Project Module #1 3조
% 16011613 송정현, 19010413 곽태환 19011180 이재범
% 20003287 유택상, 20011336조민형
% Hohmann Transfer Orbit Design, Propulsion System Design
%==========================================================================

clear;clc;close all

%% Heliocentric Ecliptic Coordinate
Sun.XYZ=[0 0 0];

%% Determining Earth Orbit around Sun
Earth.a=1*cosd(7.155);                                                      % Apllying Inclination to flat plane
Earth.e=0.0167;
Earth.b=Earth.a*sqrt(1-Earth.e^2);
Earth.cen_rot=[Sun.XYZ(1)-sqrt(Earth.a.^2-Earth.b.^2) 0];                   % Determining Center of Orbit (Not Focus)
Earth.Arg=288.1;
nu=[0:0.001:2*pi]';

Earth.XeYe=[Earth.cen_rot(1)+Earth.a.*cos(nu) Earth.cen_rot(2)+Earth.b.*sin(nu)];

% Rotating Orbit with respect to Argument of Perigee
for i=1:size(Earth.XeYe(:,1),1)
    Earth.XeYe2(i,1:2)=[cosd(Earth.Arg) -sind(Earth.Arg);sind(Earth.Arg) cosd(Earth.Arg)]*Earth.XeYe(i,1:2)';
end

%% Determining Didymos Orbit around Sun
Didymos.a=1.6442*cosd(3.4709);                                              % Applying Inclination to flat plane
Didymos.e=0.38385;
Didymos.b=Didymos.a*sqrt(1-Didymos.e^2);
Didymos.cen_rot=[Sun.XYZ(1)-sqrt(Didymos.a.^2-Didymos.b.^2) 0];             % Determining Center of Orbit (Not Focus)
Didymos.Arg=319.32;
Didymos.XeYe=[Didymos.cen_rot(1)+Didymos.a.*cos(nu) Didymos.cen_rot(2)+Didymos.b.*sin(nu)];

% Rotating Orbit with respec to Argument of Perigee
for i=1:size(Earth.XeYe(:,1),1)
    Didymos.XeYe2(i,1:2)=[cosd(Didymos.Arg) -sind(Didymos.Arg);sind(Didymos.Arg) cosd(Didymos.Arg)]*Didymos.XeYe(i,1:2)';
end

%% Dermining Earth Sphere of Influence
r=10^6/149597870.7;
inf_x=r*cos(nu)+Earth.XeYe2(397,1);
inf_y=r*sin(nu)+Earth.XeYe2(397,2);


%% Used Parameters
AU=149597870.7;
r_LEO=6378.137+300;
r1=10^6+sqrt(Earth.XeYe2(397,1)^2+Earth.XeYe2(397,2)^2)*AU;                 % 1AU+Earth Sphere of Influence
r2=2.2753*AU;                                                               % Didymos Apogee distance 2.2753AU
mu_sun=1.3271544*10^11;
mu_earth=3.986012*10^5;

%% LEO to Earth Sphere of Influence (HTO 1)
v1=sqrt(mu_earth/r_LEO);                                                    % Speed at LEO orbit
E1=-mu_earth/(r_LEO+1000000);                                               % Specific mechanical energy of HTO 1
vp1=sqrt(2*(mu_earth/r_LEO+E1));                                            % Speed at perigee of HTO 1
va1=sqrt(2*(mu_earth/1000000+E1));                                          % Speed at apogee of HTO 1
del_v1=vp1-v1;                                                              % delta v1

%% Earth Sphere of Influence to hohmann transfer (HTO 2)
hm_v1=va1+29.78;                                                            % Speed at ESI with respect to SUN
E2=-mu_sun/(r1+r2);                                                         % Specific mechanical energy of HTO 2
hm_vp=sqrt(2*(mu_sun/r1+E2));                                               % Speed at perigee of HTO 2
hm_va=sqrt(2*(mu_sun/r2+E2));                                               % Speed at apogee of HTO 2
del_hm_v=hm_vp-hm_v1;                                                       % delta v1

%% Design HTO 1
Earth_HEC=[Earth.XeYe2(397,1) Earth.XeYe2(397,2)];                          % Select earth position
Earth_angle=-atand(Earth_HEC(2)/Earth_HEC(1));                              % Angle between x axis and sun-earth line
hm1_a=(r_LEO+10^6)/2/AU;                                                    % a of HTO 1 to AU unit
hm1_c=hm1_a-r_LEO/AU;                                                       % c of HTO 1 to AU unit
hm1_b=sqrt(hm1_a^2-hm1_c^2);                                                % b of HTO 1 to AU unit
hm1_cenrot=[Earth_HEC(1)+hm1_c*cosd(Earth_angle) Earth_HEC(2)-hm1_c*sind(Earth_angle)]; % Determining Center of Orbit (Not Focus)
nu1=[-pi:0.001:0]';
hohmann_1=[hm1_a*cos(nu1) hm1_b*sin(nu1)];                                  % Determine HTO 1 from -pi to 0

% Rotate with respect to Earth_angle
for i=1:size(hohmann_1(:,1),1)
    hohmann_1(i,1:2)=[cosd(360-Earth_angle) -sind(360-Earth_angle);sind(360-Earth_angle) cosd(360-Earth_angle)]*hohmann_1(i,1:2)';
end
hohmann_1=[hm1_cenrot(1)+hohmann_1(:,1) hm1_cenrot(2)+hohmann_1(:,2)];

%% Design HTO 2
[~,idx]=max(hohmann_1(:,1));
hm2_start=[hohmann_1(idx,1),hohmann_1(idx,2)];

hm2_a=(r1+r2)/2/AU;                                                         % a of HTO 2 to AU unit
hm2_c=hm2_a-r1/AU;                                                          % c of HTO 2 to AU unit
hm2_b=sqrt(hm2_a^2-hm2_c^2);                                                % b of HTO 2 to AU unit
hm2_cenrot=[Sun.XYZ(1)-hm2_c*cosd(Earth_angle) Sun.XYZ(2)+hm2_c*sind(Earth_angle)]; % Determining Center of Orbit (Not Focus)
nu2=[0:0.001:1.03*pi]';
hohmann_2=[hm2_a*cos(nu2) hm2_b*sin(nu2)];                                  % Determine HTO 2 from 0 to pi

% Rotate with respect to Earth_angle
for i=1:size(hohmann_2(:,1),1)
    hohmann_2(i,1:2)=[cosd(360-Earth_angle) -sind(360-Earth_angle);sind(360-Earth_angle) cosd(360-Earth_angle)]*hohmann_2(i,1:2)';
end
hohmann_2=[hm2_cenrot(1)+hohmann_2(:,1) hm2_cenrot(2)+hohmann_2(:,2)];


%% Plot
figure;
plot(Earth.XeYe2(:,1),Earth.XeYe2(:,2))
hold on; 
plot(Earth.XeYe2(397,1),Earth.XeYe2(397,2),'b.')
plot(Sun.XYZ(1),Sun.XYZ(2),'r.','MarkerSize',15)
plot(Didymos.XeYe2(:,1),Didymos.XeYe2(:,2),'Color',[0 0.4470 0.7410])
plot(Didymos.XeYe2(3022,1),Didymos.XeYe2(3022,2),'.','MarkerSize',10)
plot(inf_x,inf_y)
axis equal

plot(hohmann_1(:,1),hohmann_1(:,2),'Color',[0.4660 0.6740 0.1880])
plot(hohmann_2(:,1),hohmann_2(:,2),'Color',[0.4660 0.6740 0.1880])
xlabel('X [AU]')
ylabel('Y [AU]')

legend('Earth orbit','Earth','Sun','Didymos orbit','Didymos','Earth Gavity Influence','HTO 1','HTO 2')
title('Hohmann Transfer Orbit for Dart Project')



%% Propulsion System Design
dv1=1.83;                                                                   % 로켓 1단 속도 변화량
dv2=2.53;                                                                   % 로켓 2단 속도 변화량
dv3=7.7258-4.36;                                                            % 로켓 3단 속도 변화량
dv4=3.1638;                                                                 % 로켓 4단 속도 변화량
dv5=5.6356;                                                                 % Satellite delta v at HTO 2

mf5=(600*exp(dv5/3)-600)/(1.1-0.1*exp(dv5/3));                              % Fuel of Satellite
mo5=mf5+600;                                                                % Initial mass of Satellite

mf4=(mo5*exp(dv4/3)-mo5)/(1.1-0.1*exp(dv4/3));                              % Fuel of 4th Stage
mo4=mf4*1.1+mo5;                                                            % Initial mass of 4th Stage+Satellite

mf3=(mo4*exp(dv3/3)-mo4)/(1.1-0.1*exp(dv3/3));                              % Fuel of 3th Stage
mo3=mf3*1.1+mo4;                                                            % Initial mass of 3rd+4th+Satellite

mf2=(mo3*exp(dv2/3)-mo3)/(1.1-0.1*exp(dv2/3));                              % Fuel of 2nd Stage
mo2=mf2*1.1+mo3;                                                            % Initial mass of 2nd+3rd+4th+Satellite

mf1=(mo2*exp(dv1/3)-mo2)/(1.1-0.1*exp(dv1/3));                              % Fuel of 1st Stage
mo1=mf1*1.1+mo2;                                                            % Initial mass of Rocket


















