%Pipeline Dislocation Deformation
clear
load('TempModel/FiberCoupleSample.mat');
outerFiber=1;%fiber outside the tube
ballR=sampleObj.ballR*0.596;
isSoil=0;%when is Soil is 1, filled with soil particles
B=obj_Box;%build a box object
B.name='FiberCouple';
B.GPUstatus='auto';%program will test the CPU and GPU speed, and choose the quicker one
B.ballR=ballR;
B.isShear=0;
B.isSample=0;
B.isClump=0;%if isClump=1, particles are composed of several balls
B.distriRate=0.2;%define distribution of ball radius, 
B.sampleW=0.9;%width, length, height, average radius
B.sampleL=0.4;%when L is zero, it is a 2-dimensional model
B.sampleH=0.6;
%zB.platenStatus(:)=1;
%when isSoil is 1, make a full box that will be filled with soil
if isSoil==0
B.boundaryStatus=[1,1,0,0,1,0];
B.platenStatus=[0,0,0,0,1,0];
else
B.boundaryStatus=[1,1,1,1,1,0];
B.platenStatus=[0,1,0,1,0,1];
end

B.buildInitialModel();%B.show();
d=B.d;%d.breakGroup('sample');d.breakGroup('lefPlaten');
d.mo.setGPU('off');
minBallR=ballR*0.8;
innerR=0.05;
layerNum=2;
Rrate=0.8;
lengthRate=1;
tubeLength=B.sampleW/2*lengthRate;

%make the tube (tunnel) object
ringObj=f.run('fun/makeRing.m',innerR,layerNum,minBallR,Rrate);
ringElementNum=length(ringObj.X)/layerNum;
maxBallR=max(ringObj.ballRs);
ballRrate=minBallR/maxBallR;
cutDis=maxBallR*(ballRrate*2-1)*2;%distance between two tubes
sZ=sampleObj.Z;
tubeZ=(max(sZ)+min(sZ))/2;%position of tube
%define the tube properties (PVC material)
matTxt=load('Mats\pvc.txt');
Mats{1,1}=material('pvc',matTxt,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;

%define object for the model
tube_dL=(ringObj.ballRs(end)-ringObj.ballRs(1))*2;%
tubeObj=mfs.make3Dfrom2D(ringObj,tubeLength-tube_dL,minBallR);

tubeObj=mfs.rotate(tubeObj,'XZ',90);%rotate the group along XZ plane
tube1Obj=mfs.move(tubeObj,B.sampleW/4-cutDis/2,B.sampleL/2,tubeZ);
tube2Obj=mfs.move(tubeObj,B.sampleW/4+tubeLength+cutDis/2,B.sampleL/2,tubeZ);

fiberObjLeft.X=tubeObj.zList;
fiberObjLeft.Y=zeros(size(tubeObj.zList));
fiberObjLeft.Z=zeros(size(tubeObj.zList));
fiberObjLeft.R=ones(size(tubeObj.zList))*maxBallR;

fiberObjLeft=mfs.alignObj('right',fiberObjLeft,tube1Obj);
fiberObjRight=mfs.alignObj('right',fiberObjLeft,tube2Obj);

fiberObjC.X=(max(fiberObjLeft.X)+min(fiberObjRight.X))/2;
fiberObjC.Y=0;
fiberObjC.Z=0;
fiberObjC.R=maxBallR;

fiberObj=mfs.combineObj(fiberObjLeft,fiberObjC,fiberObjRight);
fiberObj=mfs.move(fiberObj,0,B.sampleL/2,tubeZ);

fiberAngle=[90,270]*pi/180;
rate=0.96;
fiberR1=ringObj.outerR+minBallR;
fiberY=fiberR1*cos(fiberAngle).*rate;
fiberZ=fiberR1*sin(fiberAngle).*rate;

fiber1Obj=mfs.move(fiberObj,0,fiberY(1),fiberZ(1));
fiber2Obj=mfs.move(fiberObj,0,fiberY(2),fiberZ(2));
%here, we can use fs.showObj to see the objects
%fs.showObj(fiber1Obj,'add');fs.showObj(tube1Obj,'add');fs.showObj(tube2Obj);return

%import the objects to the model
[tube1Id,tube2Id,fiber1Id,fiber2Id]=d.addElement(1,{tube1Obj,tube2Obj,fiber1Obj,fiber2Obj});%add a slope boundary
d.addGroup('tube1',tube1Id);%add a new group
d.addGroup('tube2',tube2Id);%add a new group
d.addGroup('fiber1',fiber1Id);%add a new group
d.addGroup('fiber2',fiber2Id);%add a new group

%d.show('aR');view(90,0);%check the position of fiber

G=d.GROUP;
d.addGroup('tubeFiber',[G.tube1;G.tube2;G.fiber1;G.fiber2]);
d.setClump([G.tube1;G.tube2;G.fiber1;G.fiber2;G.lefB;G.rigB]);%set the pile clump
d.mo.zeroBalance();

%
if isSoil==1
    sampleId=d.addElement(1,sampleObj);
    d.addGroup('sample',sampleId);
    sX=d.mo.aX(sampleId);sY=d.mo.aY(sampleId);sZ=d.mo.aZ(sampleId);
    dipD=90;dipA=90;radius=ringObj.outerR;height=B.sampleW;
    columnFilter=f.run('fun/getColumnFilter.m',sX,sY,sZ,dipD,dipA,radius+B.ballR,height);
    d.delElement([sampleId(columnFilter);d.GROUP.botPlaten]);
    d.minusGroup('sample','tubeFiber',0.5);
    
    topId=d.GROUP.topPlaten;
    d.mo.aZ(topId)=mean(topPlatenObj.Z);
end
d=f.run('fun/setGroupId.m',d);
%d.show('groupId');return

%-------------------apply stress, and balance model------------------
if isSoil==1
    B.SET.stressXX=-6e3;
    B.SET.stressYY=-6e3;
    B.SET.stressZZ=-10e3;
    B.setPlatenFixId();
    B.setPlatenStress(B.SET.stressXX,B.SET.stressYY,B.SET.stressZZ,B.ballR*5);
    d.balanceBondedModel0(1);
end

d.showB=2;
d.resetStatus();
d.mo.setGPU('auto');
d.mo.dT=d.mo.dT*4;%increase the dT to increase the speed of balance
d.balance('Standard',0.5);
d.mo.dT=d.mo.dT/4;

d.show();
figure;
d.showFilter('Group',{'fiber1','fiber2'},'StressXX');
%-------------------end apply stress, and balance model------------------

%--------------------save data-----------------------
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Step3Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
%--------------------end save data-----------------------
d.calculateData();