function [param_out] = rp_cy_invert_tik(appres_real,layertops,r1_initial,rho1_initial,rho2_initial,dr,dz,shot_sequence_file,param_flag,dmod,reg_op)


[appres_temp,~,~,~] = rp_cy_fwd(layertops,r1_initial,rho1_initial,rho2_initial,dr,dz,shot_sequence_file);

[J] = rp_jacobian(layertops,r1_initial,rho2_initial,rho1_initial,dr,dz,shot_sequence_file,param_flag,dmod);
fprintf('Jacobian calculation complete\n')

[M1a,~] = rp_deriv_op1(r1_initial,2);

switch param_flag
    case 1
        %perturb = ((J'*J + alp*(Wm_weight'*Wm_weight))\(J'*(appres_real - appres_temp) + alp*(Wm_weight'*Wm_weight)*(r1_initial-Mref)));       
        %perturb = ((J'*J)\(J'*(appres_real - appres_temp) + alp*(Wm_weight'*Wm_weight)*(r1_initial-Mref)));
        perturb = ((J'*J + reg_op*(M1a'*M1a))\(J'*(appres_real - appres_temp)));
    case 2
        %perturb = ((J'*J + alp*(Wm_weight'*Wm_weight))\(J'*(appres_real - appres_temp) + alp*(Wm_weight'*Wm_weight)*(rho1_initial-Mref)));        
        perturb = ((J'*J + reg_op*(M1a'*M1a))\(J'*(appres_real - appres_temp)));
    case 3
        %perturb = ((J'*J + alp*(Wm_weight'*Wm_weight))\(J'*(appres_real - appres_temp) + alp*(Wm_weight'*Wm_weight)*(rho2_initial-Mref)));        
        perturb = ((J'*J + reg_op*(M1a'*M1a))\(J'*(appres_real - appres_temp)));
end

errornew = norm(appres_real - appres_temp);
errorold = errornew*2;
errordiff = errorold - errornew;
itercount = 1;

while errordiff > 0 && itercount < 900

switch param_flag
    case 1
        hold_r1 = r1_initial;
        r1_initial = r1_initial + (0.0001*perturb);
    case 2
        hold_rho1 = rho1_initial;
        rho1_initial = rho1_initial + (0.1*perturb);
    case 3
        hold_rho2 = rho2_initial;
        rho2_initial = rho2_initial + (0.1*perturb);
end

[appres_temp,~,~,~] = rp_cy_fwd(layertops,r1_initial,rho1_initial,rho2_initial,dr,dz,shot_sequence_file);

errorold = errornew;
errornew = norm(appres_real - appres_temp);
errordiff = errorold - errornew;

fprintf('iteration %d\n',itercount);
itercount = itercount + 1;

end

switch param_flag
    case 1
        param_out = hold_r1;
    case 2
        param_out = hold_rho1;
    case 3
        param_out = hold_rho2;
end

function [M1a,M1b] = rp_deriv_op1(data,deriv_flag)
%% set up 2-D derivative operator

% data is the input matrix

% allocate space for the sparse operator
M1a = spalloc(size(data,1)-1,size(data,1)-1,(2*(size(data,1)-1)));

M1b = spalloc(size(data,2)-1,size(data,2)-1,(2*(size(data,2)-1)));

totalcounty=1;
totalcountx=1;


switch deriv_flag
    case 1
        % first derivative operator
        
        for count=1:size(data,2)
            
            for counter=1:size(data,1)-1
                
                diaglocx=(count-1)*size(data,1)+counter;
                diaglocy=totalcounty;
                
                M1a(diaglocy,diaglocx)=-1;
                M1a(diaglocy,diaglocx+1)=1;
                
                
                totalcounty=totalcounty+1;
            end
            
        end
        
    case 2
        for count=1:size(data,2)
            
            for counter=1:size(data,1)-2
                
                diaglocx=(count-1)*size(data,1)+counter;
                diaglocy=totalcounty;
                
                M1a(diaglocy,diaglocx)=1;
                M1a(diaglocy,diaglocx+1)=-2;
                M1a(diaglocy,diaglocx+2)=1;
                
                
                totalcounty=totalcounty+1;
            end
            
        end
end


%%
totalcounty=1;
totalcountx=1;

switch deriv_flag
    case 1
        for count=1:size(data,2)-1
            
            for counter=1:size(data,1)
                
                diaglocx=(count-1)*size(data,1)+counter;
                diaglocy=totalcountx;
                
                M1b(diaglocy,diaglocx)=-1;
                M1b(diaglocy,diaglocx+size(data,1))=1;
                
                totalcountx=totalcountx+1;
            end
            
        end
        
    case 2
        for count=1:size(data,2)-2
            
            for counter=1:size(data,1)
                
                diaglocx=(count-1)*size(data,1)+counter;
                diaglocy=totalcountx;
                
                M1b(diaglocy,diaglocx)=1;
                M1b(diaglocy,diaglocx+size(data,1))=-2;
                M1b(diaglocy,diaglocx+(2*size(data,1)))=1;
                
                totalcountx=totalcountx+1;
            end
            
        end
end

