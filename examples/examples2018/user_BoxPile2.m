%set the material of the model
clear
load('TempModel/BoxPile1.mat');
B.setUIoutput();%set the output
d=B.d;
d.mo.setGPU('off');%close the GPU calculation
d.calculateData();%calculate data
d.getModel();%get xyz from d.mo
d.showB=2;
%---------------delele elements on the top
mZ=d.mo.aZ(1:d.mNum);%get the Z of elements
topLayerFilter=mZ>max(mZ)*0.7;
d.delElement(find(topLayerFilter));%delete elements according to id

%--------------assign new material
matTxt=load('Mats\soil1.txt');%load material file
Mats{1,1}=material('Soil1',matTxt,B.ballR);
Mats{1,1}.Id=1;
matTxt2=load('Mats\StrongRock.txt');
Mats{2,1}=material('StrongRock',matTxt2,B.ballR);
Mats{2,1}.Id=2;
d.Mats=Mats;%assign new material
d.groupMat2Model({'sample'},1);%apply the new material

%---------create a pile struct, pile.X .Y .Z. R
pileW=0.8;pileL=0;pileH=8;ballR=B.ballR;Rrate=0.7;
sampleId=d.GROUP.sample;%get the Id of sample
drivingDis=6;
sampleTop=max(d.mo.aZ(sampleId)+d.mo.aR(sampleId));%get the top side of sample

pile1=mfs.denseModel(0.8,@mfs.makeBox,pileW,pileL,pileH,ballR);%make a pile struct
pile1.Y(:)=0;%in a 2D model Y=0

%pile1.X=pile1.X+3.2;
%pile1.X=pile1.X+B.sampleW-pileH/2;pile1.Z=pile1.Z+B.sampleW/2;
pileId1=d.addElement('StrongRock',pile1);%mat Id, obj
d.addGroup('Pile1',pileId1);%add a new group
d.setClump('Pile1');%set the pile clump

d.moveGroup('Pile1',(B.sampleW-pileW)/2,0,sampleTop-drivingDis);%move the group
d.minusGroup('sample','Pile1',0.4);%remove overlap elements from sample

d.addFixId('X',d.GROUP.Pile1);%fix the X-coordinate of the pile

pile2=mfs.denseModel(0.5,@mfs.makeBox,pileH,pileL,pileW,ballR);%make a pile struct
pile2.Y(:)=0;%in a 2D model Y=0
pile2.X=pile2.X+B.sampleW-pileH/2;pile2.Z=pile2.Z+B.sampleW/2;
pileId2=d.addElement('StrongRock',pile2,'wall');%mat Id, obj
%fs.showObj(pile1);%show the new pile object
d.addGroup('Pile2',pileId2);%add a new group
d.setClump('Pile2');%set the pile clump
d.moveGroup('Pile2',1,0,2);%move the group
d.rotateGroup('Pile2','XZ',30);
d.minusGroup('sample','Pile2',0.5);%remove overlap elements from sample

d.removeGroupForce(d.GROUP.Pile2,d.GROUP.rigB);%remove force between Pile2 and right boundary
d.delElement(d.GROUP.topB);%delete top boundary
d.mo.bFilter(:)=false;%break all bonds
d.mo.zeroBalance();
d.resetStatus();
d.mo.setGPU('auto');

d.balance('Standard',4);%balance the force and energy in the model
%d.show('StessZZ');return;
d.connectGroup('sample');%connect all bonds
d.connectGroup('sample','Pile1');%connect soil and pile
d.mo.zeroBalance();
%d.balance('Standard',2);%balance the force and energy in the model

%------------record data
d.mo.setGPU('off');
d.clearData(1);%clear dependent data in d
d.recordCalHour('BoxPile2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();