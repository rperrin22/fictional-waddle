function rp_pseudosection_plot_om(A,B,M,N,R)

%% make pseudo-section for single a-spacing geometry
n_levels = unique(M - A);
n_counter = 1;

for count = 1:length(A(:))
    
    pl_yvec(count) = find(n_levels==(M(count) - A(count)));
    pl_xvec(count) = mean([mean([A(count) B(count)]) mean([M(count) N(count)])]);


end

rho_real = R(:);

%% plot pseudo-section
%figure('units','normalized','outerposition',[0 0 0.5 1])

X_int_vec = min(pl_xvec):0.1:max(pl_xvec); % make interpolation vector for X
Y_int_vec = min(pl_yvec):0.1:max(pl_yvec); % make interpolation vector for Z
[XX,YY] = meshgrid(X_int_vec,Y_int_vec);

appres_section_int = griddata(pl_xvec,pl_yvec,rho_real,XX,YY);

imagesc(X_int_vec,Y_int_vec,(appres_section_int));
hold on
contour(X_int_vec,Y_int_vec,(appres_section_int),'k');
grid on
colormap jet
h=colorbar;
% set(gca,'clim',[1 200])
xlabel('Chainage (m)')
ylabel('n-level')
axis ij
ylabel(h,'Apparent Resistivity (\Omega m)')