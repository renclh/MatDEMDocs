clear
%-----parameters-----
diameter=0.1;%define particle size
mNum=20;%define number of particle, 2~20
Vmax=10;%define the speed of particle, 5~20
isCement=0;%particles are cement when they are in compression,0 or 1

visRate=0;%define the viscosity
d=build();
d.setUIoutput();
d.name='BallInFrame';
%-----define struct data of model and boundary-----
V=diameter*(1:mNum)';
mR=diameter*(1+rand(mNum,1))/2;
boObj.X=0;boObj.Y=0;boObj.Z=diameter*-2;boObj.R=diameter/2;
d.aX=[V;boObj.X;boObj.X(end)];%add a virtual element
d.aY=[V;boObj.Y;boObj.Y(end)];
d.aZ=[V;boObj.Z;boObj.Z(end)];
d.aR=[mR;boObj.R;boObj.R(end)/4];
%-----define material-----
ballMat=material('ball');
ballMat.setMaterial(7e6,0.15,1.5e5,1e6,1,diameter,1500);
d.addMaterial(ballMat);
%-----initialize d-----
d.vRate=visRate;%rate of viscosity (0-1)
d.aNum=mNum+2;d.mNum=mNum;
d.aMatId=ones(size(d.aR))*ballMat.Id;
d.g=0;%gravity acceleration
d.setBuild();
d.setModel();
d.mo.isShear=0;
frame.minX=0;frame.maxX=diameter*mNum;
frame.minY=0;frame.maxY=diameter*mNum;
frame.minZ=0;frame.maxZ=diameter*mNum;
d.mo.frame=frame;%define the shown frame
%define the rigid frame
d.mo.afterBalance='f=obj.frame;fs.limitFrame(obj.dem,1:obj.mNum,f.minX,f.maxX,f.minY,f.maxY,f.minZ,f.maxZ);';
if isCement==1
    d.mo.afterBalance=[d.mo.afterBalance 'obj.reCement();'];
end
%-----numerical simulation-----
d.mo.mVX=Vmax*rand(mNum,1);d.mo.mVY=Vmax*rand(mNum,1);d.mo.mVZ=Vmax*rand(mNum,1);
totalCircle=100;
d.mo.dT=d.mo.dT*4;
d.figureNumber=d.show('aR');
for i=1:totalCircle
    d.balance(2,5);
    d.show('-aR');
end
d.show();