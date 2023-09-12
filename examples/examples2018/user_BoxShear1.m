clear
load('TempModel/BoxShear0.mat');
sampleR=B.SET.sampleR;
sampleH=B.SET.sampleH;
ballR=B.ballR;
Rrate=0.7;
tubeR=sampleR+ballR;
ringWidth=0.005;
innerWidth=sampleR*0.9;
innerHeight=sampleH/6;
botTubeH=sampleH/2+ballR*2;
boxType='wall';%boxType could be 'model' or 'wall', see element type in help

boxSampleId=d.getGroupId('sample');
sX=d.mo.aX(boxSampleId);sY=d.mo.aY(boxSampleId);sZ=d.mo.aZ(boxSampleId);
dipD=0;dipA=0;radius=sampleR-ballR;height=sampleH-ballR;
columnFilter=f.run('fun/getColumnFilter.m',sX,sY,sZ,dipD,dipA,radius+B.ballR,height);
d.addGroup('column',find(columnFilter));
sampleObj=d.group2Obj('column');

sampleObj=mfs.moveObj2Origin(sampleObj);
%------------------------make object of shearBox-----------------

botTubeObj=mfs.denseModel(Rrate,@mfs.makeTube,tubeR+(1-Rrate)*ballR*2,botTubeH,ballR);
discObj=mfs.denseModel(Rrate,@mfs.makeDisc,sampleR+(1-Rrate)*ballR*1,ballR);
botTubeObj=mfs.moveObj2Origin(botTubeObj);
discObj=mfs.moveObj2Origin(discObj);
[botTubeObj,botDiscObj]=mfs.alignObj('bottom',botTubeObj,discObj);
botBoxObj=mfs.combineObj(botTubeObj,botDiscObj);

botBoxObj=mfs.align2Value('bottom',botBoxObj,0);
botBoxTopZ=mfs.getObjEdge('top',botBoxObj);
botRingObj=mfs.makeRing2(tubeR+ballR-ballR*(1-Rrate)*2,tubeR+ballR+ringWidth,ballR,Rrate);
botRingObj=mfs.align2Value('top',botRingObj,botBoxTopZ);
botBoxObj=mfs.combineObj(botBoxObj,botRingObj);

if strcmp(B.SET.shearType,'torsional')
    planeObj=mfs.makeBox(innerWidth,innerHeight,ballR,ballR);
    planeObj=mfs.rotate(planeObj,'YZ',90);
    planeObj=mfs.move(planeObj,sampleR-innerWidth,0,ballR*2);
    planeObj=mfs.rotateCopy(planeObj,60,6);
    botBoxObj=mfs.combineObj(botBoxObj,planeObj);
end

topTubeObj=mfs.align2Value('bottom',botTubeObj,botBoxTopZ);
[topTubeObj,topPlatenObj]=mfs.alignObj('top',topTubeObj,botDiscObj);
topTubeBotZ=mfs.getObjEdge('bottom',topTubeObj);
topRingObj=mfs.align2Value('bottom',botRingObj,topTubeBotZ);
topTubeRingObj=mfs.combineObj(topTubeObj,topRingObj);

%------------------------end make object of shearBox-----------------
%make a big box for the simulation
fs.randSeed(1);%random model seed, 1,2,3...
B=obj_Box;%declare a box object
B.name='BoxShear';
%--------------initial model------------
B.GPUstatus='auto';%program will test the CPU and GPU speed, and choose the quicker one
B.ballR=ballR;
B.isShear=0;
B.isClump=0;%if isClump=1, particles are composed of several balls
B.distriRate=0.2;%define distribution of ball radius, 
B.sampleW=(sampleR+ringWidth)*2.5;
B.sampleL=(sampleR+ringWidth)*2.5;
B.sampleH=sampleH*1.2;
B.BexpandRate=2;%boundary is 4-ball wider than 
B.PexpandRate=0;
B.type='botPlaten';
B.isSample=0;
%B.type='TriaxialCompression';
B.setType();
B.SET.boxType=boxType;
B.buildInitialModel();
d=B.d;
d.mo.setGPU('off');
B.SET.sampleR=sampleR;
B.SET.sampleH=sampleH;

botBoxId=d.addElement(1,botBoxObj,boxType);
d.addGroup('botBox',botBoxId);%add a new group
d.setClump('botBox');
topTubeRingId=d.addElement(1,topTubeRingObj,boxType);
d.addGroup('topTubeRing',topTubeRingId);%add a new group
d.setClump('topTubeRing');
topPlatenId=d.addElement(1,topPlatenObj);
d.addGroup('topPlaten',topPlatenId);%add a new group
d.setClump('topPlaten');
d.addGroup('shearBox',[d.GROUP.botBox;d.GROUP.topTubeRing;d.GROUP.topPlaten]);
d.delElement('botPlaten');

d.moveGroup('shearBox',B.sampleW/2,B.sampleL/2,0);

boxSampleId=d.addElement(1,sampleObj);
d.addGroup('sample',boxSampleId);%add a new group
boxZ=d.mo.aZ(d.GROUP.shearBox);
d.moveGroup('sample',B.sampleW/2,B.sampleL/2,mean(boxZ));
d.minusGroup('sample','shearBox',0.5);

%d.showFilter('Group',{'shearBox'},'aR');return;

d.removeGroupForce(d.GROUP.topTubeRing,d.GROUP.topPlaten);
d.mo.zeroBalance();
fixId=[d.GROUP.botBox;d.GROUP.topTubeRing];
d.addFixId('X',[fixId;d.GROUP.topPlaten]);
d.addFixId('Y',[fixId;d.GROUP.topPlaten]);
d.addFixId('Z',fixId);

%------------return and save result--------------
B.gravitySediment(0.5);
B.compactSample(2);%input is compaction time
%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model
d.clearData(1);%clear dependent data
d.recordCalHour('Step1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
d.showFilter('SlideY',0.3,1,'StressXX');