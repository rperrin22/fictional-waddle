function [r1_initial,rho1_initial,rho2_initial,errornew] = rp_cy_invert_all_tik(appres_real,layertops,r1_initial,rho1_initial,rho2_initial,dr,dz,shot_sequence_file,tol,reg_op)

[appres_temp,~,~,~] = rp_cy_fwd(layertops,r1_initial,rho1_initial,rho2_initial,dr,dz,shot_sequence_file);
errornew = norm((abs(appres_real - appres_temp)/appres_real));
errorold = errornew*2;
errordiff = abs(errorold - errornew);

itercount = 1;

rho1_runflag = 1;

while errordiff>tol
    
    param_flag = 1;
    dmod = 0.001;
    [r1_initial(:,itercount+1)] = rp_cy_invert_tik(appres_real,layertops,r1_initial(:,end),rho1_initial(:,end),rho2_initial(:,end),dr,dz,shot_sequence_file,param_flag,dmod,reg_op);
    
    if rho1_runflag ==1
        param_flag = 2;
        dmod = 1;
        [rho1_initial(:,itercount+1)] = rp_cy_invert_tik(appres_real,layertops,r1_initial(:,end),rho1_initial(:,end),rho2_initial(:,end),dr,dz,shot_sequence_file,param_flag,dmod,reg_op);        
    end
    fprintf('iteration %d',itercount);
    param_flag = 3;
    dmod = 1;
    [rho2_initial(:,itercount+1)] = rp_cy_invert_tik(appres_real,layertops,r1_initial(:,end),rho1_initial(:,end),rho2_initial(:,end),dr,dz,shot_sequence_file,param_flag,dmod,reg_op);
    
    
    [appres_temp,~,~,~] = rp_cy_fwd(layertops,r1_initial(:,end),rho1_initial(:,end),rho2_initial(:,end),dr,dz,shot_sequence_file);
    
    errornew(itercount + 1) = norm((abs(appres_real - appres_temp)/appres_real));
    errordiff = abs(errornew(itercount) - errornew(itercount + 1));
    
    fprintf('iteration %d\n',itercount);
    itercount = itercount + 1;
    
end

% r1_out = r1_initial(:,end);
% rho1_out = rho1_initial(:,end);
% rho2_out = rho2_initial(:,end);