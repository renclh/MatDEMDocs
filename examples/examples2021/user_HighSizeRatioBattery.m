clear;
fs.randSeed(2);%change it to get a different model
%------------------set the grain size and box size------------------
grainDensity=2650;%density of the grains
moNum=5;%divided into 'moNum' size groups (childModel)
hRate=1.0;% box is bigger a bit, 1.0~1.2

totalM=1e-9;sampleW=100e-6;sampleL=100e-6;
grainSizeDistribution=[1,2,0.1;5,10,0.9]*2e-6;
%determine the grain radius (grainR) according to the above data
grainR=mfs.getGradationDiameter(grainSizeDistribution,totalM/grainDensity)/2;
%determine the box size
SET=mfs.getBoxSample(grainR,sampleW,sampleL,hRate);
SET.moNum=moNum;%divided into 'moNum' size groups
%SET.platenR=5e-6;
%SET.boundaryR=5e-6;
%------------------end set the grain size and box size------------------

%--------------initializing Box model------------
B=obj_Box;%build a box object
B.name='highSizeRatio';
B.GPUstatus='auto';
%B.setType('Fluid');
B.buildInitialModel(SET);%B.show();
B.setUIoutput();

d=B.d;
%d.showFilter('SlideY',0.3,0.5,'aR');
%return

%--------------end initializing Box model------------
B.gravitySediment(1);
%return
d.status.dispEnergy();%display the energy of the model
d.setData();
%d.showFilter('Group',{'sample'});
d.show();

%------------return and save result--------------
d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('Step1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();%because data is clear, it will be re-calculated