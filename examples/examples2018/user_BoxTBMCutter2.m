%set the material of the model
clear
load('TempModel/BoxTBMCutter1.mat');
B.setUIoutput();
d=B.d;
d.calculateData();%calculate data after loading the .mat file
d.mo.setGPU('off');%close the GPU before handling the model
d.getModel();%get X,Y,Z,R.. from d.mo

%------------------remove top elements
mZ=d.mo.aZ(1:d.mNum);
topLayerFilter=mZ>max(mZ)*0.5;
d.delElement(find(topLayerFilter));

%--------------set material, define strong and weak rock
matTxt=load('Mats\StrongRock.txt');
Mats{1,1}=material('StrongRock',matTxt,B.ballR);
Mats{1,1}.Id=1;
matTxt2=load('Mats\WeakRock.txt');
Mats{2,1}=material('WeakRock',matTxt2,B.ballR);
Mats{2,1}.Id=2;
d.Mats=Mats;%assign the material to the model

%set different layers with different mechanical properties
dipD=90;dipA=60;strongT=0.1;weakT=0.1;%dipD: dip direction of layer; dipA: dip angle of layer
weakFilter=mfs.getWeakLayerFilter(d.mo.aX,d.mo.aY,d.mo.aZ,dipD,dipA,strongT,weakT);%make weak layer filter of the box model
sampleId=d.getGroupId('sample');
aWFilter=false(size(weakFilter));
aWFilter(sampleId)=true;
sampleWfilter=aWFilter&weakFilter;
d.addGroup('WeakLayer',find(sampleWfilter));%define a WeakLayer group

%B.setPlatenFixId();
d.setGroupMat('WeakLayer','WeakRock');%material of WeakLayer group is WeakRock
d.groupMat2Model({'WeakLayer'},1);%assign material to WeakLayer group, material Id of other elements is 1
%d.show('StressZZ');view(5,5);

%create a hob, define the size of a hob
hobR=0.2;hobT=0.1;ballR=B.ballR;Rrate=0.7;cutRate=1;
hob=mfs.makeHob(hobR,hobT,cutRate,ballR,Rrate);
%fs.showObj(hob);%show the hob
hob=mfs.rotate(hob,'YZ',90);

%change the hob object to a build object to get nearby ball matrix
hobd=mfs.Obj2Build(hob);
aCN=sum(hobd.mo.nBall~=hobd.aNum,2);
aCN=[aCN;0];
CNFilter=aCN<mean(aCN)*0.88;
hobd.showFilter('Filter',CNFilter);
%hobd.showFilter('SlideZ',0,0.3);
mFilter=hobd.data.showFilter(1:hobd.mNum);
hob=mfs.filterObj(hob,mFilter);%make new object

%add a central ball to record the coordinates
hob.X=[hob.X;(max(hob.X)+min(hob.X))/2];
hob.Y=[hob.Y;(max(hob.Y)+min(hob.Y))/2];
hob.Z=[hob.Z;(max(hob.Z)+min(hob.Z))/2];
hob.R=[hob.R;mean(hob.R)];

%fs.showObj(hob);
%-------------add the hob to the model
hobId=d.addElement(1,hob);%mat Id, obj
d.addGroup('Hob',hobId);
sampleId=d.GROUP.sample;
d.moveGroup('Hob',hobR,(max(d.aY(sampleId))+min(d.aY(sampleId)))/2,0);
hobBot=min(d.mo.aZ(hobId)-d.mo.aR(hobId));
sampleTop=max(d.mo.aZ(sampleId)+d.mo.aR(sampleId));
d.moveGroup('Hob',0,0,sampleTop-hobBot);
d.setClump('Hob');%define the hob as a clump
d.removeGroupForce(d.GROUP.Hob,[d.GROUP.topB;d.GROUP.rigB]);%not force between hob and boundaries

d.mo.isFix=1;
d.addFixId('X',hobId);%fix the X-coordinate of the hob
d.addFixId('Y',hobId);%fix the Y-coordinate of the hob
d.mo.zeroBalance();
%d.show('StressZZ');return;
d.balanceBondedModel0();%setGPU Auto
d.mo.bFilter(:)=0;
d.balance('Standard');%==d.balance(50,d.SET.packNum);
%d.balanceBondedModel();%bonded all elements and balance the model with element friction
d.balanceBondedModel0();%bonded all elements and balance the model without element friction
d.addFixId('Z',hobId);%fix the Y-coordinate of the hob

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxTBMCutter2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
d.show('ZDisplacement');