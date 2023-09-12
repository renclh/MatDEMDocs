%set the material of the model
clear
load('TempModel/PorePermeability1.mat');
B.setUIoutput();%set output of message
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo

%----------set material of model
matTxt=load('Mats\RockHydro.txt');
Mats{1,1}=material('RockHydro',matTxt,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;
%----------end set material of model

%---------assign material to layers and balance the model
B.setPlatenFixId();
d.setGroupMat('sample','RockHydro');
d.groupMat2Model({'sample'});
d.balanceBondedModel0();
d.mo.bFilter(:)=false;
d.balance('Standard',1);
%---------end assign material to layers and balance the model1.	

%---------save the data
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Step2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();