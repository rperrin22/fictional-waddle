function rp_depthconvert(seismicfile,velocityfile)
%% input parameters
seisdatum = 500;
seisbottom = -300;
dt = 0.5; % in ms
dz = 1; % in m
depthvec = dz:dz:seisdatum-seisbottom;

%% add toolboxes (windows)
if strcmp(computer,'PCWIN64')==1
    addpath C:\Users\rperrin\Documents\MATLAB\toolboxes\SegyMAT
elseif strcmp(computer,'GLNXA64')==1
    addpath ~/Documents/MATLAB/Code_Library/SegyMAT:
end


%% load in data files
%seismicfile = 'MIC00-23_seismic.sgy';
%velocityfile = 'MIC00-23_velocity.sgy';

[seisData,seisTH,seisFH]=ReadSegy(seismicfile);
[velData,velTH,velFH]=ReadSegy(velocityfile);

%% create depth matrix
outmat=zeros(length(depthvec),size(seisData,2));

for count=1:size(seisData,2)
    
    tempvec=zeros(size(seisData,1),1); % initialize the depth vector
    for counter=2:size(seisData,1)
        
        tempvec(counter,1) = tempvec(counter-1,1) + (dt/2 * (velData(counter,count)/1000));
        tempvec(counter,2) = seisData(counter,count);
        
    end
    
    for counterbob=1:length(depthvec)
        outmat(counterbob,count) = interp1(tempvec(:,1),tempvec(:,2),depthvec(counterbob),'spline');
    end
end

%% write out depth segy
trsqline = ReadSegyTraceHeaderValue(seismicfile,'key','TraceSequenceLine');
trnum = ReadSegyTraceHeaderValue(seismicfile,'key','TraceNumber');
cdp = ReadSegyTraceHeaderValue(seismicfile,'key','cdp');
bobx = ReadSegyTraceHeaderValue(seismicfile,'key','SourceX');
boby = ReadSegyTraceHeaderValue(seismicfile,'key','SourceY');

WriteSegy(sprintf('%s_depth.sgy',seismicfile(1:end-4)),outmat,'revision',0,'dt',0.001);
WriteSegyTraceHeaderValue(sprintf('%s_depth.sgy',seismicfile(1:end-4)),trsqline,'key','TraceSequenceLine');
WriteSegyTraceHeaderValue(sprintf('%s_depth.sgy',seismicfile(1:end-4)),trnum,'key','TraceNumber');
WriteSegyTraceHeaderValue(sprintf('%s_depth.sgy',seismicfile(1:end-4)),cdp,'key','cdp');
WriteSegyTraceHeaderValue(sprintf('%s_depth.sgy',seismicfile(1:end-4)),bobx,'key','SourceX');
WriteSegyTraceHeaderValue(sprintf('%s_depth.sgy',seismicfile(1:end-4)),boby,'key','SourceY');

WriteSegyTraceHeaderValue(sprintf('%s_depth.sgy',seismicfile(1:end-4)),zeros(size(bobx)) + dz,'key','dt');
end
