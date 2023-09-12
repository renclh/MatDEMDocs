%-------------------user_mxSlope3.m;
clear;
load('TempModel/BoxTunnel2.mat');
B.setUIoutput();
%------------initialize model-------------------
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.mo.bFilter(:)=true;
d.deleteConnection('boundary');
d.mo.zeroBalance();
d.getModel();%d.setModel();%reset the initial status of the model
d.resetStatus();
d.mo.isHeat=1;%calculate heat in the model
d.setStandarddT();
d.mo.isCrack=1;
%------------end initialize model-------------------

%--------------------apply initial stress-----------------------
fs.setPlatenStress(d,0,0,B.SET.stressZZ,B.ballR*5);
d.mo.setGPU('auto');
d.balance('Standard',1);%standard balance

%--------------------end apply initial stress-----------------------

totalCircle=5;
d.tic(totalCircle);%record the initial time of loop
fName=['data/step/' B.name  num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
gpuStatus=d.mo.setGPU('auto');
for i=1:totalCircle
    fs.setPlatenStress(d,0,0,-20e6*i,B.ballR*5);
    d.mo.zeroBalance();
    d.balance('Standard',1);%standard balance
    d.clearData(1);
    d.mo.setGPU('off');
    save([fName num2str(i) '.mat']);
    d.calculateData();
    d.mo.setGPU(gpuStatus);
    d.toc();%show the note of time;
end
d.tic(totalCircle);
for i=totalCircle+1:totalCircle*2
    d.balance('Standard',0.5);%standard balance
    d.clearData(1);
    d.mo.setGPU('off');
    save([fName num2str(i) '.mat']);
    d.calculateData();
    d.mo.setGPU(gpuStatus);
    d.toc();%show the note of time;
end
d.recordCalHour('BoxTunnel3Finish');
d.mo.setGPU('off');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.show('aR');