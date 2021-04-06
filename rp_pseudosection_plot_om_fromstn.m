function rp_pseudosection_plot_om_fromstn(stn_filename)

%% read in the necessary info from the stn file
[datamat,coordmat,para] = rp_read_stn(stn_filename);

% interpolated spacings
int_spacing = para.rec_dipole/4;

% the last column from rp_read_stn is the time stamp
num_channels = size(datamat,2) - 1;

%% make a chainage vector
% make chainage start point
coordmat(1,4) = 0.1;

F = @(x1,x2,y1,y2,prevchain) prevchain + sqrt(abs(x1-x2)^2 + (abs(y1-y2)^2));

for count = 2:length(coordmat)
   
    coordmat(count,4) = F(coordmat(count-1,1),...
                           coordmat(count,1),...
                           coordmat(count-1,2),...
                           coordmat(count,2),...
                           coordmat(count-1,4));  
                       if coordmat(count,4)==coordmat(count-1,4)
                           coordmat(count,4) = coordmat(count,4) + 0.0001;
                       end
end


%% interpolate some stuff
% interpolate chainage vector onto regular vector
int_chain_vector = 1:int_spacing:max(coordmat(:,4));
int_time_vector = interp1(coordmat(:,4),coordmat(:,3),int_chain_vector);
int_X = interp1(coordmat(:,4),coordmat(:,1),int_chain_vector);
int_Y = interp1(coordmat(:,4),coordmat(:,2),int_chain_vector);

int_datamat = zeros(length(int_time_vector'),num_channels);

[~,datamatindex,~] = unique(datamat(:,num_channels+1));
datamat = datamat(datamatindex,:);

for count = 1:num_channels
   int_datamat(:,count) = interp1(datamat(:,num_channels+1),datamat(:,count),int_time_vector); 
end


%% create A, B, M, N matricies
% these matricies are the laybacks in chainage from the gps location

% layback vectors
%N_vec = (para.operator_layback + ((num_channels -1)* para.rec_dipole/2)):-(para.rec_dipole/2):para.operator_layback;
N_vec = (para.operator_layback + ((num_channels -1)* para.rec_dipole/2)):-(para.rec_dipole/2):para.operator_layback;
M_vec = N_vec + para.rec_dipole;
B_vec = max(M_vec) + para.rope_length;
A_vec = B_vec + para.trans_dipole;

% populate 
A = repmat(A_vec,size(int_datamat,1),num_channels);
B = repmat(B_vec,size(int_datamat,1),num_channels);
M = repmat(M_vec,size(int_datamat,1),1);
N = repmat(N_vec,size(int_datamat,1),1);


%% make chainage matrix (locations where the GPS is)
C = repmat(int_chain_vector',1,num_channels);

A_t = C - A;
B_t = C - B;
M_t = C - M;
N_t = C - N;

%% calculate apparent resistivities

K = zeros(size(int_datamat));

for count = 1:length(K(:))
    K(count) = rp_om_geomfactor_calc(para.rec_dipole,A(count) - M(count));
end

% the 20 is as directed from Odlum
RHO = (int_datamat/20).*K;

%%
rp_pseudosection_plot_om(A_t,B_t,M_t,N_t,RHO)