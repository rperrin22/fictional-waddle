function [T]=rp_eikonal_rev4(SR,cellsize,shotpos,version)
% function [T]=rp_eikonal_rev4(S,cellsize,shotpos,version)
%
% SR is the velocity model 
% T is the travel-time matrix  
% shotpos is the location of the shot  (ex. [shoty shotx])
% version 1 is zhao's original method, 2 is the Saveraging method

xsize=size(SR);
clear TR
clear Told
clear diff
TR=zeros(xsize)+50000000;
% set the shot point position to 0
TR(shotpos(1),shotpos(2))=0;


% set the first sweep direction
runum=1;

% I have the max number of iterations set at 10 here, because they all seem
% to converge at about 6 sweeps.
for iteration=1:20
    
    % change the order that we're incrementing the indexes in order to
    % change the sweep direction
    switch runum
        case 1
            iorder=1:1:xsize(1);
            jorder=1:1:xsize(1);
        case 2
            iorder=xsize(1):-1:1;
            jorder=1:1:xsize(1);
        case 3
            iorder=1:1:xsize(1);
            jorder=xsize(1):-1:1;
        case 4
            iorder=xsize(1):-1:1;
            jorder=xsize(1):-1:1;
    end
    
    % there are only 4 sweep directions, after 4, return to direction 1
    if runum<4
        runum=runum+1;
    else
        runum=1;
    end
    
    % now run through the update calculation
    for i=iorder
        
        for j=jorder
            
               % these two if statements calculate uxmin and uymin, 
               % depending on if the cell being calculated is an inside
               % cell or a boundary cell.
               % It also calculates Saverage for use in the averaging
               % algorithm
            if i==1
                uxmin=min([TR(i,j) TR(i+1,j)]);
                Saverage(1)=mean([SR(i,j)*cellsize SR(i+1,j)*cellsize]);
            elseif i==max(iorder)
                uxmin=min([TR(i-1,j) TR(i,j)]);
                Saverage(1)=mean([SR(i-1,j)*cellsize SR(i,j)*cellsize]);
            else
                uxmin=min([TR(i-1,j) TR(i+1,j)]);
                Saverage(1)=mean([SR(i-1,j)*cellsize SR(i+1,j)*cellsize]);
            end
            
            if j==1
                uymin=min([TR(i,j) TR(i,j+1)]);
                Saverage(2)=mean([SR(i,j)*cellsize SR(i,j+1)*cellsize]);
            elseif j==max(jorder)
                uymin=min([TR(i,j-1) TR(i,j)]);
                Saverage(2)=mean([SR(i,j-1)*cellsize SR(i,j)*cellsize]);
            else
                uymin=min([TR(i,j-1) TR(i,j+1)]);
                Saverage(2)=mean([SR(i,j-1)*cellsize SR(i,j+1)*cellsize]);
            end
            
            % This section updates the traveltime in each cell
            % equations 2.4 from Zhao (2005)
            if abs(uxmin-uymin)>=SR(i,j)*cellsize
                [tempmin,tempindex]=min([uxmin uymin]);
                
                if version==2
                    TR(i,j)=min([tempmin+Saverage(tempindex) TR(i,j)]);
                elseif version==1
                    TR(i,j)=min([tempmin+(SR(i,j)*cellsize) TR(i,j)]);
                end
                
            elseif abs(uxmin-uymin)<SR(i,j)*cellsize
                TR(i,j)=min([(uxmin+uymin+sqrt(2*((SR(i,j)^2*cellsize^2))-(uxmin-uymin)^2))/2 TR(i,j)]);
            end
            
        end
        
    end
    
    %This section checks to see if the solution has converged
    % if it has converged, break the loop
    if iteration>1
        
        diff=norm((Told-TR),2);
        
        % break the loop if it has converged
        % it seems to get to 0 change after about 6 sweeps, so I just set
        % the diff to 0
        if diff==0
            break
        end
        
    end
    
    Told=TR;
    
end



T=TR;
