function [az] = azimuth(ENU)
az = rad2deg(acos(ENU(:,2)./sqrt(ENU(:,1).^2 + ENU(:,2).^2)));
end