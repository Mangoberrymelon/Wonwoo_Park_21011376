function [az] = azimuth(ENU)
az = rad2deg(acos(ENU(:,2)./sqrt(ENU(:,1).^2 + ENU(:,2).^2)));

ind_1 = find(ENU(1:end,1) < 0);
az(ind_1(1:end),1) = 360 - az(ind_1(1:end),1);
end