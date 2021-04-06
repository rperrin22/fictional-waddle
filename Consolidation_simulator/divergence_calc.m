function [D] = divergence_calc(Gx,Gy,Dx1,Dy1)

dx = 1;
dy = 1;

% [Gx1,~,~] = first_derivative_op(Gx,dx,dy);
% [~,Gy1,~] = first_derivative_op(Gy,dx,dy);

tempx = Dx1*Gx(:);
tempy = Dy1*Gy(:);

tempx = reshape(tempx,[size(Gx,1) size(Gy,2)]);
tempy = reshape(tempy,[size(Gx,1) size(Gy,2)]);

D = tempx + tempy;


end