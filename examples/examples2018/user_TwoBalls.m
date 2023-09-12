%This
%-----parameters-----
diameter=0.1;visRate=0.1;%Figure 1.3-2
%diameter=20;visRate=0;%Figure 5.4-1
r=diameter/2;%ball radius
d=build();
d.name='TwoBalls';
%-----define struct data of model and boundary-----
moObj.X=[0;0];moObj.Y=[0;0];moObj.Z=diameter*[1;3];
moObj.R=r*[1;1];
boObj.X=[0;0];boObj.Y=[0;0];boObj.Z=diameter*[0;4];
boObj.R=r*[1;1];
%-----define material-----
ballMat=material('ball');
ballMat.setMaterial(7e6,0.15,1.5e5,1e6,1,diameter,1500);
d.addMaterial(ballMat);
%-----initialize d-----
d.aX=[moObj.X;boObj.X;boObj.X(end)];%add a virtual element
d.aY=[moObj.Y;boObj.Y;boObj.Y(end)];
d.aZ=[moObj.Z;boObj.Z;boObj.Z(end)];
d.aR=[moObj.R;boObj.R;boObj.R(end)/4];
d.vRate=visRate;%rate of viscosity (0-1)
d.aNum=length(d.aR);d.mNum=length(moObj.R);
d.aMatId=ones(size(d.aR))*ballMat.Id;
d.g=-9.8;%gravity acceleration
d.setBuild();
%-----define boundary groups-----
d.GROUP.lefB=[];d.GROUP.rigB=[];
d.GROUP.froB=[];d.GROUP.bacB=[];
d.GROUP.botB=3;d.GROUP.topB=4;
%-----initialize d.mo-----
d.setModel();
d.mo.isHeat=1;
%-----numerical simulation-----
d.balance(1,800);
d.showB=2;
d.show();