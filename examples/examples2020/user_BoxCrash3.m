ufs.setTitle('MatDEM陨石撞击地面实时模拟');
clear;
load('TempModel/BoxCrash2.mat');
d.calculateData();
d.mo.setGPU('off');
B.setUIoutput();
d=B.d;
d.getModel();%d.setModel();%reset the initial status of the model
d.resetStatus();%initialize model status, which records running information
d.mo.isShear=0;
d.mo.isHeat=1;%calculate heat in the model
visRate=0.0001;
d.mo.mVis=d.mo.mVis*visRate;
discId=d.GROUP.Disc;
d.setStandarddT();
d.mo.dT=d.mo.dT*4;

d.mo.mVZ(discId)=-2000;
d.mo.mVX(discId)=-1000;

d.showB=0;
d.status.legendLocation='West';

%----------set the drawing of result during iterations
%ufs.simpleFigure('on');%simplify the figure drawing
showType='StressZZ';
figureNumber=d.show(showType);
d.figureNumber=figureNumber;
%----------end set the drawing of result during iterations

gpuStatus=d.mo.setGPU('auto');
totalCircle=50;
d.tic(totalCircle);
fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
for i=1:totalCircle
    d.balance('Standard',0.0005);
    d.show(showType);
    pause(0.05);
end
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxCrush3Finish');
save(['TempModel/' B.name '3.mat'],'d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();