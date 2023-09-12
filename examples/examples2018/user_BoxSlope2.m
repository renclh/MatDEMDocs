%step1: packing the elements
clear;
load('TempModel/BoxSlope1.mat');
B.d.mo.setGPU('off');
packBallR=B.ballR;%record the ballR of the small box block
packBoxObj=B.d.group2Obj('sample');%make struct object from a group

%make a big box for the simulation
fs.randSeed(1);%random model seed, 1,2,3...
B=obj_Box;%declare a box object
B.name='BoxSlope';
%--------------initial model------------
B.GPUstatus='auto';%program will test the CPU and GPU speed, and choose the quicker one
B.ballR=packBallR;
B.isShear=0;
B.isClump=0;%if isClump=1, particles are composed of several balls
B.distriRate=0.2;%define distribution of ball radius, 
B.sampleW=6;%width, length, height, average radius
B.sampleL=4;%when L is zero, it is a 2-dimensional model
B.sampleH=3;
B.BexpandRate=2;%boundary is 4-ball wider than 
B.PexpandRate=0;
B.type='botPlaten';%add a top platen to compact model
B.isSample=0;
%B.type='TriaxialCompression';
B.setType();
B.buildInitialModel();
d=B.d;
d.mo.setGPU('off');%close GPU when modifing the model
d.showB=3;
d.delElement('topB');%remove top boundary
%d.show('aR');return;
slopeW=3;slopeL=B.sampleL;slopeH=B.ballR;
slope=mfs.denseModel(0.8,@mfs.makeBox,slopeW,slopeL,slopeH,B.ballR);%make a pile struct
slopeId=d.addElement(1,slope,'boundary');%add a slope boundary
d.addGroup('slope',slopeId);%add a new group
rotateX=max(d.aX(d.GROUP.slope));rotateZ=max(d.aZ(d.GROUP.slope));
d.rotateGroup('slope','XZ',-30,rotateX,0,rotateZ);%rotate the group along XZ plane
d.moveGroup('slope',-min(d.aX(d.GROUP.slope)),0,-min(d.aZ(d.GROUP.slope)));%move the slope

%import a regular packing box on the top right side of the model
smallBoxW=slopeW/4;
smallBox=mfs.denseModel(1.1,@mfs.makeBox,smallBoxW,smallBoxW,smallBoxW,B.ballR);%make a box struct
boxId=d.addElement(1,smallBox);
d.addGroup('box',boxId);%add a new group
d.moveGroup('box',B.sampleW*3/4,B.sampleL*1/4,B.sampleH*2/4);

%import the packed box (from step 1) on the top left side of the model
boxObjId=d.addElement(1,packBoxObj);%add regular model elements (not boundary)
d.addGroup('boxObj',boxObjId);%add a new group
d.setClump();%d.GROUP.groupId<-10 will be clump
d.moveGroup('boxObj',B.sampleW/8,B.sampleL*1/2,B.sampleH*2/4);
d.delElement('botPlaten');%remove bottom platen
d.show('aR');

%------------record data
d.mo.setGPU('off');
d.clearData(1);%clear dependent data in d
d.recordCalHour('BoxSlope2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();