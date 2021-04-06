function [P_lithostatic] = get_lithostatic_pressure(ZZ,rho_r,porosity,waterbottomdepth)

% pressure due to water
temp_hydro_p = ZZ.*9.81.*1000.*porosity + (waterbottomdepth*9.81*1000);

% pressure due to rock
temp_rock_p = ZZ.*9.81.*rho_r.*(1-porosity);

P_lithostatic = temp_hydro_p + temp_rock_p;

end