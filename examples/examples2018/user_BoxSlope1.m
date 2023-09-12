%make a box model, which will be put on a slope
clear;
fs.randSeed(1);%build random model
B=obj_Box;%build a box object
B.name='BoxSlope';
B.GPUstatus='auto';
B.ballR=0.035;
B.isClump=1;
B.distriRate=0.2;
B.sampleW=0.8;
B.sampleL=0.8;
B.sampleH=1.5;
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
mfs.reduceGravity(d,5);
%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model
d.show('aR');

d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('BoxSlope1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();%because data is clear, it will be re-calculated