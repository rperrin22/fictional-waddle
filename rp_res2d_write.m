function rp_res2d_write(stn_filename)

%% this will be a function, so put the inputs in this section

%linenum = 10;
%stn_filename = sprintf('despike_line_edit%d.stn',linenum);
res2d_filename = sprintf('%s_res2d.dat',stn_filename(1:end-4));


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
% figure
% rp_pseudosection_plot_om(A_t,B_t,M_t,N_t,RHO)

%% write out res2d_file
% AA = A_t';
% BB = B_t';
% MM = M_t';
% NN = N_t';
% RR = RHO';
% writeRES2D('test18_out.dat', AA(:), BB(:), MM(:), NN(:), RHO(:), 'subtype','dpdp','res','appR');

STN = (M_t + N_t)./2;
N_SPC = repmat([0.5 1 1.5 2 2.5],size(RHO,1),1);
A_SPC = zeros(size(RHO)) + 5;

dataout(:,1) = STN(:);
dataout(:,2) = N_SPC(:);
dataout(:,3) = RHO(:);

dataout(dataout(:,3)==0,:)=[];
dataout(isnan(dataout(:,3))==1,:)=[];

fidout = fopen(res2d_filename,'w+');

% write out the info to the output file
fprintf(fidout,'Ohm-mapper %s\r\n',stn_filename); % print out file text
fprintf(fidout,'%d\r\n',int_spacing); % unit electrode spacing
fprintf(fidout,'3\r\n'); % dipole dipole
fprintf(fidout,'%d\r\n',size(dataout,1)); % number of readings
fprintf(fidout,'1\r\n'); % centre points
fprintf(fidout,'0\r\n'); % no IP data

% put the data inclear
for count = 1:size(dataout,1)
   fprintf(fidout,'%.2f %.2f %.2f %.3f\r\n',dataout(count,1),para.rec_dipole,dataout(count,2),dataout(count,3)); 
end

% no topography info
fprintf(fidout,'0\r\n');

% put the coordinates in
fprintf(fidout,'Global Coordinates present\r\n');
fprintf(fidout,'Number of coordinate points\r\n');
fprintf(fidout,'%d\r\n',length(int_chain_vector));
fprintf(fidout,'Local Longitude Latitude\r\n');
for count = 1:length(int_chain_vector)
    fprintf(fidout,'%.3f %.2f %.2f\r\n',int_chain_vector(count),int_X(count),int_Y(count));
end

% end the file
fprintf(fidout,'0\r\n');
fprintf(fidout,'0\r\n');
fprintf(fidout,'0\r\n');
fprintf(fidout,'0\r\n');

fclose all;


