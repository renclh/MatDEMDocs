clear;
load('TempModel/BoxSlopeNet2.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%d.setModel();%reset the initial status of the model
d.status=modelStatus(d);%initialize model status, which records running information

d.mo.isHeat=1;%calculate heat in the model
visRate=0.0001;
d.mo.mVis=d.mo.mVis*visRate;%use low viscosity for dynamic simulation
d.mo.setGPU('auto');
d.setStandarddT();
%d.mo.isShear=0;
totalCircle=20;
d.tic(totalCircle);
%.mat files will be saved in the folder data/step
fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
for i=1:totalCircle
    d.balance(50,d.SET.packNum*1.5);
    d.clearData(1);%clear data in d.mo
    save([fName num2str(i) '.mat']);
    d.calculateData();
    d.toc();%show the note of time
end

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxSlope3Finish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();