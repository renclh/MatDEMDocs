clear;
load('TempModel/BoxWord2.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%d.setModel();%reset the initial status of the model
d.status=modelStatus(d);%initialize model status, which records running information

d.mo.isShear=0;
d.mo.isHeat=1;%calculate heat in the model
d.addFixId('Y',d.GROUP.word);
d.moveBoundary('front',0,-B.ballR,0);
d.moveBoundary('back',0,B.ballR,0);
visRate=0;
d.mo.mVis=d.mo.mVis*visRate;
gpuStatus=d.mo.setGPU('auto');
d.setStandarddT();
d.mo.dT=d.mo.dT*4;

totalCircle=50;
d.tic(totalCircle);
fName=['data/step/' B.name  num2str(B.ballR) '-' num2str(B.distriRate) 'loopNumHappy'];
save([fName '0.mat']);%return;
for i=1:totalCircle
    d.mo.setGPU(gpuStatus);
    d.balance('Standard',0.1);
    d.clearData(1);
    save([fName num2str(i) '.mat']);
    d.calculateData();
    d.toc();%show the note of time
end

d.show('aR');
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Step3Finish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();