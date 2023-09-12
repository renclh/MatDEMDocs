%set the material of the model
clear
load('TempModel/BoxLayer1.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo

matTxt=load('Mats\StrongRock.txt');
Mats{1,1}=material('StrongRock',matTxt,B.ballR);
Mats{1,1}.Id=1;
matTxt2=load('Mats\WeakRock.txt');
Mats{2,1}=material('WeakRock',matTxt2,B.ballR);
Mats{2,1}.Id=2;
matTxt3=load('Mats\Water.txt');
Mats{3,1}=material('Water',matTxt3,B.ballR);
Mats{3,1}.Id=3;
d.Mats=Mats;

dipD=90;dipA=20;strongT=0.01;weakT=0.01;
weakFilter=mfs.getWeakLayerFilter(d.mo.aX,d.mo.aY,d.mo.aZ,dipD,dipA,strongT,weakT);
strongFilter=~weakFilter;
sampleId=d.getGroupId('sample');
aWFilter=false(size(weakFilter));
aWFilter(sampleId)=true;
sampleWfilter=aWFilter&weakFilter;
d.addGroup('WeakLayer',find(sampleWfilter));
sX=d.mo.aX(sampleId);sY=d.mo.aY(sampleId);sZ=d.mo.aZ(sampleId);
Rrate=0.2;

r=(min(max(sX)-min(sX))/2)*Rrate;
centerFilter=mfs.getSphereFilter(sX,sY,sZ,r);
d.addGroup('Pore',find(centerFilter));
B.setPlatenFixId();
d.setGroupMat('WeakLayer','WeakRock');
d.setGroupMat('Pore','Water');
d.groupMat2Model({'WeakLayer','Pore'},1);
d.getModel();%d.setModel();%reset the initial status of the model
d.resetStatus();%initialize model status, which records running information

d.mo.bFilter(:)=0;
d.connectGroup('Pore');
fs.setPlatenStress(d,-1e6,-1e6,-1e6,B.ballR*5);
d.mo.zeroBalance();
d.deleteConnection('boundary');
StandardBalanceNum=2;
d.balance('Standard',StandardBalanceNum);
moveDis=mean(d.TAG.modelWHT)*0.1;
d.moveBoundary('right',moveDis,0,0);%declare moving right boundary
d.moveBoundary('back',0,moveDis,0);
d.moveBoundary('top',0,0,moveDis);

d.balance('Standard',StandardBalanceNum);
d.balanceBondedModel0();%balance the bonded model without friction
d.balanceBondedModel();%balance the bonded model with friction

d.showFilter('SlideY',0.5,1,'aMatId');
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxLayer2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();