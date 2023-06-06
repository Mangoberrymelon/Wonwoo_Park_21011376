function [el] = elevation(ENU, el_mask)
ENUsquare= ENU.^2;
ENUrange = sqrt(sum(ENUsquare,2));
el = rad2deg(asin(ENU(:,3)./ENUrange));

ind = find(el(1:1:end,1) < el_mask);
el(ind(1:1:end,1)) = nan;
end