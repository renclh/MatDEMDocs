%apply initial stress on the model
clear
load('TempModel/LavaBlock2.mat');
B.setUIoutput();%set output of message
d=B.d;
d.calculateData();
d.mo.setGPU('off'); 
d.getModel();
d.resetStatus();
d.mo.isCrack=1;


sZ=d.mo.aZ(d.GROUP.sample);
topFilter=sZ>max(d.mo.aZ(d.GROUP.sample))-B.sampleH*0.05;
d.addGroup('topBlock',find(topFilter));
area=B.sampleW*B.ballR*2;
stresszz=-5e6;%additional vertical pressure on the model
gZ=area*stresszz/sum(d.mo.mM(d.GROUP.topBlock));
d.mo.mGZ(d.GROUP.topBlock)=d.mo.mM(d.GROUP.topBlock)*gZ;

d.mo.aMUp(d.GROUP.topBlock)=2;
d.mo.aKS(d.GROUP.topBlock)=d.mo.aKS(d.GROUP.topBlock)*5;
platens=[d.GROUP.lefPlaten;d.GROUP.lefPlaten;d.GROUP.lefPlaten;d.GROUP.lefPlaten;];
d.addGroup('platens',platens);
d.setClump('platens');

d.mo.setGPU('auto'); 
d.balance('Standard',4);
%---------end assign material to layers and balance the model1.	

%---------save the data
d.mo.setGPU('off');
d.show();
d.clearData(1);
d.recordCalHour('Step2Finish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();