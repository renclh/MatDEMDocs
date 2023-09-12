%build the geometrical model
clear;
fs.randSeed(1);%build random model
B=obj_Box;%build a box object
B.name='BoxTBMCutter';
B.GPUstatus='auto';
%--------------initial model------------
B.ballR=0.02;
B.isClump=0;
B.distriRate=0.2;
B.sampleW=1.2;
B.sampleL=0.6;
B.sampleH=0.6;
%B.BexpandRate=4;
%B.PexpandRate=4;
B.type='topPlaten';
%B.type='TriaxialCompression';
B.setType();
B.buildInitialModel();%B.show();
B.setUIoutput();

d=B.d;%d.breakGroup('sample');d.breakGroup('lefPlaten');
%--------------end initial model------------
B.gravitySediment();
B.compactSample(2);%iput is compaction time
mfs.reduceGravity(d,10);

%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model

d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('BoxTBMCutter1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
d.showFilter('Group','sample','aR');