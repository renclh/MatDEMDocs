clear;
load('TempModel/BoxEarthquake2.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%reset the initial status of the model
d.resetStatus();%initialize model status, which records running information

d.mo.isHeat=1;%calculate heat in the model
d.mo.isCrack=1;%record in the model
visRate=0.000001;
d.mo.mVis=d.mo.mVis*visRate;
gpuStatus=d.mo.setGPU('auto');
d.setStandarddT();

%------------move left boundary to generate compressive wave
d.moveBoundary('left',0.01,0,0);

totalCircle=40;
d.tic(totalCircle);
fName=['data/step/' B.name  num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
for i=1:totalCircle
    d.mo.setGPU(gpuStatus);
    d.balance('Standard',0.01);
    d.clearData(1);
    save([fName num2str(i) '.mat']);
    d.calculateData();
    d.toc();%show the note of time
end

d.show('mV');

%-----------save data
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxModel3Finish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();