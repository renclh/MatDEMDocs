%using functions to build objects, modify and import objects
clear;
%-----------step0: make object (struct data)------------
ballR=0.02;
hobObj=f.run('fun/makeHob.m',0.2,0.1,1,ballR,0.8);%see the function file about the input parameters
columnObj=f.run('fun/makeColumn.m',0.1,0.28,ballR,0.8);
netWidth=2;netHeight=2;cellW=0.1;cellH=0.1;
netObj=mfs.denseModel(0.8,@mfs.makeNet,netWidth, netHeight, cellW, cellH, ballR);

hobObj2=mfs.move(hobObj,netWidth/2+0.2,netHeight/2,0.8);
columnObj2=mfs.move(columnObj,netWidth/2-0.2,netHeight/2,0.8);
netObj2=mfs.rotate(netObj,'YZ',-90);
netObj2=mfs.move(netObj2,0,0,0.2);

allObj=mfs.combineObj(hobObj2,columnObj2,netObj2);%combine the objects

%fs.showObj(allObj);
%return;

%-----------step1: build model------------
B=obj_Box;%declare a box object
B.name='DropOnNet';
B.ballR=ballR;%element radius
B.sampleW=netWidth;%width, length, height
B.sampleL=netHeight;%when L is zero, it is a 2-dimensional model
B.sampleH=1;
B.isSample=0;%an empty box without sample elements
B.setType('botPlaten');%add a top platen to compact model
B.boundaryStatus=[0,0,0,0,1,0];
B.buildInitialModel();

d=B.d;
d.mo.setGPU('off');
[netId,hobId,columnId]=d.addElement(1,{netObj2,hobObj2,columnObj2});
d.addGroup('net',netId);
d.addGroup('hob',hobId);
d.addGroup('column',columnId);
d.setClump(netId);
d.setClump(hobId);
d.setClump(columnId);
d.delElement('botPlaten');
d.GROUP.groupProtect=[];
d.delElement('botB');

netX=d.mo.aX(d.GROUP.net);
netY=d.mo.aY(d.GROUP.net);
fixId=(netX==min(netX))|(netX==max(netX))|(netY==min(netY))|(netY==max(netY));
fixId=find(fixId);
d.addFixId('X',fixId);
d.addFixId('Y',fixId);
d.addFixId('Z',fixId);
d.setGroupId();
d.show('FixXId');d.show('groupId');

%-----------step2: assign material------------
matTxt=load('Mats\rubber.txt');%load material file
matTxt(1)=matTxt(1)/1;
Mats{1,1}=material('rubber',matTxt,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;%assign new material
d.groupMat2Model({'sample'},1);%apply the new material

%-----------step3: numerical simulation------------
d.mo.mVis(:)=0;
d.mo.isShear=0;

showType='mV';
figureNumber=d.show(showType);
d.figureNumber=figureNumber;
d.mo.setGPU('auto');
d.mo.dT=d.mo.dT*4;
totalCircle=50;
d.tic(totalCircle);
fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
for i=1:totalCircle
    d.balance('Standard',0.1);
    d.show(showType);
    pause(0.05);
    
    d.clearData(1);%clear data in d.mo
    save([fName num2str(i) '.mat']);
    d.calculateData();
end
%f.run('fun/makeGIF.m',fName,0,totalCircle,'mV');