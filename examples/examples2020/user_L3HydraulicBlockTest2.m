%set the material of the model
clear
load('TempModel/HydraulicBlock1.mat');
B.setUIoutput();%set output of message
B.name=[B.name 'Test'];
d=B.d;
d.calculateData();
d.mo.setGPU('off'); 
topPlatenX=d.aX(d.GROUP.topPlaten);%record current position of top platen
topPlatenY=d.aY(d.GROUP.topPlaten);
topPlatenZ=d.aZ(d.GROUP.topPlaten);
d.getModel();%get xyz from d.mo

d.mo.aX(d.GROUP.topPlaten)=topPlatenX;%move the top platen to its original position
d.mo.aY(d.GROUP.topPlaten)=topPlatenY;
d.mo.aZ(d.GROUP.topPlaten)=topPlatenZ;

%cut the top part of the sample
sZ=d.mo.aZ(d.GROUP.sample);
sR=d.mo.aR(d.GROUP.sample);
topFilter=(sZ+sR)>max(sZ)-B.SET.sampleH0*0.05;
d.delElement(find(topFilter));
d.resetStatus();

%----------set material of model
matTxt=load('Mats\ZhaoRock.txt');
rate=1;
matTxt(4)=matTxt(4)*rate;
matTxt(3)=matTxt(3)*rate;
matTxt(1)=matTxt(1);%*0.1
Mats{1,1}=material('RockHydro',matTxt,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;
%----------end set material of model
d.showB=2;

%---------assign material to layers and balance the model
d.mo.setShear('on');
d.removeFixId('Z',[d.GROUP.lefPlaten;d.GROUP.rigPlaten]);%left and right platen will be flexible
d.addFixId('Z',[d.GROUP.lefPlaten(end-1),d.GROUP.lefPlaten(end),d.GROUP.rigPlaten(end-1),d.GROUP.rigPlaten(end)]);%corner of platen will be fixed
d.setGroupMat('sample','RockHydro');
d.groupMat2Model({'sample'});
platenIds=[d.GROUP.lefPlaten;d.GROUP.rigPlaten];
d.mo.aKN(platenIds)=d.mo.aKN(platenIds)*0.1;
d.mo.aMUp(platenIds)=0;
d.mo.mGZ(:)=0;

%---------start computing
d.mo.setGPU('auto');
d.breakGroup();%break all connections and glue the sample
d.connectGroup('sample');
d.removePrestress(0.1);%remove internal stress of sample
d.balance('Standard',0.5);
d.connectGroup('sample');
d.removePrestress(0.1);%remove internal stress of sample
d.balance('Standard',0.5);

d.show();
%---------end assign material to layers and balance the model1.	

%---------save the data
d.mo.setGPU('off'); 
d.clearData(1);
d.recordCalHour('Step2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();