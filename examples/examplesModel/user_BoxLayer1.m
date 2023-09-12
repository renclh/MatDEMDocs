%build the geometrical model
clear;
fs.randSeed(1);%build random model
B=obj_Box;%build a box object
B.name='BoxLayer';
B.GPUstatus='auto';
width=0.1;length=0;height=0.1;ballR=0.001;%width, length, height, radius
distriRate=0.2;%define distribution of ball radius, 
isClump=0;
%--------------initial model------------
B.ballR=ballR;
B.isClump=isClump;
B.distriRate=distriRate;
B.sampleW=width;
B.sampleL=length;
B.sampleH=height;
%B.BexpandRate=4;%expand boundaries
%B.PexpandRate=4;%expand platens
%B.type='GeneralSlope';
B.type='TriaxialCompression';
B.setType();
B.buildInitialModel();%B.show();
B.setUIoutput();

%--------------end initial model------------
B.gravitySediment();
B.compactSample(2);%input is compaction time
d=B.d;
mfs.reduceGravity(d,5);
%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model

d.clearData(1);%clear dependent data
d.recordCalHour('BoxLayer1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
d.show('aR');