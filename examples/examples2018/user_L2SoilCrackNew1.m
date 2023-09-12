%the example shows how to build a model without the Obj_Box
%build the geometrical model
clear;
%------------------initializing parameters
fs.randSeed(1);%build random model
diameter=0.001;
xyNumber=20;
zNumber=6;
modelW=xyNumber*diameter;%width, length and thickness of model
modelL=xyNumber*diameter;
modelT=zNumber*diameter;
elementR=diameter/2;%ball radius
%------------------end initializing parameters

%------------------build initial model
d=build();%make a build object
d.setUIoutput();
d.g=-9.8;%gravitational acceleration
d.name='SoilCrack';%the name of the simulation
clay=material('clay');%define a new material
clay.setMaterial(3e5,0.18,1e3,1e3,0.7,diameter,1800);%set the E,v,Tu,Cu,Mui, it is not trained
d.addMaterial(clay);%add the material to the model
Mo=fs.setBlock(modelW,modelL,modelT,elementR);
Bo=fs.setBoundary(Mo.X,Mo.Y,Mo.Z,Mo.R,'model',[1.2,1.2,1.2,1.2,0.5,0]);%set top- and bottom boundaries
Mo.X=Bo.mX;Mo.Y=Bo.mY;Mo.Z=Bo.mZ;Mo.R=Bo.mR;
d.bIndex=Bo.bIndex;
%initialize the coordinates of boundary balls and radius
d.aX=[Mo.X;Bo.X];d.aY=[Mo.Y;Bo.Y];d.aZ=[Mo.Z;Bo.Z];
d.aR=[Mo.R;Bo.R];
d.vRate=Mo.vRate;%optimized viscisity rate
d.aNum=length(d.aR);d.mNum=length(Mo.R);
d.aMatId=ones(size(d.aR))*clay.Id;

d.setBuild();%set the data in build object, i.e. d
d.setModel();%set the data in model object, i.e. d.mo
d.mo.isHeat=1;%calculation of heat
d.mo.isCrack=1;%record crack information
%------------------end build initial model

d.mo.setGPU('auto');
d.balance('Standard',0.5);

%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model
d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('SoilCrack1Finish');
save(['TempModel/' d.name '1.mat'],'d');
d.calculateData();
d.show();