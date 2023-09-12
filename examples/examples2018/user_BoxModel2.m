%set the material of the model
clear
load('TempModel/BoxModel1.mat');
B.setUIoutput();%set output of message
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo

%---------cut the model to make slope
C=Tool_Cut(d);%cut the model
lSurf=load('slope/layer surface.txt');%load the surface data
C.addSurf(lSurf);%add the surfaces to the cut
C.setLayer({'sample'},[1,2,3,4]);%set layers according geometrical data
gNames={'lefPlaten';'rigPlaten';'botPlaten';'layer1';'layer2';'layer3'};
d.makeModelByGroups(gNames);
%---------end cut the model to make slope

%----------set material of model
matTxt=load('Mats\Soil1.txt');
Mats{1,1}=material('Soil1',matTxt,B.ballR);
Mats{1,1}.Id=1;
matTxt2=load('Mats\Soil2.txt');
Mats{2,1}=material('Soil2',matTxt2,B.ballR);
Mats{2,1}.Id=2;
d.Mats=Mats;
%----------end set material of model

%---------assign material to layers and balance the model
d.setGroupMat('layer2','Soil2');
d.groupMat2Model({'sample','layer2'});
d.balanceBondedModel();
%---------end assign material to layers and balance the model

%---------save the data
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxModel2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();