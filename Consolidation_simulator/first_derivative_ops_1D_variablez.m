function [Gz] = first_derivative_ops_1D_variablez(zvec)
% [Gz] = first_derivative_op_1D_variablez(zvec)
% this function creates gradient and divergence operators for the 1-D case 
% where the domain has variable grid spacing.
%
% the variable zvec will be the size of each cell, and the
% resulting matrix will be used to calculate the gradient on cell edges.
% There is no value calculated for the outside edges of the model, so to
% incorporate Dirichlet boundary conditions, pad zvec by one cell on each
% end, and pad the corresponding vector with boundary conditions on either
% side.


%% create the gradient operator (Gz)

% initialize the operator matrix
Gz = spalloc(length(zvec) - 1,length(zvec),(length(zvec) - 1)*2);

% populate with loop.  (read into Eldad's book to make this more elegant)
for count=1:length(zvec)-1
        
        invdz = 0.5*zvec(count+1) + 0.5*zvec(count);
        
        Gz(count,count)=-invdz;
        Gz(count,count+1)=invdz;
        
    
end


end