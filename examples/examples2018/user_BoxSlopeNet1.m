%make a box model, which will be put on a slope
clear;
fs.randSeed(1);%build random model
B=obj_Box;%build a box object
B.name='BoxSlopeNet';
B.GPUstatus='auto';
B.ballR=0.05;
B.isClump=0;
B.distriRate=0.2;
B.sampleW=1;
B.sampleL=1;
B.sampleH=1.2;
%B.BexpandRate=4;
%B.PexpandRate=4;
B.type='GeneralSlope';
%B.type='TriaxialCompression';
B.setType();
B.buildInitialModel();%B.show();
B.setUIoutput();

d=B.d;%d.breakGroup('sample');d.breakGroup('lefPlaten');
%--------------end initial model------------
B.gravitySediment();
B.compactSample(2);%input is compaction time
mfs.reduceGravity(d,10);%reduce the gravity of element

%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model
d.show('aR');

d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('Step1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();%because data is clear, it will be re-calculated