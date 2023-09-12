%build the geometrical model
clear;
fs.randSeed(1);%build random model
B=obj_Box;%build a box object
B.name='BoxTunnelHeat';
B.GPUstatus='auto';
ballR=0.1;%width, length, height, radius
distriRate=0.2;%define distribution of ball radius, 
isClump=0;
%--------------initial model------------
B.isUI=0;%when run the code in UI_command, isUI=1
B.ballR=ballR;
B.isClump=isClump;
B.distriRate=distriRate;
B.sampleW=5;
B.sampleL=5;
B.sampleH=5;
%B.BexpandRate=4;
%B.PexpandRate=4;
B.type='topPlaten';
%B.type='TriaxialCompression';
B.setType();
B.buildInitialModel();%B.show();

d=B.d;
%d.show('aR');return;
%--------------end initial model------------
B.gravitySediment();
B.compactSample(1);%input is compaction time
%------------return and save result--------------
mfs.reduceGravity(d,5);
d.balance('Standard');
d.status.dispEnergy();%display the energy of the model
d.clearData(1);%clear dependent data
d.recordCalHour('BoxTunnelHeat1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
d.show('aR');