%set the material of the model
clear
load('TempModel/BoxCrash1.mat');
B.setUIoutput();%set the output
d=B.d;
d.calculateData();%calculate data
d.mo.setGPU('off');%close the GPU calculation
d.getModel();%get xyz from d.mo

%---------------delete elements on the top
mZ=d.mo.aZ(1:d.mNum);%get the Z of elements
topLayerFilter=mZ>max(mZ)*0.5;
d.delElement(find(topLayerFilter));%delete elements according to id

%--------------assign new material
matTxt=load('Mats\WeakRock.txt');%load material file
Mats{1,1}=material('WeakRock',matTxt,B.ballR);%
Mats{1,1}.Id=1;
load('Mats/Mat_mxRock2.mat');%load the trained material
Mats{2,1}=Mat_mxRock2;
Mat_mxRock2.name='StrongRock';%set the name of the material
Mats{2,1}.Id=2;
d.Mats=Mats;%assign new material
d.groupMat2Model({'sample'},1);%apply the new material
%----------make disc sample------------
sampleId=d.GROUP.sample;
sX=d.aX(sampleId);sZ=d.aZ(sampleId);sR=d.aR(sampleId);
discCX=mean(sX);discCZ=mean(sZ);
discR=20;
discFilter=(d.aX-discCX).^2+(d.aZ-discCZ).^2<discR^2;
%d.setData();d.data.showFilter=discFilter;d.show('aR');
d.addGroup('Disc0',find(discFilter));%add a new group
discObj=d.group2Obj('Disc0');

discId=d.addElement('StrongRock',discObj);%mat Id, obj
d.addGroup('Disc',discId);%add a new group
disZ=max(sZ+sR)-min(discObj.Z-discObj.R);
d.moveGroup('Disc',0,0,disZ);%move the group

d.balanceBondedModel0();%balance the bonded model without friction
d.show('aMatId');
d.clearData(1);%clear dependent data
d.recordCalHour('Step2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();