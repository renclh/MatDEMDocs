load('TempModel/Screw1.mat');
ballR=B.ballR;
helixInnerR=ballR;
helixOuterR=0.1;
helixHeight=1;
circle=6;
Rrate=0.8;

B.d.mo.setGPU('off');
sampleObj=B.d.group2Obj('sample');%make struct object from a group
filter=mfs.getColumnFilter(sampleObj.X, sampleObj.Y, sampleObj.Z, 0, 0, helixOuterR*0.95, B.sampleH);
sampleObj=mfs.filterObj(sampleObj,filter);
objCenter=mfs.getObjCenter(sampleObj);
sampleObj.X=sampleObj.X-objCenter.x;
sampleObj.Y=sampleObj.Y-objCenter.y;

helixObj=f.run('fun/makeHelix.m',helixInnerR,helixOuterR,helixHeight,circle,ballR,Rrate);

figure;fs.showObj(helixObj);
return
tubeR=helixOuterR+ballR*Rrate;
tubeH=helixHeight;
tubeObj=mfs.makeTube2(tubeR,tubeH+ballR*(1-Rrate)*2,ballR*Rrate);
tubeObj.R=tubeObj.R/Rrate;


return
discObj=mfs.makeDisc(tubeR,ballR,Rrate);
%discObj.Z=discObj.Z-ballR;

rotateAngle=-90;
helixObj=mfs.rotate(helixObj,'XZ',rotateAngle);
tubeObj=mfs.rotate(tubeObj,'XZ',rotateAngle);
discObj=mfs.rotate(discObj,'XZ',rotateAngle);
sampleObj=mfs.rotate(sampleObj,'XZ',rotateAngle);

frame=mfs.getObjFrame(tubeObj);
baseH=frame.width*0.2;
helixObj=mfs.move(helixObj,-frame.left,-frame.front,-frame.bottom+baseH);
tubeObj=mfs.move(tubeObj,-frame.left,-frame.front,-frame.bottom+baseH);
discObj=mfs.move(discObj,-frame.left,-frame.front,-frame.bottom+baseH);
sampleObj=mfs.move(sampleObj,-frame.left,-frame.front,-frame.bottom+baseH);

%make a big box for the simulation
fs.randSeed(1);%random model seed, 1,2,3...
B=obj_Box;%declare a box object
B.name='Screw';
%--------------initial model------------
B.GPUstatus='auto';%program will test the CPU and GPU speed, and choose the quicker one
B.ballR=ballR;
B.isShear=0;
B.isClump=0;%if isClump=1, particles are composed of several balls
B.sampleW=frame.width+baseH;%width, length, height, average radius
B.sampleL=frame.length;%when L is zero, it is a 2-dimensional model
B.sampleH=frame.height+baseH;
B.type='botPlaten';%add a top platen to compact model
B.isSample=0;
%B.type='TriaxialCompression';
B.setType();
B.buildInitialModel();
d=B.d;
d.mo.setGPU('off');

matTxt1=load('Mats\rubber.txt');
matTxt1(1)=matTxt1(1)/100;
Mats{1,1}=material('rubber',matTxt1,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;

d.showB=3;
[helixId,tubeId,discId]=d.addElement(1,{helixObj,tubeObj,discObj},'wall');
d.addGroup('helix',helixId);%add a new group
d.addGroup('tube',tubeId);%add a new group
d.addGroup('disc',discId);%add a new group
sampleId=d.addElement(1,sampleObj);
d.addGroup('sample',sampleId);%add a new group
d.minusGroup('sample','helix',0.6);
d.minusGroup('sample','disc',0.6);
d.delElement(d.GROUP.botPlaten);
d.mo.setGPU('auto');
d.balance('Standard');

d.showFilter('SlideY',0.5,1,'aR');
%------------record data
d.mo.setGPU('off');
d.clearData(1);%clear dependent data in d
d.recordCalHour('BoxSlopeNet2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();