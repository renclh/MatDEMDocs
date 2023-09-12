clear;
fs.randSeed(2);
sampleFileName='';
%sampleFileName='TempModel/BoxTakeGroup2.mat';
SET.sampleW=0.152;SET.sampleH=0.120;
%----------set of the sand sample
if isempty(sampleFileName)
    hRate=1.02;% box is bigger a bit, 1.0
    grainDensity=2650;
    sampleW=0.152;sampleL=0;totalM=250e-3;
    %minmum diameter, maximum diameter,
    grainSizeDistribution=[0.001,0.002,0.2;0.002,0.004,0.4;0.004,0.008,0.2;0.008,0.016,0.1]*2;
    grainR=mfs.getGradationDiameter(grainSizeDistribution,totalM/grainDensity)/2;
    SET=mfs.getBoxSample(grainR,sampleW,sampleL,hRate);
    SET.isSample=1;
else
    load(sampleFileName);
    SET.ballR=sqrt(max(grainObj.R)*min(grainObj.R));
    SET.isSample=0;
end

SET.grainDensity=grainDensity;
SET.sampleFileName=sampleFileName;
SET.boxDiameter=0.152;SET.boxHeight=0.120;
SET.addHeight1=0.05;SET.addHeight2=0.01;
%----------end set of the sand sample
%----------set of the equipments
SET.hammerMass=4.5;
SET.hammerDistance=0.457;
SET.hammerV=sqrt(SET.hammerDistance*2/9.8);
SET.hammerDiameter=0.051;
SET.hammerArea=pi*SET.hammerDiameter^2/4;
SET.hammer2DAreaRate=SET.ballR*2/SET.hammerDiameter;
SET.hammerMass2D=SET.hammerMass*SET.hammer2DAreaRate;
SET.hammerGZ2D=SET.hammerMass2D*-9.8;
SET.hammerX=0.0125;
%----------end set of the equipments

%----------start building the model
fs.randSeed(1);%random model seed, 1,2,3...
B=obj_Box;%declare a box object
B.name='BoxCompaction';
%--------------initial model------------
B.GPUstatus='auto';%program will test the CPU and GPU speed, and choose the quicker one
B.ballR=SET.ballR;
B.distriRate=0.2;%define distribution of ball radius, 
B.sampleW=SET.boxDiameter;%inner diameter
B.sampleL=0;%when L is zero, it is a 2-dimensional model
B.sampleH=SET.sampleH;%
B.isSample=SET.isSample;
B.SET=SET;
B.platenStatus=[0;0;0;0;0;1];%topPlaten
B.buildInitialModel();%B.show();
B.setUIoutput();
d=B.d;%d.breakGroup('sample');d.breakGroup('lefPlaten');

if isempty(sampleFileName)
    sampleNum=length(d.GROUP.sample);
    d.mo.setGPU('off');
    d.delElement(SET.grainNum+1:sampleNum);
    sId=d.GROUP.sample;
    d.aR(sId)=grainR;
    d.mo.aR(sId)=grainR;
    d.groupMat2Model({'sample'},1);%apply the material
    d.mo.setNearbyBall();
    d.breakGroup();
    B.convert2D(B.ballR);%change ball properties to 2D
else
    d.GROUP.sample=d.addElement(1,grainObj);
    d.setClump();
    d.SET.ballArea=grainObj.ballArea;
end
%d.mo.setShear('off');

d.mo.aMUp(:)=0.5;%increase friction coefficient to increase porosity
d.mo.setGPU('auto');

%---------- gravity sedimentation
B.gravitySediment();%you may use B.gravitySediment(10); to increase sedimentation time (10)
d.show('mV');
%return
%mfs.reduceGravity(d,2);
%------------return and save result--------------
porosity=mfs.get2DPorosity(d,0,B.sampleW,0,B.sampleH/2);
d.status.dispEnergy();%display the energy of the model
d.show('aR');

d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('Step1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();