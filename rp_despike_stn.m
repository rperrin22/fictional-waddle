function rp_despike_stn(stn_in_filename,stn_out_filename,window_length,var)
% [stn_out_filename] = rp_despike_stn(stn_in_filename)
%
% This function despikes a ohmmapper stn file
%
% Inputs:
%   stn_in_filename - the input stn filename
%   stn_out_filename - the output stn file
%   window_length - the window length
%   var - the amount of variation required to correct a value (in std
%         deviations)
%   num_iters - the number of despike iterations to run
%
% Created 30 May, 2017
% RP
%   edited 30 May, 2017 - added interative depsike
%
%% assertion check
% check to make sure the input exists
assert( exist(stn_in_filename,'file')==2,...
    'rp_despike_stn: input filename does not exist, please check filename');

% check to see if the output file already exists
assert( exist(stn_out_filename,'file')==0,...
    'rp_despike_stn: output filename is already present, Choose another name');


%% get dataset
    fidin=fopen(stn_in_filename);   
    datamat = [];
    linecounter=1;
    temp=fgetl(fidin);
    
    while temp~=-1
        
        if str2num(temp(1:2))==30 && isempty(strfind(temp,'"'))==1
            
            datamat(linecounter,1)=str2double(temp(7:15));
            datamat(linecounter,2)=str2double(temp(20:28));
            datamat(linecounter,3)=str2double(temp(33:41));
            datamat(linecounter,4)=str2double(temp(46:54));
            datamat(linecounter,5)=str2double(temp(59:67));
            hours = str2double(temp(71:72));
            minutes = str2double(temp(74:75));
            seconds = str2double(temp(77:81));
            datamat(linecounter,6) = hours*3600 + minutes*60 + seconds;
            
            linecounter=linecounter+1;
            
        end       
        temp=fgetl(fidin);        
    end
    
fclose all;

%% despike the dataset

for count = 1:5
    num_values_corrected = 999;
    iter_count = 1;
    
    while num_values_corrected > 0 && iter_count < 20
        [datamat(:,count),num_values_corrected] = rp_despike_func(datamat(:,count),window_length,var);
        iter_count = iter_count + 1;
    end
    
end

datamat = sortrows(datamat,6);
[~,datamatindex,~] = unique(datamat(:,6));
datamat = datamat(datamatindex,:);

%% write the dataset out
fidout = fopen(stn_out_filename,'w+');
fidin = fopen(stn_in_filename);

temp=fgetl(fidin);

while temp~=-1
    
    if str2num(temp(1:2))==30 && isempty(strfind(temp,'"'))==1
        datamat_temp(1)=str2double(temp(7:15));
        datamat_temp(2)=str2double(temp(20:28));
        datamat_temp(3)=str2double(temp(33:41));
        datamat_temp(4)=str2double(temp(46:54));
        datamat_temp(5)=str2double(temp(59:67));
        hours = str2double(temp(71:72));
        minutes = str2double(temp(74:75));
        seconds = str2double(temp(77:81));
        datamat_temp(6) = hours*3600 + minutes*60 + seconds;
        
        datamat_temp(7) = interp1(datamat(:,6),datamat(:,1),datamat_temp(6));
        datamat_temp(8) = interp1(datamat(:,6),datamat(:,2),datamat_temp(6));
        datamat_temp(9) = interp1(datamat(:,6),datamat(:,3),datamat_temp(6));
        datamat_temp(10) = interp1(datamat(:,6),datamat(:,4),datamat_temp(6));
        datamat_temp(11) = interp1(datamat(:,6),datamat(:,5),datamat_temp(6));
        
        part1 = temp(1:6);
        part2 = rp_padstring_front(sprintf('%2.3f',datamat_temp(7)),9);
        part3 = temp(16:19);
        part4 = rp_padstring_front(sprintf('%2.3f',datamat_temp(8)),9);
        part5 = temp(29:32);
        part6 = rp_padstring_front(sprintf('%2.3f',datamat_temp(9)),9);
        part7 = temp(42:45);
        part8 = rp_padstring_front(sprintf('%2.3f',datamat_temp(10)),9);
        part9 = temp(55:58);
        part10 = rp_padstring_front(sprintf('%2.3f',datamat_temp(11)),9);
        part11 = temp(68:end);
        
        combout = [part1 part2 part3 part4 part5 part6 part7 part8 part9 part10 part11];
        
        fprintf(fidout,'%s\r\n',combout);
        
    else
        fprintf(fidout,'%s\r\n',temp);
    end
    temp=fgetl(fidin);
end

fclose all;


