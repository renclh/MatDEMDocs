clear;
load('TempModel/BoxMixMat2.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%d.setModel();%reset the initial status of the model
d.resetStatus();%initialize model status, which records running information
d.mo.isHeat=1;%calculate heat in the model
d.mo.isCrack=1;%record cracking process
gpuStatus=d.mo.setGPU('auto');
d.setStandarddT();%set standard dT

mat2Id=d.GROUP.Mat2Group;
totalCircle=2;
stepNum=10;%see the teaching video and to increase the stepNum
elementExpandRate=0.01;%material 2 will be expanded by 1%
aR0=d.mo.aR;
daR=(aR0*elementExpandRate)/totalCircle/stepNum;

d.tic(totalCircle*stepNum);
fName=['data/step/' B.name  num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
for i=1:totalCircle
    for j=1:stepNum
        d.toc();%show the note of time
        d.mo.aR(mat2Id)=d.mo.aR(mat2Id)+daR(mat2Id);
        d.mo.setNearbyBall();
        d.mo.zeroBalance();
        d.balance('Standard',1);
    end
    d.clearData(1);%clear data in d.mo
    save([fName num2str(i) '.mat']);
    d.calculateData();
end

d.show('Crack','aMatId');
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxMixMat3Finish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();