%set the material of the model
clear
load('TempModel/BoxLandSubsidence1.mat');
B.setUIoutput();%set output of message
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo

%---------set material of model
matTxt=load('Mats\SoilLandSubsidence.txt');%material of soil
Mats{1,1}=material('Soil1',matTxt,B.ballR);
Mats{1,1}.Id=1;
matTxt2=load('Mats\Rock1.txt');
Mats{2,1}=material('Rock1',matTxt2,B.ballR);%material of rock
Mats{2,1}.Id=2;
d.Mats=Mats;
%---------end set material of model

%---------cut model and make layers
C=Tool_Cut(d);%cut the model
lSurf=load('slope/LandSubsidence.txt');%load the surface data
C.addSurf(lSurf);%add the surfaces to the cut
C.setLayer({'sample'},[1,2,3]);%set layers according geometrical data
gNames={'lefPlaten';'rigPlaten';'botPlaten';'layer1';'layer2'};
d.makeModelByGroups(gNames);%build new model using layer1 and 2
%set material of group
d.setGroupMat('layer1','Rock1');
d.setGroupMat('layer2','Soil1');
d.defineWallElement('layer1');%change rigid rock to wall
%d.show();
d.groupMat2Model({'layer1','layer2'});
%---------end cut model and make layers

%---------balance the model
d.balanceBondedModel0();
d.mo.bFilter(:)=true;
d.balance('Standard');
d.mo.bFilter(:)=true;
d.balance('Standard');
%---------end balance the model

%---------save data
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxModel2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();