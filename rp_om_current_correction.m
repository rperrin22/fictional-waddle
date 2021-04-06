function rp_om_current_correction(stn_filename,current_filename)
%% function inputs
% current_filename = 'day2_current.stn';
% stn_filename = 'day2_raw.stn';

%% function body

% creat output filename
out_filename = sprintf('%s_edited.stn',stn_filename(1:end-4));

% create current interpolant
fidin=fopen(current_filename);
fseek(fidin,0,'bof');
tempstr=fgetl(fidin);
cur_data=[];
linecounter=[];
while tempstr~=-1
    linecounter=length(cur_data)+1;    
    if str2num(tempstr(1:2))==0        
        cur_data(linecounter,1) = str2double(tempstr(8));
        cur_data(linecounter,2) = str2double(tempstr(9:13));
        hours = str2double(tempstr(26:27));
        minutes = str2double(tempstr(29:30));
        seconds = str2double(tempstr(32:36));
        cur_data(linecounter,3) = hours*3600 + minutes*60 + seconds;
    end    
    tempstr=fgetl(fidin);    
end
fclose all;
cur_data(isnan(cur_data(:,1))==1,1) = 0;
cur_data(cur_data(:,3)==0,:)=[];

mode_value = mode(cur_data(:,1));
% correction values
convmat(:,1) = (7:-1:0)';
convmat(:,2) = [16;8;4;2;1;0.5;0.25;0.125];



% read input file and create output file
fidout = fopen(out_filename,'w+');
fidin = fopen(stn_filename);

temp=fgetl(fidin);

while temp~=-1
    
    if str2num(temp(1:2))==30 && isempty(strfind(temp,'"'))==1
        datamat(1)=str2double(temp(7:15));
        datamat(2)=str2double(temp(20:28));
        datamat(3)=str2double(temp(33:41));
        datamat(4)=str2double(temp(46:54));
        datamat(5)=str2double(temp(59:67));
        hours = str2double(temp(71:72));
        minutes = str2double(temp(74:75));
        seconds = str2double(temp(77:81));
        datamat(6) = hours*3600 + minutes*60 + seconds;
        
        datamat(7) = interp1(cur_data(:,3),cur_data(:,1),datamat(6));
        
        cor_val = 2^(datamat(7) - mode_value);
        %mode_val = convmat(convmat(:,1)==mode_value,2);
        
        part1 = temp(1:6);
        part2 = rp_padstring_front(sprintf('%3.3f',(datamat(1)/cor_val)),9);
        part3 = temp(16:19);
        part4 = rp_padstring_front(sprintf('%3.3f',(datamat(2)/cor_val)),9);
        part5 = temp(29:32);
        part6 = rp_padstring_front(sprintf('%3.3f',(datamat(3)/cor_val)),9);
        part7 = temp(42:45);
        part8 = rp_padstring_front(sprintf('%3.3f',(datamat(4)/cor_val)),9);
        part9 = temp(55:58);
        part10 = rp_padstring_front(sprintf('%3.3f',(datamat(5)/cor_val)),9);
        part11 = temp(68:end);
        
            combout = [part1 part2 part3 part4 part5 part6 part7 part8 part9 part10 part11];
            
            fprintf(fidout,'%s\r\n',combout);
            
        else
            fprintf(fidout,'%s\r\n',temp);
        end       
        temp=fgetl(fidin);        
    end
    
    fclose all;
    
    