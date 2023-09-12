%set the material of the model
clear
load('TempModel/LavaBlock1.mat');
B.setUIoutput();%set output of message
d=B.d;
d.calculateData();
d.mo.setGPU('off'); 
d.mo.aX(d.GROUP.topPlaten)=d.aX(d.GROUP.topPlaten);
d.mo.aY(d.GROUP.topPlaten)=d.aY(d.GROUP.topPlaten);
d.mo.aZ(d.GROUP.topPlaten)=d.aZ(d.GROUP.topPlaten);
platenId=[d.GROUP.lefPlaten;d.GROUP.rigPlaten;d.GROUP.botPlaten;d.GROUP.topPlaten];
d.addFixId('XYZ',platenId);
d.getModel();%get xyz from d.mo
d.resetStatus();
%----------remove top part
sX=d.mo.aX(d.GROUP.sample);
sZ=d.mo.aZ(d.GROUP.sample);
topFilter=sZ>0.9*B.sampleH;
%----------make a hole
cx=B.sampleW/2;
cz=0;
holeR=50;
cFilter=sqrt((sX-cx).^2+(sZ-cz).^2)<holeR;
delId=find(topFilter|cFilter);
d.delElement(delId);

%---------define weak layer
sZ=d.mo.aZ(d.GROUP.sample);
weakFilter=sZ>0.2*B.sampleH&sZ<0.25*B.sampleH;
d.addGroup('WeakLayer',find(weakFilter));


%----------set material of model
matTxt=load('Mats\LavaRock.txt');
rate=1;
matTxt(4)=matTxt(4)*rate;
matTxt(3)=matTxt(3)*rate;
matTxt(1)=matTxt(1)*1;%lower 
Mats{1,1}=material('RockHydro',matTxt,B.ballR);
Mats{1,1}.Id=1;

rate2=0.1;
matTxt(4)=matTxt(4)*rate2;
matTxt(3)=matTxt(3)*rate2;
Mats{2,1}=material('RockWeak',matTxt,B.ballR);
Mats{2,1}.Id=2;
d.Mats=Mats;
%----------end set material of model
d.showB=2;

%---------assign material to layers and balance the model
d.mo.setShear('on');
d.removeFixId('Z',[d.GROUP.lefPlaten;d.GROUP.rigPlaten]);
d.addFixId('Z',[d.GROUP.lefPlaten(end-1),d.GROUP.lefPlaten(end),d.GROUP.rigPlaten(end-1),d.GROUP.rigPlaten(end)]);
d.setGroupMat('sample','RockHydro');
d.setGroupMat('WeakLayer','RockWeak');

d.groupMat2Model({'sample','WeakLayer'},1);

platenIds=[d.GROUP.lefPlaten;d.GROUP.rigPlaten];
d.mo.aKN(platenIds)=d.mo.aKN(platenIds)*0.1;
d.mo.aMUp(platenIds)=0;

%d.show('aMatId');return
%---------start computing
d.mo.setGPU('auto');
d.breakGroup();
d.connectGroup('sample');
d.removePrestress(0.1);
d.balance('Standard',2);
d.connectGroup('sample');
d.removePrestress(0.1);
d.balance('Standard',2);

d.show();
%---------end assign material to layers and balance the model1.	

%---------save the data
d.mo.setGPU('off'); 
d.clearData(1);
d.recordCalHour('Step2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();