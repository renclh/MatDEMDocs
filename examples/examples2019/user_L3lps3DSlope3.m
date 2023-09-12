%-------------------user_mxSlope3.m;
clear;
load('TempModel/lps_3DSlope2.mat');
d.calculateData();
B.setUIoutput();
d.mo.setGPU('off');

%-----------setup of the calculation
d.getModel();%d.setModel();%reset the initial status of the model
d.mo.aHeat(:)=0;
d.status=modelStatus(d);%initialize model status, which records running information
d.breakGroupOuter('slopeSource');%break the outer connection of the group
d.breakGroup('slopeSource');%break the outer connection of the group

d.mo.isHeat=1;%calculate heat in the model
visRate=0.00001;%ok
d.mo.mVis=d.mo.mVis*visRate;%use lower viscosity
d.setStandarddT();%reset the step time
d.mo.dT=d.mo.dT*4;%increase step time to increase the computing speed
%-----------end setup of the calculation

%---------setup of numerical simulation
fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);
gpuStatus=d.mo.setGPU('auto');
totalCircle=50;
d.tic(totalCircle);
%---------start the numerical simulation
for i=1:totalCircle
    d.balance('Standard',0.5);
    d.clearData(1);
    d.mo.setGPU('off');
    save([fName num2str(i) '.mat'],'-v7.3');
    d.calculateData();
    d.mo.setGPU(gpuStatus);
    d.toc();%show the note of time;
end

%----------save the data
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Box3DSlope3Finish');
save(['TempModel/' B.name '3.mat'],'d','-v7.3');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat'],'-v7.3');
d.calculateData();
d.show('aR');