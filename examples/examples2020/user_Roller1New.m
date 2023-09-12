%@@@@run the file user_RollerAuthorization.m@@@@
%ufs.setTitle('MatDEM滚筒搅拌实时模拟');
tubeR=tubeInnerR+ballR;
tubeL=tubeInnerL+ballR*2;
innerWidth=tubeInnerR*0.3;
sampleSide=tubeInnerR*1.1;
sampleLength=tubeL*0.9;

distriRate=0.2;
sampleObj=mfs.denseModel(1+distriRate,@mfs.makeBox,sampleSide,sampleLength,sampleSide,ballR);
randRRate=(1-distriRate)+rand(size(sampleObj.R))*distriRate*2;
sampleObj.R=sampleObj.R.*randRRate;
sampleObj=mfs.moveObj2Origin(sampleObj);
%fs.showObj(sampleObj);return

tubeObj=mfs.denseModel(Rrate,@mfs.makeTube,tubeR+(1-Rrate)*ballR*2,tubeL,ballR);
tubeObj=mfs.moveObj2Origin(tubeObj);

planeObj=mfs.denseModel(Rrate,@mfs.makeBox,innerWidth,tubeL,ballR,ballR);
planeObj.Z=planeObj.Z-ballR;
planeObj=mfs.rotate(planeObj,'YZ',90);
planeObj=mfs.move(planeObj,tubeInnerR-innerWidth,0,-tubeL/2);
planeObj=mfs.rotateCopy(planeObj,60,6);%plane
tubeObj=mfs.combineObj(tubeObj,planeObj);

bacDiscObj=mfs.denseModel(Rrate,@mfs.makeDisc,tubeInnerR+(1-Rrate)*ballR*1,ballR);
bacDiscObj=mfs.moveObj2Origin(bacDiscObj);
bacDiscObj=mfs.move(bacDiscObj,0,0,-tubeInnerL/2-ballR);
froDiscObj=mfs.move(bacDiscObj,0,0,tubeInnerL+ballR*2);

tubeObj=mfs.rotate(tubeObj,'YZ',90);
bacDiscObj=mfs.rotate(bacDiscObj,'YZ',90);
froDiscObj=mfs.rotate(froDiscObj,'YZ',90);

tubeOuterR=tubeR+ballR;
discOuterL=max(bacDiscObj.Y)+ballR;
tubeObj=mfs.move(tubeObj,tubeOuterR,discOuterL,tubeOuterR);
bacDiscObj=mfs.move(bacDiscObj,tubeOuterR,discOuterL,tubeOuterR);
froDiscObj=mfs.move(froDiscObj,tubeOuterR,discOuterL,tubeOuterR);
sampleObj=mfs.move(sampleObj,tubeOuterR,discOuterL,tubeOuterR);
% 
% fs.showObj(tubeObj,'add');
% hold all;
% fs.showObj(bacDiscObj,'add');
% fs.showObj(sampleObj);
% fs.generalView();
% return

fs.randSeed(1);%random model seed, 1,2,3...
B=obj_Box;%declare a box object
B.name='Roller';
%--------------initial model------------
B.GPUstatus='auto';%program will test the CPU and GPU speed, and choose the quicker one
B.ballR=ballR;
B.isShear=0;
B.isSingle=0;
B.sampleW=tubeOuterR*2;
B.sampleL=discOuterL*2;
B.sampleH=tubeOuterR*2;
B.SET.speed=speed;
B.SET.totalCircle=totalCircle;
B.SET.stepNum=stepNum;
B.isSample=0;
B.setType('botPlaten');
B.buildInitialModel();
d=B.d;
d.mo.setGPU('off');

matTxt1=load('Mats\rubber.txt');
matTxt1(1)=matTxt1(1)/200;
Mats{1,1}=material('rubber',matTxt1,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;
G=d.GROUP;
d.delElement([G.lefB;G.rigB;G.froB;G.bacB;G.botB;G.topB]);

[froDiscId,bacDiscId]=d.addElement(1,{froDiscObj,bacDiscObj},'wall');
d.addGroup('froB',froDiscId);
d.addGroup('bacB',bacDiscId);

tubeId=d.addElement(1,tubeObj,'wall');
d.addGroup('tube',tubeId);

tubeX=d.aX(d.GROUP.tube);
meanTubeX=mean(tubeX);
lefTubeId=tubeId(tubeX<meanTubeX);
rigTubeId=tubeId(tubeX>=meanTubeX);
d.addGroup('lefB',lefTubeId);
d.addGroup('rigB',rigTubeId);

sampleId=d.addElement(1,sampleObj,'model');
d.addGroup('sample',sampleId);
d.delElement('botPlaten');
d.SET.Cx=tubeOuterR;
d.SET.Cy=discOuterL;
d.SET.Cz=tubeOuterR;
d.groupMat2Model({'sample'},1);

d.showB=2;
cla
d.showFilter('Group',{'tube','sample'},'aR');

save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);