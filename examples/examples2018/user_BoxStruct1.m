clear
load('TempModel/BoxStruct0.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo

%---------------delele elements
d.showFilter('SlideX',0.1,0.8);
d.showFilter('SlideY',0.1,0.8);
d.showFilter('SlideZ',0.1,0.6);
sFilter=d.data.showFilter(1:d.mNum);%showFilter result is recorded in d.data.showFilter
frameFilter=~sFilter;
d.delElement(find(frameFilter));%delete elements according to id

matTxt=load('Mats\Rock1.txt');
Mats{1,1}=material('Rock1',matTxt,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;%assigne materials to the model

%---------------define box
boxW=B.sampleW*0.8;
boxL=B.sampleL*0.8;
boxH=B.sampleH*0.7;

Rrate=0.8;
num=1;
dDis=B.ballR*2*Rrate;
diameter=B.ballR*2;
lefObj=mfs.denseModel(Rrate,@mfs.makeBox,B.ballR,boxL+diameter,boxH+diameter,B.ballR);
froObj=mfs.denseModel(Rrate,@mfs.makeBox,boxW+diameter,B.ballR,boxH+diameter,B.ballR);
botObj=mfs.denseModel(Rrate,@mfs.makeBox,boxW+diameter,boxL+diameter,B.ballR,B.ballR);
lefObj=mfs.expandAlong(lefObj,'Y',dDis,num);
lefObj=mfs.move(lefObj,0,B.ballR,B.ballR);

froObj=mfs.expandAlong(froObj,'X',dDis,num);
froObj=mfs.move(froObj,B.ballR,0,B.ballR);

botObj=mfs.expandAlong(botObj,'Y',dDis,num);
botObj=mfs.move(botObj,B.ballR,B.ballR,0);

rigObj=mfs.move(lefObj,boxW+diameter,0,0);
bacObj=mfs.move(froObj,0,boxL+diameter,0);

lefId=d.addElement(1,lefObj);
d.addGroup('lefP',lefId);
d.setClump('lefP');

froId=d.addElement(1,froObj);
d.addGroup('froP',froId);
d.setClump('froP');

botId=d.addElement(1,botObj);
d.addGroup('botP',botId);
d.setClump('botP');

rigId=d.addElement(1,rigObj);
d.addGroup('rigP',rigId);
d.setClump('rigP');

bacId=d.addElement(1,bacObj);
d.addGroup('bacP',bacId);
d.setClump('bacP');

G=d.GROUP;
boxId=[G.lefP;G.rigP;G.froP;G.bacP;G.botP];
d.addGroup('box',boxId);
%d.show('aR');return

f.run('fun/moveGroup2Center.m',B,'box');
f.run('fun/moveGroup2Center.m',B,'sample');

d.minusGroup('sample','box',0.5);
d.addFixId('X',d.GROUP.box);
d.addFixId('Y',d.GROUP.box);
d.addFixId('Z',d.GROUP.box);
%force between the elements will be removed in the calculation
d.removeGroupForce([d.GROUP.lefP;d.GROUP.rigP],[d.GROUP.botP;d.GROUP.froP;d.GROUP.bacP]);
d.removeGroupForce([d.GROUP.botP],[d.GROUP.froP;d.GROUP.bacP]);
d.mo.zeroBalance();

d.balanceBondedModel0(0.5);
d.mo.bFilter(:)=false;
d.balance('Standard',4);

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxStruct1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();