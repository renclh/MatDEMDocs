%note: run user_BoxModel1 and 2 before runing the code
clear;
load('TempModel/BoxModel2.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
B.name=[B.name 'Exploision'];
%---------enhance the strength of the slope
d.mo.aBF=d.mo.aBF*10;
d.mo.aFS0=d.mo.aFS0*10;

%-------make an exploisive point
centerX=15;centerZ=20;
bombR=2;
dX=d.mo.aX-centerX;
dZ=d.mo.aZ-centerZ;
bombId=find((dX.*dX+dZ.*dZ)<bombR.*bombR);%get the Id of bomb
d.addGroup('Bomb1',bombId);%add a new group
d.showFilter('Group',{'Bomb1'},'aR');
d.mo.zeroBalance();

d.recordStatus();
%-------end make an exploisive point
%-------increase the bomb element size
oldKe=d.status.elasticEs(end);%record the original energy
bombExpandRate=1.4;
d.mo.aR(bombId)=d.mo.aR(bombId)*bombExpandRate;%increase bomb element size
d.mo.zeroBalance();
d.recordStatus();
newKe=d.status.elasticEs(end);
dKe=newKe-oldKe;%calculate the energy increment

%calculate the TNT equivalent 
fs.disp(['Energy of the bomb is ' num2str(dKe) 'J', ' ~=' num2str(dKe/4.2e6) ' Kg TNT']);
%-------end increase the bomb element size

d.getModel();%reset the initial status of the model
d.resetStatus();%initialize model status, which records running information
%d.show();return;

%---------initialize the simulation
d.mo.isHeat=1;%calculate heat in the model
visRate=0.00001;
d.mo.mVis=d.mo.mVis*visRate;
gpuStatus=d.mo.setGPU('auto');
d.setStandarddT();

%----------start simulation
totalCircle=10;
d.tic(totalCircle);
fName=['data/step/' B.name  num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
for i=1:totalCircle
    d.mo.setGPU(gpuStatus);
    d.balance('Standard',0.1);
    d.clearData(1);
    save([fName num2str(i) '.mat']);
    d.calculateData();
    d.toc();%show the note of time
end
%----------end simulation

%--------save data
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxModel3Finish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();