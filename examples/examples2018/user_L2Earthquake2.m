%initilization
clear
load('TempModel/BoxEarthquake1.mat');
B.setUIoutput();%set output of message
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo

%---------set material of model
matTxt=load('Mats\Soil3.txt');%material of soil
Mats{1,1}=material('Soil1',matTxt,B.ballR);
Mats{1,1}.Id=1;
matTxt2=load('Mats\Rock1.txt');
Mats{2,1}=material('Rock1',matTxt2,B.ballR);%material of rock
Mats{2,1}.Id=2;
d.Mats=Mats;
%---------end set material of model
%---------cut the model and make layers
C=Tool_Cut(d);%cut the model
lSurf=load('slope/Earthquake.txt');%load the surface data
C.addSurf(lSurf);%add the surfaces to the cut
C.setLayer({'sample'},[1,2,3,4]);%set layers according geometrical data
gNames={'lefPlaten';'rigPlaten';'botPlaten';'layer1';'layer2';'layer3'};
d.makeModelByGroups(gNames);%build new model
%---------end cut the model and make layers
%---------set material of group
d.setGroupMat('layer1','Rock1');
d.setGroupMat('layer2','Soil1');
d.setGroupMat('layer3','Rock1');
d.groupMat2Model({'layer1','layer2','layer3'},2);
%---------end set material of group

%---------balance the model
d.balanceBondedModel0();%balance the bonded model without friction

%---------define a block on left side of the model to generate wave
mX=d.mo.aX(1:d.mNum);
leftBlockId=find(mX<0.05*max(mX));%choose element Id of block
d.addGroup('LeftBlock',leftBlockId);%add a new group
d.setClump('LeftBlock');%set the block clump
d.mo.zeroBalance();
%---------end define a block on left side of the model to generate wave

%---------balance the model
d.mo.bFilter(:)=true;
d.mo.dT=d.mo.dT*4;
d.balance('Standard',1);
d.mo.bFilter(:)=true;
d.balance('Standard',0.5);
d.mo.dT=d.mo.dT/4;
%---------end balance the model

d.show('aMatId');%show material of model
%---------save data
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxModel2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();