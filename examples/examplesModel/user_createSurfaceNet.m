clear;
%The function signature of mfs.create3Dsurface is: obj=mfs.create3Dsurface(x,y,z,ballR,Rrate,varargin),
%while the meanings of the input parameters are:
%x,y,z: digital elelvation model (DEM) scattered data.
%ballR: the uniform radius of elements.
%Rrate: the ratio of the distance between two elements to their diameter. use 0.5~0.8, when it is 0.7, no gap between elements
%varargin: 1 parameter, the uniform width of the margins to be clipped;
%          2 parameters, the widths of the margins to be clipped, left and right, top and bottom, respectively;
%          4 parameters, the widths of the margins to be clipped, left, right, top, bottom, respectively.
%Tiancheng Le

valleyData=load('slope/valley.txt');
valleyX=valleyData(:,1);
valleyY=valleyData(:,2);
valleyZ=valleyData(:,3);
[valleyX,valleyY]=mfs.rotateIJ(valleyX,valleyY,29);
ballR=500;Rrate=0.6;
valleyObj=mfs.createSurfaceNet(valleyX,valleyY,7*valleyZ,ballR,Rrate,6000,8000,10000,12000); %4 additional input parameters.
ballR=500;Rrate=3;
valleyObj2=mfs.createSurfaceNet(valleyX,valleyY,7*valleyZ,ballR,Rrate,6000,8000,10000,12000); %4 additional input parameters.

valleyObj.Value=valleyObj.Z;
valleyObj2.Value=valleyObj2.Z;

%Display the 4 objects created with the function createSurfaceNet.
figure(1);
subplot(1,2,1);
fs.showObj(valleyObj);
subplot(1,2,2);
fs.showObj(valleyObj2);

return
lpsData=load('slope/lps1.txt');
lpsX=lpsData(:,1);
lpsY=lpsData(:,2);
lpsZ=lpsData(:,3);
[lpsX,lpsY]=mfs.rotateIJ(lpsX,lpsY,-60);
ballR=7;Rrate=0.7;
lpsObj.Value=lpsObj.Z;
lpsObj=mfs.createSurfaceNet(lpsX,lpsY,lpsZ,ballR,Rrate,50,100); %2 additional input parameters.
fs.showObj(lpsObj);