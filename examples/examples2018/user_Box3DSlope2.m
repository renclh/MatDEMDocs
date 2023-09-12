%set the material of the model
clear;
load('TempModel/3DSlope1.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo

%------------set the material of the model;
load('Mats\Mat_mxRock2.mat');%load a trained material
%you may use user_BoxMatTraining to train a material
Mats{1,1}=Mat_mxRock2;
Mats{1,1}.Id=1;
matTxt2=load('Mats\mxSoil.txt');%load a un-trained material file
Mats{2,1}=material('mxSoil',matTxt2,B.ballR);
Mats{2,1}.Id=2;
d.Mats=Mats;

%--------------redefine layers and apply new material
%because layer elements moved, the layers should be redefined.
d.addGroup('slopeBottom',d.GROUP.layer1);
d.protectGroup('slopeBottom','on');%protect the group, of which the element will not be removed
d.delGroup({'layer1';'layer2';'layer3';'layer4';'layer5'});
C.layerNum=0;
%original layer1 is changed to slopeBottom, and be protected, so new layer1
%is between surfaces 1 and 3
C.setLayer({'sample'},[2,3,4,5]);%set layers according to geometrical data
gNames={'layer1';'layer2';'layer3'};
d.makeModelByGroups(gNames);
d.setGroupMat('layer2','mxSoil');
d.groupMat2Model(gNames,1);

%d.showB=3;d.show('aR');return;
%-----------------define wall area to increase speed of code
sX=d.mo.aX(1:d.mNum);sY=d.mo.aY(1:d.mNum);

imH=302;imW=561;%height and width of image
%read the image and change the size,image is in black and white color
regionFilter=mfs.image2RegionFilter('slope/slopepack.png',imH,imW);%white is true
sFilter=mfs.applyRegionFilter(regionFilter,sX,sY);
sFilter=~sFilter;
sId=find(sFilter);
sId(sId>d.mNum)=[];
d.addGroup('slopeWall',sId);

d.defineWallElement('slopeWall');
d.protectGroup('slopeWall','on');
%-----------------end define wall area to increase speed of code
%d.showB=3;d.show('aR');return;
%---------------balance the model
d.balanceBondedModel0(0.5);
d.mo.mVis=d.mo.mVis*5;
d.balanceBondedModel(0.5);%bond all elements and balance the model
d.mo.setGPU('off');

%--------------balance model 2, cut the model to get final shape
d.delGroup({'layer1';'layer2';'layer3'});
C.layerNum=0;
C.setLayer({'sample'},[1,3,4]);%set layers according to geometrical data
C.setLayer({'sample'},[7,4]);%set layers according to geometrical data
gNames={'layer1';'layer2';'layer3'};
d.makeModelByGroups(gNames);

d.setGroupMat('layer2','mxSoil');
d.groupMat2Model(gNames,1);
d.mo.zeroBalance();
%d.showB=3;d.show('aR');return;
%----------------reduce friction and balance model

aKS=d.mo.aKS;
d.mo.aKS(:)=1;d.mo.setKNKS();%reduce the stiffness of element
d.balanceBondedModel0();
d.mo.aKS=aKS;d.mo.setKNKS();%restore the stiffness of element
d.mo.mVis=d.mo.mVis*5;
d.balanceBondedModel();

%-----------save the model
d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('Box3DSlope2Finish');
save(['TempModel/' B.name '2.mat'],'B','d','C');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();