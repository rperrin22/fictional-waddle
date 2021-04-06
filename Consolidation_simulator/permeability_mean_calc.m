function [kx,ky] = permeability_mean_calc(k)

kx = zeros([size(k,1) size(k,2)+1]);
ky = zeros([size(k,1)+1 size(k,2)]);

for count = 1:size(k,1)+1
    if count==1
        ky(count,:) = k(1,:);
    elseif count==size(k,1)+1
        ky(count,:) = k(end,:);
    else
        ky(count,:) = mean(k(count-1:count,:),1);
    end
end

for count = 1:size(k,2)+1
    if count==1
        kx(:,count) = k(:,1);
    elseif count==size(k,2)+1
        kx(:,count) = k(:,end);
    else
        kx(:,count) = mean(k(:,count-1:count),2);
    end
end

end