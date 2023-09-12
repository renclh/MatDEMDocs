%set the material of the model
clear
load('TempModel/EarthMoon1.mat');
spaceSize=B.sampleW*6;%side length of square area
%----------------make objects----------------
fastGroupModel=0;%@@default value is 0, fast when the value is 1
earthR=(6.371e6-B.ballR)*1.125;
moonR=3.476e6-B.ballR;
packBallR=B.ballR;%record the ballR of the small box block
packBoxObj=B.d.group2Obj('sample');%make struct object from a group
packBoxObj=mfs.moveObj2Origin(packBoxObj);
earthObj=mfs.cutSphereObj(packBoxObj,earthR);
sphereObj2=mfs.cutSphereObj(packBoxObj,moonR);
boxObj=mfs.cutBoxObj(packBoxObj,B.sampleW*0.3,B.sampleW*0.1,B.sampleW*0.1);

rate=1;
sphereObj2=mfs.move(sphereObj2,B.sampleW*rate,0,0);
boxObj=mfs.move(boxObj,0,-B.sampleW*rate*2,0);
%----------------end make objects----------------

fs.randSeed(1);%build random model
B=obj_Box;%build a box object
B.name='EarthMoon';
B.GPUstatus='auto';
B.ballR=packBallR;
B.isClump=0;
B.isSample=0;
B.distriRate=0.0;
B.sampleW=B.ballR*10;
B.sampleL=B.ballR*10;
B.sampleH=B.ballR*10;
B.boundaryStatus=[0,0,0,0,1,0];
B.setType('botPlaten');

B.SET.fastGroupModel=fastGroupModel;%@@default value is 0, fast when the value is 1
B.SET.spaceSize=spaceSize;
B.buildInitialModel();%B.show();
d=B.d;



%please change the material in other simulations
matTxt=[1.7e12	0.15	20e6	200e6	0.6	5500];%load material file
Mats{1,1}=material('Soil1',matTxt,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;%you may remove this line in other simulations

[earthId,sphere2Id,boxId]=d.addElement(1,{earthObj,sphereObj2,boxObj});
d.addGroup('earth',earthId);
d.addGroup('sphere2',sphere2Id);
d.addGroup('box',boxId);
d.delElement('botPlaten');
d.GROUP.groupProtect=[];
d.delElement('botB');
d.mo.aX(end)=0;d.mo.aY(end)=0;d.mo.aY(end)=0;
%d.showB=2;d.show('aR');return
frame.minX=-spaceSize/2;
frame.minY=-spaceSize/2;
frame.minZ=-spaceSize/2;
frame.maxX=spaceSize/2;
frame.maxY=spaceSize/2;
frame.maxZ=spaceSize/2;
d.mo.frame=frame;
d.mo.mAZ(:)=0;%no earth gravitation

%----------test error between two methods, can be removed
tic
planetfs.resetmGXYZ(d);
planetfs.setModelGravitation(d);
time1=toc;
totalGX1=sum(d.mo.mGX(d.GROUP.earth));
%d.show('aR');return;

tic
planetfs.resetmGXYZ(d);
planetfs.setGroupOuterGravitation(d);
time2=toc;
totalGX2=sum(d.mo.mGX(d.GROUP.earth));
disp(['Model:' num2str(totalGX1) '; Time:' num2str(time1)]);
disp(['Group:' num2str(totalGX2) '; Time:' num2str(time2)]);
%----------end test error between two methods, can be removed
d.show('aR');return;


%------------balance the force on each planet
d.mo.setShear('off');
d.mo.dT=d.mo.dT*4;
planetfs.resetmGXYZ(d);
planetfs.setGroupInnerGravitation(d,{'earth','sphere2','box'});
d.balance('Standard',0.2);
if B.SET.fastGroupModel==1
    d.setClump('earth');
    d.setClump('sphere2');
    d.setClump('box');
    d.mo.aBF=1e100+d.mo.aBF*1e6;
    planetfs.resetmGXYZ(d);
    d.balance('Standard',0.5);
end
d.mo.dT=d.mo.dT/4;

[escapeV,earthM,earthR]=planetfs.getEscapeSpeed(d,'earth');

d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('Step1Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();%because data is clear, it will be re-calculated