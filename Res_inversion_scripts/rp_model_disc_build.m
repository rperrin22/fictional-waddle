function rp_model_disc_build(dr,dz,outputfile)

xe_vec = zeros(length(dr)-1,1)*dr(1)/2;
ze_vec = zeros(length(dz)-1,1)*dz(1)/2;
xc_vec = zeros(length(dr),1);
zc_vec = zeros(length(dz),1);

for count=2:length(dr)
    xc_vec(count,1) = xc_vec(count-1) + (0.5*dr(count-1)) + (0.5*dr(count));
    xe_vec(count,1) = xc_vec(count-1) + (0.5*dr(count-1));
end

for count=2:length(dz)
    zc_vec(count,1) = zc_vec(count-1) + (0.5*dz(count-1)) + (0.5*dz(count));
    ze_vec(count,1) = zc_vec(count-1) + (0.5*dz(count-1));
end

save(outputfile,'xe_vec','ze_vec', 'xc_vec','zc_vec','dr','dz');
fprintf('model built, saved to %s\n',outputfile)