%build the geometrical model
clear;
fs.randSeed(2);%build random model
B=obj_Box;%build a box object
B.name='BoxModel';
B.GPUstatus='auto';
B.ballR=1;
B.isClump=0;
B.distriRate=0.2;
B.sampleW=100;
B.sampleL=0;
B.sampleH=80;
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
B.compactSample(1);%input is compaction time
%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model

d.clearData(1);%clear dependent data
d.recordCalHour('BoxModel1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
d.show('aR');