function [C,xc_vec,zc_vec] = rp_model_cy_build(layertops,r1_initial,rho1_initial,rho2_initial,dr,dz,shot_sequence_file)


load(shot_sequence_file);

% indexes for insertion into proper r1 vector
[Para] = get_2_5Dpara_cly(src,dr,dz,rec);
[xc_vec,zc_vec] = cell_centre_cyl(Para.dr,Para.dz);
xe_vec = (xc_vec(1)-dr(1)/2)+[0; cumsum(dr(:))];

r1_tempvec = ones(length(zc_vec),1)*r1_initial(1,end);
rho1_tempvec = ones(length(zc_vec),1)*rho1_initial(1,end);
rho2_tempvec = ones(length(zc_vec),1)*rho2_initial(1,end);

for icount = 1:length(layertops)
    r1_tempvec(dsearchn(zc_vec,layertops(icount)):end) = r1_initial(icount,end);
    rho1_tempvec(dsearchn(zc_vec,layertops(icount)):end) = rho1_initial(icount,end);
    rho2_tempvec(dsearchn(zc_vec,layertops(icount)):end) = rho2_initial(icount,end);
end

[C] = rp_model_populate(r1_tempvec,rho1_tempvec,rho2_tempvec,xe_vec,xc_vec,zc_vec,dr);


