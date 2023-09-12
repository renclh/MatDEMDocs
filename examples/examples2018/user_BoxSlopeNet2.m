%step1: packing the elements
clear;
load('TempModel/BoxSlopeNet1.mat');
B.d.mo.setGPU('off');
packBallR=B.ballR;%record the ballR of the small box block
packBoxObj=B.d.group2Obj('sample');%make struct object from a group
packBoxObj=mfs.moveObj2Origin(packBoxObj);
sphereObj=mfs.cutSphereObj(packBoxObj,B.sampleW/2-B.ballR);
sphereObj2=mfs.cutSphereObj(packBoxObj,B.sampleW/3-B.ballR);
boxObj=mfs.cutBoxObj(packBoxObj,B.sampleW/2,B.sampleW/2.5,B.sampleW/3);

%make a big box for the simulation
fs.randSeed(1);%random model seed, 1,2,3...
B=obj_Box;%declare a box object
B.name='BoxSlopeNet';
%--------------initial model------------
B.GPUstatus='auto';%program will test the CPU and GPU speed, and choose the quicker one
B.ballR=packBallR;
B.isShear=0;
B.isClump=0;%if isClump=1, particles are composed of several balls
B.distriRate=0.2;%define distribution of ball radius, 
B.sampleW=7;%width, length, height, average radius
B.sampleL=4;%when L is zero, it is a 2-dimensional model
B.sampleH=4;
B.BexpandRate=2;%boundary is 4-ball wider than 
B.PexpandRate=0;
B.type='botPlaten';%add a top platen to compact model
B.isSample=0;
%B.type='TriaxialCompression';
B.setType();
B.buildInitialModel();
d=B.d;
d.mo.setGPU('off');
d.showB=3;
cellW=B.sampleL/10;
cellH=B.sampleL/10;
netObj=mfs.denseModel(0.8,@mfs.makeNet,B.sampleL,B.sampleL/3,cellW,cellH,B.ballR);
fs.showObj(netObj);
netId=d.addElement(1,netObj);%add a slope boundary
d.addGroup('net',netId);%add a new group
d.rotateGroup('net','XY',90,0,0,0);%rotate the group along XZ plane
d.rotateGroup('net','XZ',180);%rotate the group along XZ plane
%@@@@@@@@@@@@@@@@@add dZ here 
d.moveGroup('net',B.sampleW*0.8,0,0);
d.setClump('net');
%find the boundary of the net and fix them
netX=d.mo.aX(netId);netY=d.mo.aY(netId);netZ=d.mo.aZ(netId);
yFilter=(netY==min(netY)|netY==max(netY));
zFilter=(netZ==min(netZ));
netBoundaryFilter=yFilter|zFilter;
boundaryNetId=netId(netBoundaryFilter);
d.addFixId('X',boundaryNetId);%fix the X-coordinate
d.addFixId('Y',boundaryNetId);
d.addFixId('Z',boundaryNetId);

%d.show('aR');return;
slopeW=6;slopeL=B.sampleL;slopeH=B.ballR;
slope=mfs.denseModel(0.6,@mfs.makeBox,slopeW,slopeL,slopeH,B.ballR);%make a pile struct
slopeId=d.addElement(1,slope,'boundary');%add a slope boundary
d.addGroup('slope',slopeId);%add a new group
rotateX=max(d.aX(d.GROUP.slope));rotateZ=max(d.aZ(d.GROUP.slope));
d.rotateGroup('slope','XZ',-30,rotateX,0,rotateZ);%rotate the group along XZ plane
d.moveGroup('slope',-min(d.aX(d.GROUP.slope)),0,-min(d.aZ(d.GROUP.slope)));%move the slope

% slopeW=6/4;slopeL=B.sampleL;slopeH=B.ballR;
% slope=mfs.denseModel(0.6,@mfs.makeBox,slopeW,slopeL,slopeH,B.ballR);%make a pile struct
% slopeId=d.addElement(1,slope,'boundary');%add a slope boundary
% d.addGroup('step',slopeId);%add a new group
% rotateX=max(d.aX(d.GROUP.slope));rotateZ=max(d.aZ(d.GROUP.slope));
% d.moveGroup('step',B.sampleW*0.4/2,0,B.sampleH*0.8/2);%move the slope

%import the packed box (from step 1) on the top left side of the model
sphereObjId=d.addElement(1,sphereObj);%add regular model elements (not boundary)
d.addGroup('sphere',sphereObjId);%add a new group
d.moveGroup('sphere',B.sampleW/8,B.sampleL*1/2,B.sampleH*3.05/4);
d.setClump('sphere');

sphereObjId=d.addElement(1,sphereObj2);%add regular model elements (not boundary)
d.addGroup('sphere2',sphereObjId);%add a new group
d.moveGroup('sphere2',B.sampleW*1.7/8,B.sampleL*1.38/4,B.sampleH*3.05/4);
d.setClump('sphere2');

boxObjId=d.addElement(1,boxObj);%add regular model elements (not boundary)
d.addGroup('box',boxObjId);%add a new group
%d.rotateGroup('box','XZ',10);
d.moveGroup('box',B.sampleW/8,B.sampleL*1/4,B.sampleH*2.84/4);
d.setClump('box');

d.delElement('botPlaten');%remove bottom platen
d.show('StressZZ');
%------------record data
d.mo.setGPU('off');
d.clearData(1);%clear dependent data in d
d.recordCalHour('BoxSlopeNet2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();