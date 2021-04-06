function [Gx1,Gy1,Gxy1] = first_derivative_op(mat_size,dx,dy)
% create second derivative operators


% Initialize the Gx, Gz, Dx, and Dz operators
Gx1 = spalloc(mat_size(2),mat_size(1),ceil(2*sqrt(mat_size(2)^2+mat_size(1)^2)));
Gy1 = spalloc(mat_size(2),mat_size(1),ceil(2*sqrt(mat_size(2)^2+mat_size(1)^2)));

% create the Gz operator
totalcounty=1;
totalcountx=1;

invdz=1/dy;
invdx=1/dx;

for count=1:mat_size(2)
    
    for counter=1:mat_size(1)-1
        
        diaglocx=(count-1)*mat_size(1)+counter;
        diaglocy=totalcounty;
        
        Gy1(diaglocy,diaglocx)=-invdz;
        Gy1(diaglocy,diaglocx+1)=invdz;
        
        
        totalcounty=totalcounty+1;
    end
    
end

% create the Gx operator
totalcounty=1;
totalcountx=1;
for count=1:mat_size(2)-1
    
    for counter=1:mat_size(1)
        
        diaglocx=(count-1)*mat_size(1)+counter;
        diaglocy=totalcountx;
        
        Gx1(diaglocy,diaglocx)=-invdx;
        Gx1(diaglocy,diaglocx+mat_size(1))=invdx;
              
        totalcountx=totalcountx+1;
    end
    
end

Gxy1 = [Gx1; Gy1];

end