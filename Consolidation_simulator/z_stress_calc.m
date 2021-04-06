function [s_xx] = z_stress_calc(zvec,density)

for count = 2:length(zvec)
    Fvec(count-1) = zvec(count-1) * density;
end

Fvec = Fvec';

%% solve for stress
% create operator matrix
for count = 1:length(zvec)-1
    
   OP(count,count:count+1) = [-1 1];
    
end

% boundary condition
OP(end+1,1) = 1;
Fvec(end+1) = 0;

% solve
s_xx = OP\Fvec;
