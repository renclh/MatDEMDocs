%set the material of the model
clear
load('TempModel/3DJointStress1.mat');
%------------initialize model-------------------
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo
%------------end initialize model-------------------

%-------------set new material----------------
matTxt=load('Mats\StrongRock.txt');
Mats{1,1}=material('StrongRock',matTxt,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;
d.groupMat2Model({'sample'},1);
%-------------end set new material----------------

%-------------------apply stress, and balance model------------------
B.SET.stressXX=-6e6;
B.SET.stressYY=-6e6;
B.SET.stressZZ=-10e6;
B.setPlatenFixId();
d.resetStatus();
B.setPlatenStress(B.SET.stressXX,B.SET.stressYY,B.SET.stressZZ,B.ballR*5);

d.balanceBondedModel0(4);
d.mo.dT=d.mo.dT*4;%increase the dT to increase the speed of balance
aMUp=d.mo.aMUp;d.mo.aMUp(:)=0;%remove friction
d.balance('Standard',5);
d.mo.aMUp=aMUp;%restore friction
d.mo.dT=d.mo.dT/4;
%-------------------end apply stress, and balance model------------------

%--------------------save data-----------------------
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Step3Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
%--------------------end save data-----------------------

d.calculateData();
d.show('ZDisplacement');