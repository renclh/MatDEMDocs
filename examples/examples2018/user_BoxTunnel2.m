%set the material of the model
clear
load('TempModel/BoxTunnel1.mat');
%------------initialize model-------------------
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo
%------------end initialize model-------------------

%-------------set new material----------------
matTxt=load('Mats\StrongRock.txt');
Mats{1,1}=material('StrongRock',matTxt,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;
d.groupMat2Model({'sample'},1);
%-------------end set new material----------------

%-------------------apply stress, and balance model------------------
B.SET.stressZZ=-10e6;
B.setPlatenFixId();
d.resetStatus();
B.setPlatenStress('StressZZ',B.SET.stressZZ,B.ballR*5);

d.balanceBondedModel0(4);
d.mo.dT=d.mo.dT*4;%increase the dT to increase the speed of balance
d.balance('Standard');
d.mo.dT=d.mo.dT/4;
%-------------------end apply stress, and balance model------------------

%--------------------make tunnel-----------------------
sampleId=d.getGroupId('sample');
sX=d.mo.aX(sampleId);sY=d.mo.aY(sampleId);sZ=d.mo.aZ(sampleId);
dipD=0;dipA=90;radius=4;height=30;
mX=d.mo.aX(1:d.mNum);mY=d.mo.aY(1:d.mNum);mZ=d.mo.aZ(1:d.mNum);
columnFilter=mfs.getColumnFilter(sX,sY,sZ,dipD,dipA,radius,height);
d.addGroup('Tunnel',find(columnFilter));
tunnelId=d.getGroupId('Tunnel');
d.delElement(tunnelId);
%--------------------end make tunnel-----------------------


%--------------------save data-----------------------
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxTunnel2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
%--------------------end save data-----------------------

d.calculateData();
d.show('ZDisplacement');