%set the material of the model
clear
load('TempModel/BoxWave1.mat');
B.setUIoutput();%set the output
d=B.d;
d.calculateData();%calculate data
d.mo.setGPU('off');%close the GPU calculation
d.getModel();%get xyz from d.mo
%---------------delele elements on the top
mZ=d.mo.aZ(1:d.mNum);%get the Z of elements
sampleFilter=mZ>B.sampleH*0.9|mZ<B.sampleH*0.1;
d.delElement(find(sampleFilter));%delete elements according to id
d.mo.setGPU('off');

%--------------assign new material
matTxt=load('Mats\WeakRock.txt');%load material file
Mats{1,1}=material('WeakRock',matTxt,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;%assign new material
d.groupMat2Model({'sample'},1);%apply the new material
d.mo.mGZ(:)=0;%no gravitation
d.moveGroup('lefB',-B.sampleW*0.05,0,0);%move the lateral boundaries
d.moveGroup('rigB',B.sampleW*0.05,0,0);
d.removePrestress(0.1);%reduce the prestress
d.mo.setGPU('auto');
d.balance('Standard',2);%balance the model

d.show('mV');
d.clearData(1);%clear dependent data
d.recordCalHour('Step2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();