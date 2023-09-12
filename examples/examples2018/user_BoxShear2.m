%set the material of the model
clear
load('TempModel/BoxShear1.mat');
%------------initialize model-------------------
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo
%------------end initialize model-------------------

%-------------set new material----------------
matTxt=load('Mats\Soil1.txt');
Mats{1,1}=material('Soil1',matTxt,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;
d.groupMat2Model({'sample'},1);
%-------------end set new material----------------

%-------------------apply stress, and balance model------------------
d.resetStatus();
B.SET.platenArea=pi*B.SET.sampleR*B.SET.sampleR;
verticalStress=50e3;
verticalForce=verticalStress*B.SET.platenArea/length(d.GROUP.topPlaten);
d.mo.mGZ(d.GROUP.topPlaten)=-verticalForce;
d.breakGroup();
d.mo.zeroBalance();
B.compactSample(2);%input is compaction time
d.balance('Standard',2);
d.showFilter('SlideY',0.3,1,'mV');


%--------------------save data-----------------------
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Step2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
%--------------------end save data-----------------------
d.calculateData();