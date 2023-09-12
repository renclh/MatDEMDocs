fs.randSeed(1);%change it to get a different model,1,2,3
%------------------set the grain size and box size------------------
friction=0.2;
grainDensity=2650;%density of the grains
moNum='auto';%divided into 'moNum' size groups (childModel),0~10,'auto'

is2D=0;%0,1,@@@@@@@@@@
isCement=0;%0 or 1,@@@@@@@@@@
grading=3;%1,2,3,4,@@@@@@@@@@
%friction=0.5;%0,0.2,0.4,0.6,0.8,1,@@@@@@@@@@

strengthRate=1;%1,2,5,10,
compactionNum=10;%0,10,
compactionPressure=-1e4;

%--------------------------
rate='auto';%automatical balance rate in B.gravitySediment
sizeRate=1;%
hRate=1.15;% box is bigger a bit, 1.0~1.2
hRate=hRate+isCement*0.1-is2D*0.1+friction*0.02;
E=5e6;
matTxt2=[E,0.14,E*1e-3*strengthRate,E*1e-2*strengthRate,1,1800];%[20e6,0.14,20e3,200e3,0.8,1900];%load a un-trained material file
shearStatus='on';
%--------------------------
if is2D==1
totalM=200e-3;%total mass of the sample
sampleW=0.152;sampleL=0;%width and length of the model, height will be determined by totalM
else
sRate=0.5;
totalM=1600e-3*sRate^3;%total mass of the sample
sampleW=0.1*sRate;sampleL=0.1*sRate;%width and length of the model, height will be determined by totalM
end
%minmum diameter, maximum diameter, and mass rate
if grading==1
grainSizeDistribution=[1,2,0.2;2,4,0.2;2,4,0.2;4,8,0.2;8,16,0.2;16,32,0.2;32,64,0.2]*1e-3*sizeRate*0.9;
elseif grading==2
grainSizeDistribution=[2,4,0.2;2,4,0.2;4,8,0.2;8,16,0.2;16,32,0.2]*1e-3*sizeRate*0.6;
elseif grading==3
grainSizeDistribution=[4,8,0.2;8,16,0.2]*1e-3*sizeRate*0.33;
elseif grading==4
grainSizeDistribution=[8,8,0.2]*1e-3*sizeRate*0.31;
end

%determine the grain radius (grainR) according to the above data
grainR=mfs.getGradationDiameter(grainSizeDistribution,totalM/grainDensity)/2;

%determine the box size
SET=mfs.getBoxSample(grainR,sampleW,sampleL,hRate);
SET.moNum=moNum;%divided into 'moNum' size groups
%------------------end set the grain size and box size------------------

%--------------initializing Box model------------
B=obj_Box;%build a box object
B.name='BoxCompactionShock';
B.GPUstatus='auto';
B.setType('topPlaten');
B.PexpandRate=2;%incease platen size
B.uniformGRate=1;
B.buildInitialModel(SET);%B.show();
B.setUIoutput();

d=B.d;
if B.sampleL==0
B.convert2D(B.ballR);%change ball properties to 2D
end

Mats{1,1}=material('soil1',matTxt2,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;
d.groupMat2Model();

d.mo.setShear(shearStatus);
d.mo.aMUp(:)=friction;
d.showB=1;
d.breakGroup();

%--------------end initializing Box model----------
B.gravitySediment(rate,isCement);%element will be cemented when true
ballDis=min(4,d.SET.packNum*0.1);
pZ=min(d.mo.aZ(d.GROUP.topPlaten))-B.ballR*2*ballDis;
porosity=mfs.getPorosity(B,pZ);
fs.disp(['Porosity of assemblage is ' num2str(porosity*100) '%']);
save(['TempModel/' B.name '1R' num2str(B.ballR) '-is2D' num2str(is2D) ',isCement' num2str(isCement) ',grading' num2str(grading) ',strengthRate' num2str(strengthRate) ',friction' num2str(friction) '.mat']);


B.compactSample(compactionNum,compactionPressure);
d.status.dispEnergy();%display the energy of the model
d.setData();
porosityC=mfs.getPorosity(B,pZ);
fs.disp(['Porosity after compaction is ' num2str(porosityC*100) '%']);
%d.showFilter('Group',{'sample'});
d.show();

%------------return and save result--------------
d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('Step1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-Compactis2D' num2str(is2D) ',isCement' num2str(isCement) ',grading' num2str(grading) ',strengthRate' num2str(strengthRate) ',friction' num2str(friction) '.mat']);
d.calculateData();%because data is clear, it will be re-calculated