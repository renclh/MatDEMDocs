%build the geometrical model
clear;
fs.randSeed(1);%build random model
B=obj_Box;%build a box object
B.name='BoxTunnelNew';
B.GPUstatus='auto';
width=50;length=0;height=50;ballR=0.2;%width, length, height, radius
distriRate=0.2;%define distribution of ball radius, 
isClump=0;
%--------------initial model------------
B.isUI=0;%when run the code in UI_command, isUI=1
B.ballR=ballR;
B.isClump=isClump;
B.distriRate=distriRate;
B.sampleW=width;
B.sampleL=length;
B.sampleH=height;
%B.BexpandRate=4;
%B.PexpandRate=4;
B.type='topPlaten';
%B.type='TriaxialCompression';
B.setType();
B.buildInitialModel();%B.show();
d=B.d;
%--------------end initial model------------
B.gravitySediment();
B.compactSample(6);%input is compaction time
%------------return and save result--------------
mfs.reduceGravity(d,10);
d.balance('Standard');
d.status.dispEnergy();%display the energy of the model
d.clearData(1);%clear dependent data
d.recordCalHour('BoxTunnelNew1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
d.show('aR');