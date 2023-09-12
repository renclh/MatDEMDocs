%set the material of the model
clear
load('TempModel/HydraulicBlock1.mat');
B.setUIoutput();%set output of message
d=B.d;
d.calculateData();
d.mo.setGPU('off'); 

topPlatenX=d.aX(d.GROUP.topPlaten);%record current position of top platen
topPlatenY=d.aY(d.GROUP.topPlaten);
topPlatenZ=d.aZ(d.GROUP.topPlaten);
d.getModel();%get xyz from d.mo

%make a crack with specified size
crackL=0.020;
cx1=B.sampleW/2;
cx2=B.sampleW/2;
cz1=0.15/2-crackL/2;
cz2=0.15/2+crackL/2;
Rrate=0.5;
lineX=[cx1;cx2];
lineY=zeros(size(lineX));
lineZ=[cz1;cz2];
curveObj1=f.run('fun/make3DCurve.m',lineX,lineY,lineZ,B.ballR*0.1,Rrate);
lineId=d.addElement(1,curveObj1,'wall');
d.addGroup('crack',lineId);
d.minusGroup('sample','crack',0);
d.delElement(d.GROUP.crack);

d.mo.aX(d.GROUP.topPlaten)=topPlatenX;%move the top platen to its original position
d.mo.aY(d.GROUP.topPlaten)=topPlatenY;
d.mo.aZ(d.GROUP.topPlaten)=topPlatenZ;

sZ=d.mo.aZ(d.GROUP.sample);
sR=d.mo.aR(d.GROUP.sample);
topFilter=(sZ+sR)>max(sZ)-B.SET.sampleH0*0.05;
d.delElement(find(topFilter));
d.resetStatus();

%d.show('aR');return

%----------set material of model
matTxt=load('Mats\ZhaoRock.txt');
rate=1;
matTxt(4)=matTxt(4)*rate;
matTxt(3)=matTxt(3)*rate;
matTxt(1)=matTxt(1)*0.1;%lower 
Mats{1,1}=material('RockHydro',matTxt,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;
%----------end set material of model
d.showB=2;

%---------assign material to layers and balance the model
d.mo.setShear('on');
d.removeFixId('Z',[d.GROUP.lefPlaten;d.GROUP.rigPlaten]);
d.addFixId('Z',[d.GROUP.lefPlaten(end-1),d.GROUP.lefPlaten(end),d.GROUP.rigPlaten(end-1),d.GROUP.rigPlaten(end)]);
d.setGroupMat('sample','RockHydro');
d.groupMat2Model({'sample'});
platenIds=[d.GROUP.lefPlaten;d.GROUP.rigPlaten];
d.mo.aKN(platenIds)=d.mo.aKN(platenIds)*0.1;
d.mo.aMUp(platenIds)=0;
d.mo.mGZ(:)=0;

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