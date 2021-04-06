function [X_int_vec,Z_int_vec,appres_section_int] = rp_pseudosection_plot_cy(src,rec,rho_real,n_spacings)

%% make pseudo-section for single a-spacing geometry
n_levels = n_spacings;
n_counter = 1;

for count = 1:length(rec)
    
    pl_xvec(count) = n_counter;
    pl_zvec(count) = mean([mean([src(count,2) src(count,4)]) mean([rec(count,2) rec(count,4)])]);

    if n_counter < n_levels
        n_counter = n_counter + 1;
    else
        n_counter = 1;
    end
    
end

%% plot pseudo-section
%figure('units','normalized','outerposition',[0 0 0.5 1])

X_int_vec = min(pl_xvec):0.1:max(pl_xvec); % make interpolation vector for X
Z_int_vec = min(pl_zvec):0.1:max(pl_zvec); % make interpolation vector for Z
[XX,YY] = meshgrid(X_int_vec,Z_int_vec);

appres_section_int = griddata(pl_xvec,pl_zvec,rho_real,XX,YY);

imagesc(X_int_vec,Z_int_vec,(appres_section_int));
hold on
contour(X_int_vec,Z_int_vec,(appres_section_int),'k');
grid on
colormap jet
%h=colorbar;
%set(gca,'clim',[1 7])
xlabel('n-level')
ylabel('Depth (m)')
axis ij
%ylabel(h,'Log Apparent Resistivity (\Omega m)')