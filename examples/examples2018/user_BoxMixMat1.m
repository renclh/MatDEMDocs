%build the geometrical model
clear;
fs.randSeed(2);%build random model
B=obj_Box;%build a box object
B.name='BoxMixMat';
B.GPUstatus='auto';
B.ballR=0.001;
B.isClump=1;
B.distriRate=0.3;
B.sampleW=0.1;
B.sampleL=0;
B.sampleH=0.1;
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
B.compactSample(2);%input is compaction time
mfs.reduceGravity(d,5);%reduce the gravity of element
%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model

d.clearData(1);%clear dependent data
d.recordCalHour('BoxMixMat1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
d.show('aR');