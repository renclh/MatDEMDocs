clear;
load('TempModel/X_Joint12.mat');
d.calculateData();
d.mo.setGPU('off');
B.setUIoutput();
d=B.d;
d.mo.isCrack=1;

d.getModel();%d.setModel();%reset the initial status of the model
d.resetStatus();%initialize model status, which records running information
d.mo.isHeat=1;%calculate heat in the model

d.mo.setShear('on');
gpuStatus=d.mo.setGPU('auto');
totalCircle=50;
d.tic(totalCircle);
fName=['data\step\' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
d.mo.aBF=d.mo.aBF;
d.mo.aMUp(d.GROUP.lefPlaten)=0;
d.mo.aMUp(d.GROUP.rigPlaten)=0;
%d.mo.aMUp=d.mo.aMUp*0;
d.balance('Standard',1);

dis=800;
stepNum=16000
recordNum=800;
dDis=dis/stepNum;
num=0;
for i=1:stepNum
    d.moveGroup('topPart',0,0,-dDis);
    d.balance(2,1);
    if mod(i,recordNum)==0
        num=num+1;
        save([fName num2str(num) '.mat']);
    end
end
d.show('Displacement');

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxCrush3Finish');
save(['TempModel/' B.name '3.mat'],'d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();