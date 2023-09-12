%make a box model, which will be put on a slope
clear;
fs.randSeed(1);%build random model
B=obj_Box;%build a box object
B.name='FiberCouple';
B.GPUstatus='auto';%program will test the CPU and GPU speed, and choose the quicker one
B.ballR=0.01;
B.isShear=0;
B.isClump=0;%if isClump=1, particles are composed of several balls
B.distriRate=0.2;%define distribution of ball radius, 
B.sampleW=0.9;%width, length, height, average radius
B.sampleL=0.4;%when L is zero, it is a 2-dimensional model
B.sampleH=0.6;
B.setType('topPlaten');
B.buildInitialModel();%B.show();
d=B.d;%d.breakGroup('sample');d.breakGroup('lefPlaten');

%--------------end initial model------------
B.gravitySediment();
B.compactSample(2);%input is compaction time

%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model
%d.showFilter('Group',{'sample'});
d.mo.setGPU('off');

%save the soil particles in struct object
sampleObj=d.group2Obj('sample');
sampleObj.ballR=B.ballR;
sampleObj.sampleW=B.sampleW;
sampleObj.sampleL=B.sampleL;
sampleObj.sampleH=B.sampleH;
topPlatenObj=d.group2Obj('topPlaten');
save('TempModel/FiberCoupleSample.mat','sampleObj','topPlatenObj');

d.clearData(1);%clear dependent data
d.recordCalHour('Step1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();%because data is clear, it will be re-calculated