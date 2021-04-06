function [est_val,tempmat] = rp_weighted_estimate_rev1(well_xvec,well_yvec,well_data_vec,seis_xvec,seis_yvec,seis_data_vec,est_point,well_data_weights,seis_data_weights,rp_pow,max_points)
% [est_val] = rp_weighted_estimate(xvec,yvec,data_vec,est_point,data_weights,rp_pow)
%   Detailed explanation goes here

%% calculate distance vector
well_distance_vec = zeros(size(well_xvec));
for count = 1:length(well_xvec)
    well_distance_vec(count) = sqrt((well_xvec(count) - est_point(1))^2 + (well_yvec(count) - est_point(2))^2);
end

well_distance_vec(well_distance_vec==0) = 0.01;

well_tempmat = [well_distance_vec' well_data_vec' well_data_weights'];
well_tempmat = sortrows(well_tempmat);

well_tempmat = well_tempmat(1:max_points,:);

%% calculate distance vector
seis_distance_vec = zeros(size(seis_xvec));
for count = 1:length(seis_xvec)
    seis_distance_vec(count) = sqrt((seis_xvec(count) - est_point(1))^2 + (seis_yvec(count) - est_point(2))^2);
end

seis_distance_vec(seis_distance_vec==0) = 0.01;

seis_tempmat = [seis_distance_vec' seis_data_vec' seis_data_weights'];
seis_tempmat = sortrows(seis_tempmat);

seis_tempmat = seis_tempmat(1:max_points,:);


%% calculate the distance weights based on distance
tempmat = [well_tempmat; seis_tempmat];

tempmat(:,4) = 1./(tempmat(:,1).^rp_pow);

tempmat(:,5) = tempmat(:,3) .* tempmat(:,4);
tempmat(:,5) = tempmat(:,5)./sum(tempmat(:,5));

% % calculate the distance weights based on distance
% distance_weights = 1./(distance_vec.^rp_pow);
% 
% % calculate total weights
% total_weights = data_weights .* distance_weights;
% total_weights = total_weights./sum(total_weights);
% % total_weights(distance_vec>max_dist) = 0;
% 
% tempmat = [distance_vec' data_vec' total_weights'];
% tempmat = sortrows(tempmat);


% estimate the point
est_val = tempmat(:,2)'*tempmat(:,5);

end

