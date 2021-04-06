function [Gx2,Gy2,Gxy2] = second_derivative_op(M,dx,dy)
% create second derivative operators

% Initialize the Gx, Gz, Dx, and Dz operators
Gx2 = spalloc(size(M,2),size(M,1),ceil(3*sqrt(size(M,2)^2+size(M,1)^2)));
Gy2 = spalloc(size(M,2),size(M,1),ceil(3*sqrt(size(M,2)^2+size(M,1)^2)));

% create the Gz operator
totalcounty=1;
totalcountx=1;

invdz=1/dy;
invdx=1/dx;

for count=1:size(M,2)
    
    for counter=1:size(M,1)-2
        
        diaglocx=(count-1)*size(M,1)+counter;
        diaglocy=totalcounty;
        
        Gy2(diaglocy,diaglocx)=-invdz;
        Gy2(diaglocy,diaglocx+1)=2*invdz;
        Gy2(diaglocy,diaglocx+2)=-invdz;
        
        
        totalcounty=totalcounty+1;
    end
    
end

% create the Gx operator
totalcounty=1;
totalcountx=1;
for count=1:size(M,2)-2
    
    for counter=1:size(M,1)
        
        diaglocx=(count-1)*size(M,1)+counter;
        diaglocy=totalcountx;
        
        Gx2(diaglocy,diaglocx)=-invdx;
        Gx2(diaglocy,diaglocx+size(M,1))=2*invdx;
        Gx2(diaglocy,diaglocx+(2*size(M,1)))=-invdx;
              
        totalcountx=totalcountx+1;
    end
    
end

Gxy2 = [Gx2; Gy2];

end