function [datamat] = rp_om_attachcoords_todata(datamat,coordmat)

coordmat  = sortrows(coordmat,3);
datamat = sortrows(datamat,6);

datamat(:,7) = interp1(coordmat(:,3),coordmat(:,1),datamat(:,6),'spline',0);
datamat(:,8) = interp1(coordmat(:,3),coordmat(:,2),datamat(:,6),'spline',0);

datamat(datamat(:,7)==0,:)=[];