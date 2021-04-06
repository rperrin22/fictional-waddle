function [est_val] = rp_weighted_estimate(xvec,yvec,data_vec,est_point,data_weights,rp_pow,max_points)
% [est_val] = rp_weighted_estimate(xvec,yvec,data_vec,est_point,data_weights,rp_pow)
%   Detailed explanation goes here

% calculate distance vector
distance_vec = zeros(size(xvec));
for count = 1:length(xvec)
    distance_vec(count) = sqrt((xvec(count) - est_point(1))^2 + (yvec(count) - est_point(2))^2);
end

distance_vec(distance_vec==0) = 0.01;

tempmat = [distance_vec data_vec data_weights];
tempmat = sortrows(tempmat);

tempmat = tempmat(1:max_points,:);
% calculate the distance weights based on distance
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

