function [sonicpwave,sonicdepth] =  rp_plotlog_mod3( wellfilename, logdescription, depthdescription,  kb, startdepth, rpscale, invflag, scalerface,wellident )
% function rp_plotlog_mod2( wellfilename, logdescription, depthdescription,  kb, startdepth, rpscale, invflag )
% 
% This function plots the well data in an LAS file
%
% Inputs:
%   wellfilename - the las file
%   logdescritioin - the log header text
%   depthdescription - the depth column header text
%   kb - the elevation of the ground or kb
%   startdepth - where the logging starts from
%   rpscale - scale the values
%   invflag - reverse the scale
%   scalerface - the coordinate of the well in whichever direction the
%                line is going
%   
%
% Created 15 May, 2017
% RP
%

wellfid = fopen(wellfilename,'r');

tempindex = 1;
tempflag =0;

% find the line before the data
while tempflag == 0    
    templine = fgetl(wellfid);
    if isempty(regexp(templine,'#\s*DEPT','match'))==0
        loglist = templine;
    end
    if strfind(templine,'~A') == 1        
        tempflag=1;
        fprintf('Header line found on line %.0f\n',tempindex);        
    end    
    tempindex = tempindex + 1;    
end
fclose all;

% find the depth and resistivity columns
names = textscan(loglist,'%s');
names{1,1}(1) = [];


if isempty(logdescription)~=1
index_depth = strfind(names{1,1}(:) , depthdescription);
index_depth_num = find(not(cellfun('isempty',index_depth)));

index_dtp = strfind(names{1,1}(:) , logdescription);
index_dtp_num = find(not(cellfun('isempty',index_dtp)));

welldata = importdata(wellfilename,' ',tempindex);

if isempty(index_depth_num)~=1 && isempty(index_dtp_num)~=1
    temp(:,1) = welldata.data(:,index_depth_num);
    temp(:,2) = welldata.data(:,index_dtp_num);    
    temp(temp(:,2)==-999.25,:)=[];    
    if invflag==1
        temp(:,2) = 1000000./temp(:,2);
    end
    
    temp(:,2) = rpscale * temp(:,2);
    
    sonicdepth = kb - startdepth - temp(:,1);
    sonicpwave = scalerface + temp(:,2);    
    
    plot(sonicpwave,sonicdepth,'g','linewidth',2)
    hh=text(scalerface,kb,sprintf('%s %s',wellident,logdescription),'backgroundcolor',[1 1 1]);
    set(hh, 'rotation', 90)
%     title(wellfilename)
end
end
end

