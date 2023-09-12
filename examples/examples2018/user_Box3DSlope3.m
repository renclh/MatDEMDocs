%-------------------user_mxSlope3.m;
clear;
load('TempModel/3DSlope2.mat');
d.calculateData();
B.setUIoutput();
d.mo.setGPU('off');
%d.showB=3;d.show('StressXX');return;

%setup of calculation
d.getModel();%d.setModel();%reset the initial status of the model
d.mo.aHeat(:)=0;
d.status=modelStatus(d);%initialize model status, which records running information
d.breakGroupOuter({'layer3'});%break the outer connection of the group
d.breakGroup({'layer3'});%break the outer connection of the group

d.mo.isHeat=1;%calculate heat in the model
visRate=0.00001;%ok
d.mo.mVis=d.mo.mVis*visRate;
d.setStandarddT();

fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
gpuStatus=d.mo.setGPU('auto');
totalCircle=10;
d.tic(totalCircle);
for i=1:totalCircle
    d.balance('Standard');
    d.clearData(1);
    d.mo.setGPU('off');
    save([fName num2str(i) '.mat']);
    d.calculateData();
    d.mo.setGPU(gpuStatus);
    d.toc();%show the note of time;
end
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Box3DSlope3Finish');
save(['TempModel/' B.name '3.mat'],'d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
d.show('aR');