%step1: packing of model
clear;
%-------------initial parameters and build model--------------
A=obj_3AxisTester();%build tester
A.randomSeed=1;
A.waterPressure=0.1e6;%static water pressure
A.isClump=0;%particle is not clump
A.ballR=0.005;%average element radius
A.name='3AxialTest';
A.type='3Axial';%type='uniaxialC';%uniaxial compression
A.distriRate=0.2;%distribution coefficient
A.loadingType='stress';%displacement or stress
A.stressStep=-[50;100;200;400;800;1600;3200]*1e3;
A.maxStrain=0.15;
A.setType();
A.buildIntialModel();
A.setUIoutput();%set output of form
d=A.d;
d.mo.setGPU('auto');

sampleId=d.GROUP.sample;
%d.mo.aR(sampleId)=d.mo.aR(sampleId)*0.99;d.mo.setNearbyBall();%adjust element radius here

d.mo.setGPU('auto');%set auto GPU
A.gravitySediment();%sedimentation of elements
topPlatenId=d.GROUP.topPlaten;
d.mo.mGZ(topPlatenId)=d.mo.mGZ(topPlatenId)*10;
mfs.reduceGravity(d,5);
d.balance(50,20+d.SET.packNum);

d.status.dispEnergy();%display energy information
d.showFilter('SlideY',0.3,1);
d.show('StressZZ');

d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('AxialStep1Finish');
save(['TempModel/' A.name '1.mat'],'A','d');
save(['TempModel/' A.name '1R' num2str(A.ballR) '-distri' num2str(A.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();