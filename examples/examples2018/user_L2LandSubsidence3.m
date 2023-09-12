clear;
load('TempModel/BoxLandSubsidence2.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');

%-------------initializing parameters
mGZ0=d.mo.mGZ;%record the initial gravity of element
mZ=d.mo.aZ(1:d.mNum);
mR=d.mo.aR(1:d.mNum);
mVolumn=4/3*pi*mR.*mR.*mR;%volumn of elements
waterDensity=1e3;
waterTable1=55;%initial water table
waterTable2=25;
mBuoyancy=-waterDensity*mVolumn*d.mo.g;%buoyancy of element
%-------------end initializing parameters

%-------------initializing model
waterFilter=mZ<waterTable1;%filter of element under the water table
d.mo.mGZ=mGZ0+mBuoyancy.*waterFilter;
d.balanceBondedModel0();%bond the model and balance it without friction
d.mo.bFilter(:)=true;%bond all elements
d.balance('Standard');

d.mo.isCrack=1;%record the information of cracks
d.getModel();%d.setModel();%reset the initial status of the model
d.resetStatus();%initialize model status, which records running information
d.mo.isHeat=1;%calculate heat in the model
visRate=1;
d.mo.mVis=d.mo.mVis*visRate;%change the viscosity of the simulation
d.setStandarddT();
%-------------end initializing model

%-------------when water table drops
waterFilter=mZ<waterTable2;%filter of element under the water table
mBuoyancy=-waterDensity*mVolumn*d.mo.g;
d.mo.mGZ=mGZ0+mBuoyancy.*waterFilter;
d.balance('Standard');

d.show('Displacement');
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxModel3Finish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();