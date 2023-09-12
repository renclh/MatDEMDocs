%build the geometrical model
clear;
fs.randSeed(1);%build random model
B=obj_Box;%build a box object
B.name='PoreTunnel';
B.GPUstatus='auto';
B.ballR=0.2;
B.isShear=0
B.isClump=0
B.distriRate=0.2
B.sampleW=40
B.sampleL=0
B.sampleH=40
B.boundaryRrate=0.999999;
B.BexpandRate=2;
B.PexpandRate=1
B.isSample=1;
B.setType('Fluid');
B.buildInitialModel();
d=B.d;

%----------remove overlap platen elements

%----------end remove overlap platen elements
%--------------end initial model------------
B.gravitySediment();

%------------return and save result--------------

d.status.dispEnergy();%display the energy of the model
d.clearData(1);%clear dependent data
d.recordCalHour('PoreTunnelNew1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
d.show('aR');