%Excavation process example. Please run the user_BoxCrash1.m first
%this code shows how to kill elements
clear
load('TempModel/BoxCrash1.mat');
B.setUIoutput();%set the output
d=B.d;
d.calculateData();%calculate data
d.mo.setGPU('off');%close the GPU calculation
d.getModel();%get xyz from d.mo
B.name='BoxCrashHole';

%---------------delele elements on the top
d.delElement(d.GROUP.topPlaten);%delete elements according to id
d.balanceBondedModel0(0.1);%balance the bonded model without friction

d.mo.bFilter(:)=true;
d.mo.nBondRate=d.mo.nBondRate*0.1;
d.mo.zeroBalance();
d.resetStatus();
%----------make disc sample------------
gpuStatus=d.mo.setGPU('auto');
fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
discR=20;
for showCircle=1:30
    mX=d.mo.aX(1:d.mNum);
    mZ=d.mo.aZ(1:d.mNum);
    discCX=showCircle*10;
    discCZ=mean(mZ);
    discFilter=(mX-discCX).^2+(mZ-discCZ).^2<discR^2;
    d.killElement(find(discFilter));%add a new group
    
    d.balance('Standard',0.1);
    save([fName num2str(showCircle) '.mat']);
    d.show('Displacement');
end

d.clearData(1);%clear dependent data
d.recordCalHour('Step2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();