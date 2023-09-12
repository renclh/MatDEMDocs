%step1: packing the elements
clear;
fs.randSeed(1);%random model seed, 1,2,3...
B=obj_Box;%declare a box object
B.name='Sand_Penetration';

%--------------initial model------------
B.GPUstatus='auto';%program will test the CPU and GPU speed, and choose the quicker one
B.ballR=0.001;
B.isShear=1;
B.isClump=0;%if isClump=1, particles are composed of several balls
B.distriRate=0.2;%define distribution of ball radius, 
B.sampleW=0.25;%width, length, height, average radius
B.sampleL=0;%when L is zero, it is a 2-dimensional model
B.sampleH=0.06;
B.BexpandRate=4;%boundary is 4-ball wider than sample
B.PexpandRate=0;
% B.type='topPlaten';%add a top platen to compact model
B.isSample=1;
B.setType();
B.buildInitialModel();;
d=B.d;

%---------- gravity sedimentation
B.gravitySediment();
d.mo.aMUp(:)=1;   

%------------return and save result--------------
d.status.dispEnergy();
d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('Step1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();