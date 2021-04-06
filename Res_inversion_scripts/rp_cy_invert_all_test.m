function [r1_initial,rho1_initial,rho2_initial,errornew] = rp_cy_invert_all_test(appres_real,layertops,r1_initial,rho1_initial,rho2_initial,dr,dz,shot_sequence_file,tol)

[appres_temp,~,~,~] = rp_cy_fwd(layertops,r1_initial,rho1_initial,rho2_initial,dr,dz,shot_sequence_file);
errornew = norm((abs(appres_real - appres_temp)/appres_real));
errorold = errornew*2;
errordiff = abs(errorold - errornew);

itercount = 1;

rho1_runflag = 1;

while errordiff>tol
    
    param_flag = 1;
    dmod = 0.01*mean(r1_initial(:,end));
    [r1_initial(:,itercount+1)] = rp_cy_invert(appres_real,layertops,r1_initial(:,end),rho1_initial(:,end),rho2_initial(:,end),dr,dz,shot_sequence_file,param_flag,dmod);
    
    if rho1_runflag ==1
        param_flag = 2;
        dmod = 0.01*mean(rho1_initial(:,end));
        [rho1_initial(:,itercount+1)] = rp_cy_invert(appres_real,layertops,r1_initial(:,end),rho1_initial(:,end),rho2_initial(:,end),dr,dz,shot_sequence_file,param_flag,dmod);        
    end
    
    param_flag = 3;
    dmod = 0.01*mean(rho2_initial(:,end));
    [rho2_initial(:,itercount+1)] = rp_cy_invert(appres_real,layertops,r1_initial(:,end),rho1_initial(:,end),rho2_initial(:,end),dr,dz,shot_sequence_file,param_flag,dmod);
    
    
    [appres_temp,~,~,~] = rp_cy_fwd(layertops,r1_initial(:,end),rho1_initial(:,end),rho2_initial(:,end),dr,dz,shot_sequence_file);
    
    errornew(itercount + 1) = norm((abs(appres_real - appres_temp)/appres_real));
    errordiff = abs(errornew(itercount) - errornew(itercount + 1));
    
    fprintf('iteration %d\n',itercount);
    itercount = itercount + 1;
    
end

% r1_out = r1_initial(:,end);
% rho1_out = rho1_initial(:,end);
% rho2_out = rho2_initial(:,end);