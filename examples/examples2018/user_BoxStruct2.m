clear
load('TempModel/BoxStruct1.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo

G=d.GROUP;
sZ=d.mo.aZ(G.sample);
botSampleId=find(sZ<min(sZ)+B.ballR*1.5);
botLayerId=[botSampleId;G.botP;G.froP];
d.addGroup('botLayer',botLayerId);
botX=d.mo.aX(botLayerId);
blLayerId=botLayerId(botX<mean(botX));
brLayerId=botLayerId(botX>=mean(botX));

d.addGroup('blLayer',blLayerId);
d.addGroup('brLayer',[brLayerId;G.rigP]);
d.GROUP.groupId(d.GROUP.sample)=0;
d.GROUP.groupId(d.GROUP.blLayer)=1;
d.GROUP.groupId(d.GROUP.brLayer)=2;
d.mo.bFilter(:)=true;
d.mo.isCrack=1;
d.mo.zeroBalance();
d.mo.setGPU('auto');
d.balance('Standard',0.5);
d.show('groupId');

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxStruct2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();