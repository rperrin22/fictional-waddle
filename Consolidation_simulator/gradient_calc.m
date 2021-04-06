function [Mx,My] = gradient_calc(M,BCls,BCrs,BCbot,BCtop,dx,dy,Gx1,Gy1)

M_temp_x = [BCls M BCrs];
M_temp_y = [BCtop; M; BCbot];

%[Gx1,~,~] = first_derivative_op(M_temp_x,dx,dy);
%[~,Gy1,~] = first_derivative_op(M_temp_y,dx,dy);

Mx = Gx1*M_temp_x(:);
Mx = reshape(Mx,[size(M,1) size(M,2)+1]);

My = Gy1*M_temp_y(:);
My = reshape(My,[size(M,1)+1 size(M,2)]);


end