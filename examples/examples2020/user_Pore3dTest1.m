%step1: packing the elements
clear;
fs.randSeed(1);%random model seed, 1,2,3...
B=obj_Box();%declare a box object
B.name='pore3dTest';
%--------------initial model------------
B.GPUstatus='auto';%program will test the CPU and GPU speed, and choose the quicker one
B.ballR=0.01;
B.sampleW=0.2;%width, length, height, average radius
B.sampleL=0.2;
B.sampleH=0.22;
B.setType('TriaxialCompression');
B.buildInitialModel();%B.show();
d=B.d;
%you may change the size distribution of elements here, e.g. d.mo.aR=d.aR*0.95;

%---------- gravity sedimentation
B.gravitySediment(1);%you may use B.gravitySediment(10); to increase sedimentation time (10)
%B.compactSample(2);%input is compaction time
mfs.reduceGravity(B.d,10);
d.balance('Standard',2);

%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model
d.show('-aR');
d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('Step1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
%d.show('-Id');