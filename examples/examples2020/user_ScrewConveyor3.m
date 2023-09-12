clear;
load('TempModel/Screw2.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%d.setModel();%reset the initial status of the model
d.resetStatus();%initialize model status, which records running information

d.mo.isHeat=1;%calculate heat in the model
visRate=0.05;
d.mo.mVis=d.mo.mVis*visRate;%use low viscosity for dynamic simulation
d.setStandarddT();
d.mo.setShear('off');
d.breakGroup();
d.setStandarddT();
d.mo.dT=d.mo.dT*4;

showType='mV';
d.showFilter('Group',{'sample','helix'});
figureNumber=d.show(showType);
d.figureNumber=figureNumber;

totalCircle=60;stepNum=100;
totalAngle=360*6;
dAngle=-totalAngle/(totalCircle*stepNum);
balanceNum=2;%you may use greater stepNum and balanceNum
disp(['Total real time is ' num2str(d.mo.dT*totalCircle*stepNum*balanceNum)]);

fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
gpuStatus=d.mo.setGPU('auto');
d.tic(totalCircle*stepNum);
for i=1:totalCircle
    d.mo.setGPU(gpuStatus);
    for j=1:stepNum
        d.rotateGroup('helix','YZ',dAngle);
        d.balance(balanceNum);
        d.recordStatus();
        d.toc();%show the note of time
    end
    d.showFilter();
    d.showFilter('Group',{'sample','helix'});
    d.show(showType);
    d.clearData(1);%clear data before saving
    save([fName num2str(i) '.mat']);
    d.calculateData();%calculate the data for further calculation
end

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Step3Finish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();