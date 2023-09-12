%set the material of the model
clear
load('TempModel/BoxMixMat1.mat');
B.setUIoutput();%set output of message
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo
%------------------remove top elements
mZ=d.mo.aZ(1:d.mNum);
topLayerFilter=mZ>max(mZ)*0.85;%make filter for top layer
d.delElement(find(topLayerFilter));%delete top layer elements

%set material of model
matTxt=load('Mats\Rock1.txt');
Mats{1,1}=material('Rock1',matTxt,B.ballR);
Mats{1,1}.Id=1;
matTxt2=load('Mats\Rock2.txt');
Mats{2,1}=material('Rock2',matTxt2,B.ballR);
Mats{2,1}.Id=2;
d.Mats=Mats;%assigne materials to the model

%------------------------start mix material------------------------
groupId=d.GROUP.groupId;%groupId of all elements
%groupId of sample clump<-10, i.e. [-11,-12....], see d.GROUP.groupId
matContents=[9,1];%percentage of material 1 is 90%
matContents=matContents/(sum(matContents));

groupIdUnique=unique(groupId);
clumpId=groupIdUnique(groupIdUnique<-10);
clumpNum=length(clumpId);%get the number of clump in the sample

clumpFilter=groupId<-10;%filter of clump
matSeed=mod(groupId*pi^2,1);
mat1Filter=(matSeed<matContents(1))&clumpFilter;
mat2Filter=(matSeed>=matContents(1))&clumpFilter;
mat1Group=find(mat1Filter);
mat2Group=find(mat2Filter);

d.addGroup('Mat1Group',mat1Group);
d.addGroup('Mat2Group',mat2Group);
d.setGroupMat('Mat1Group','Rock1');
d.setGroupMat('Mat2Group','Rock2');
d.groupMat2Model({'Mat1Group','Mat2Group'});
%------------------------end start mix material------------------------
d.balanceBondedModel0(1);
mfs.reduceGravity(d,10);%reduce the gravity of element
d.balanceBondedModel0(1);
d.balance('Standard',5);
d.status.dispEnergy();%display the energy of the model

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxMixMat2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();