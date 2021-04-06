function rp_electrode_locs_build_3d(min_electrode,max_electrode,electrode_int,outputfile,a_spacing,n_spacings)
%% build shot sequence
geom.electrode_locs = min_electrode:electrode_int:max_electrode;

% n_spacings = 15;

src = [];
rec = [];

% a_spacing = [1];

for counterbutt = 1:length(a_spacing) % a-spacings
    for count=1:length(geom.electrode_locs) - ((n_spacings + 2) *( a_spacing(counterbutt))) % count is the first current electrode
        for counter = 2*a_spacing(counterbutt):(n_spacings+1)*a_spacing(counterbutt)
            
            src = [src;...
                0 0 geom.electrode_locs(count) 0 0 geom.electrode_locs(count+a_spacing(counterbutt))];
            
            rec = [rec;...
                0 0 geom.electrode_locs(count + counter) 0 0 geom.electrode_locs(count + counter + a_spacing(counterbutt))];
            
        end
    end
end

save(outputfile, 'src','rec');

fprintf('shot sequence built, saved to %s\n',outputfile)