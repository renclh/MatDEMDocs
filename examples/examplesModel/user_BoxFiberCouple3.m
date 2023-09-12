clear;
load('TempModel/FiberCouple2.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%d.setModel();%reset the initial status of the model
d.resetStatus();%initialize model status, which records running information
d.mo.isHeat=1;%calculate heat in the model
d.setStandarddT();

%apply body force on tube
tube2X=d.mo.aX(d.GROUP.tube2);
tube2LeftId=d.GROUP.tube2(tube2X<min(tube2X)+0.1);
addWeight=-100;
d.addGroup('tube2Left',tube2LeftId);
d.mo.mGZ(tube2LeftId)=d.mo.mGZ(tube2LeftId)+addWeight/length(tube2LeftId);

d.mo.setGPU('auto');
d.mo.dT=2*d.mo.dT;
d.balance('Standard',0.5);
d.show('Displacement');

%show the results
figure
fX=d.mo.aX(d.GROUP.fiber1);
sX=d.data.StrainXX(d.GROUP.fiber1);
subplot(2,2,1);
plot(fX,sX);
title(['top fiber, maximum strain: ' num2str(max(sX))]);

fX=d.mo.aX(d.GROUP.fiber2);
sX=d.data.StrainXX(d.GROUP.fiber2);
subplot(2,2,2);
plot(fX,sX);
title(['bottom fiber, maximum strain: ' num2str(max(sX))]);

fX=d.mo.aX(d.GROUP.fiber1);
sX=d.data.ZDisplacement(d.GROUP.fiber2);
subplot(2,2,3);
plot(fX,sX);
title(['top fiber, displacement']);

fX=d.mo.aX(d.GROUP.fiber2);
sX=d.data.ZDisplacement(d.GROUP.fiber2);
subplot(2,2,4);
plot(fX,sX);
title(['bottom fiber, displacement']);


d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxSlope3Finish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();