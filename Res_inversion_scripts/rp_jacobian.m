function [J] = rp_jacobian(layertops,r1_initial,rho2_initial,rho1_initial,dr,dz,shot_sequence_file,param_flag,dmod)
%
% param_flag -  1 = r1 jacobian
%               2 = rho1 jacobian
%               3 = rho2 jacobian

load(shot_sequence_file);

J = zeros(length(rec),length(layertops));
switch param_flag
    case 1
        fprintf('calculate jacobian for r1\n') ;
        
        parfor icount = 1:length(layertops)
            
            testvec_dmod = r1_initial(:);
            testvec_dmod(icount) = testvec_dmod(icount) + dmod;
            
            [rhotemp] = rp_cy_fwd(layertops,r1_initial,rho1_initial,rho2_initial,dr,dz,shot_sequence_file);
            [rhotemp_dmod] = rp_cy_fwd(layertops,testvec_dmod,rho1_initial,rho2_initial,dr,dz,shot_sequence_file);
            
            J(:,icount) = rhotemp_dmod - rhotemp;
        end
        
    case 2
                fprintf('calculate jacobian for rho1\n') ;
        
        parfor icount = 1:length(layertops)
            
            testvec_dmod = rho1_initial(:);
            testvec_dmod(icount) = testvec_dmod(icount) + dmod;
            
            [rhotemp] = rp_cy_fwd(layertops,r1_initial,rho1_initial,rho2_initial,dr,dz,shot_sequence_file);
            [rhotemp_dmod] = rp_cy_fwd(layertops,r1_initial,testvec_dmod,rho2_initial,dr,dz,shot_sequence_file);
            
            J(:,icount) = rhotemp_dmod - rhotemp;
        end
        
    case 3
                       fprintf('calculate jacobian for rho2\n') ;
        
        parfor icount = 1:length(layertops)
            
            testvec_dmod = rho2_initial(:);
            testvec_dmod(icount) = testvec_dmod(icount) + dmod;
            
            [rhotemp] = rp_cy_fwd(layertops,r1_initial,rho1_initial,rho2_initial,dr,dz,shot_sequence_file);
            [rhotemp_dmod] = rp_cy_fwd(layertops,r1_initial,rho1_initial,testvec_dmod,dr,dz,shot_sequence_file);
            
            J(:,icount) = rhotemp_dmod - rhotemp;
        end 
        
end
