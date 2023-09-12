clear;
fs.randSeed(1);%random model seed, 1,2,3...
B=obj_Box;%declare a box object
B.name='BoxFiber';
B.GPUstatus='off';%program will test the CPU and GPU speed, and choose the quicker one
B.ballR=0.01;
B.isShear=0;
B.isClump=0;%if isClump=1, particles are composed of several balls
B.distriRate=0.2;%define distribution of ball radius, 
B.sampleW=0.9;%width, length, height, average radius
B.sampleL=0.4;%when L is zero, it is a 2-dimensional model
B.sampleH=0.6;
B.BexpandRate=2;%boundary is 4-ball wider than 
B.PexpandRate=0;
B.type='botPlaten';%add a top platen to compact model
B.isSample=0;
B.setType();

%make objects
minBallR=B.ballR/2;
innerR=0.05;
layerNum=2;
Rrate=0.8;
ringObj=f.run('fun/makeRing.m',innerR,layerNum,minBallR,Rrate);
tubeObj=mfs.make3Dfrom2D(ringObj, B.sampleW/2,minBallR);
tubeObj=mfs.rotate(tubeObj,'XZ',90);%rotate the group along XZ plane
tube1Obj=mfs.move(tubeObj,B.sampleW/4,B.sampleL/2,B.sampleH/2);
tube2Obj=mfs.move(tubeObj,B.sampleW*3/4,B.sampleL/2,B.sampleH/2);
fiberObj=f.run('fun/make3DLine.m',[minBallR/2,B.sampleW-minBallR/2],[0,0],[0,0],minBallR,0.8);
fiberObj=mfs.move(fiberObj,0,B.sampleL/2,B.sampleH/2);

fiberAngle=[30,150,270]*pi/180;
rate=[0.99,0.99,0.99]*0.99;
fiberR1=ringObj.outerR+minBallR;
fiberY=fiberR1*cos(fiberAngle).*rate;
fiberZ=fiberR1*sin(fiberAngle).*rate;

fiber1Obj=mfs.move(fiberObj,0,fiberY(1),fiberZ(1));
fiber2Obj=mfs.move(fiberObj,0,fiberY(2),fiberZ(2));
fiber3Obj=mfs.move(fiberObj,0,fiberY(3),fiberZ(3));

%add the objects to the box model
B.buildInitialModel();d=B.d;
[tube1Id,tube2Id,fiber1Id,fiber2Id,fiber3Id]=d.addElement(1,{tube1Obj,tube2Obj,fiber1Obj,fiber2Obj,fiber3Obj});
d.addGroup('tube1',tube1Id);%add a new group
d.setClump('tube1');%set the pile clump
d.addGroup('tube2',tube2Id);%add a new group
d.setClump('tube2');%set the pile clump
d.addGroup('fiber1',fiber1Id);%add a new group
d.setClump('fiber1');%set the pile clump
d.addGroup('fiber2',fiber2Id);%add a new group
d.setClump('fiber2');%set the pile clump
d.addGroup('fiber3',fiber3Id);%add a new group
d.setClump('fiber3');%set the pile clump

d.delElement('botPlaten');
d=f.run('fun/setGroupId.m',d);
d.show('groupId');
xlswrite('abc.xls',d.aX);
%