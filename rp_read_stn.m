function [datamat,coordmat,para] = rp_read_stn(stn_in_filename)

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
    

fseek(fidin,0,'bof');
coordmat=[];
linecounter=[];
tempstr=fgetl(fidin);

    while tempstr~=-1
        linecounter=length(coordmat)+1;
        
        if str2num(tempstr(1:2))==3 && isempty(strfind(tempstr,'"'))==1
            
            coordmat(linecounter,1) = str2double(tempstr(4:13));
            coordmat(linecounter,2) = str2double(tempstr(22:34));
            hours = str2double(tempstr(41:42));
            minutes = str2double(tempstr(44:45));
            seconds = str2double(tempstr(47:51));
            coordmat(linecounter,3) = hours*3600 + minutes*60 + seconds;
        end
        
        tempstr=fgetl(fidin);
        
    end
    
    coordmat(coordmat(:,1)==0,:)=[];
    
fseek(fidin,0,'bof');
linecounter=1;
flag = 0;

while flag==0
   
    tempstr=fgetl(fidin);
    if str2num(tempstr(1:2))==33
        
        para.operator_layback = str2double(tempstr(14:19));
        para.rec_dipole = str2double(tempstr(25:30));
        para.rope_length = str2double(tempstr(36:41));
        para.trans_dipole = str2double(tempstr(47:52));
        
        flag = 1;
    end
    
end

    
    fclose all;
    
datamat = sortrows(datamat,6);
coordmat = sortrows(coordmat,3);