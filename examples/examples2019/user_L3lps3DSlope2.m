%set the material of the model
clear;
load('TempModel/lps_3DSlope1.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo

%------------set the material of the model;
matTxt2=load('Mats\lpsSoil.txt');%load a un-trained material file
Mats{1,1}=material('lpsSoil',matTxt2,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;

%--------------redefine layers and apply new material
%because layer elements moved, the layers should be redefined.
d.protectGroup('botShell','on');%protect the group, of which the element will not be removed in makeModelByGroups
gNames={'slopeBody','addedBody','topShell'};
d.delGroup(gNames);
%original layer1 is changed to slopeBottom, and be protected, so new layer1
%is between surfaces 1 and 3
gNames={'slopeBody','addedBody'};
ID=C.SurfId;
C.setLayer({'sample'},[ID.S_bot0,ID.S0,ID.S_top0],gNames);%set layers according to geometrical data
d.makeModelByGroups(gNames);

%d.showB=3;d.show('aR');return;
%-----------------define wall area to increase speed of code
sX=d.mo.aX(1:d.mNum);sY=d.mo.aY(1:d.mNum);

imH=256;imW=596;%height and width of image
%read the image and change the size,image is in black and white color
regionFilter=mfs.image2RegionFilter('slope/lps_slopepack.png',imH,imW);%white is true
sFilter=mfs.applyRegionFilter(regionFilter,sX,sY);
sFilter=~sFilter;
sId=find(sFilter);
sId(sId>d.mNum)=[];
d.addGroup('slopeWall',sId);

d.defineWallElement('slopeWall');
%-----------------end define wall area to increase speed of code
%d.showB=3;d.show('aR');return;
%---------------balance the model
d.balanceBondedModel0(0.5);
d.mo.mVis=d.mo.mVis*5;
d.balanceBondedModel(0.5);%bond all elements and balance the model
d.mo.setGPU('off');

%--------------balance model 2, cut the model to get final shape
C.layerNum=0;
ID=C.SurfId;
C.setLayer({'sample'},[ID.S_bot,ID.S0],{'slopeBody'});%set layers according to geometrical data
C.setLayer({'sample'},[ID.S_source,ID.S0],{'slopeSource'});%set layers according to geometrical data
C.setLayer({'slopeWall'},[ID.S_bot,ID.S0],{'slopeWall'});%set layers according to geometrical data
gNames={'slopeBody';'slopeSource';'slopeWall'};

d.makeModelByGroups(gNames);

%---------------added in MatDEM_v1.42, reduce wall to shell
clearWall=1;%if the code result in error, change it to 0
if clearWall==1
    %--------------------------added in MatDEM_v1.42
    S0_shell=mfs.moveMeshGrid(C.SurfData.S0,-C.SET.ballR*2*C.SET.shellTNum);
    %--------------------------end added in MatDEM_v1.42
    C.addSurf(S0_shell,'S0_shell');
    
    delFilter=false(d.aNum,1);
    delFilter(d.GROUP.slopeWall)=true;
    delFilter(d.GROUP.botShell)=true;
    
    dilatedTNum=C.SET.shellTNum;
    se1=strel('disk',ceil(B.ballR*2*dilatedTNum*imW/B.sampleW));%dilated pixel
    protectedRegionFilter=imdilate(regionFilter,se1);
    protectedFilter=mfs.applyRegionFilter(protectedRegionFilter,d.mo.aX,d.mo.aY);
    
    ID=C.SurfId;
    C.setLayer({'slopeWall','botShell'},[ID.S0_shell,ID.S0],{'surfaceShell'});%set layers according to geometrical data
    protectedFilter(d.GROUP.surfaceShell)=true;
    
    delFilter(protectedFilter)=false;
    d.delElement(find(delFilter));
end
%---------------end added in MatDEM_v1.42
d.setGroupMat('slopeBody','lpsSoil');
d.groupMat2Model(gNames,1);
d.mo.zeroBalance();
%d.showB=3;d.show('Displacement');return;
%----------------reduce friction and balance model

visRate=B.sampleH/C.SET.sampleThickness;
mVis=d.mo.mVis;
aKS=d.mo.aKS;
d.mo.aKS(:)=1;d.mo.setKNKS();%reduce the stiffness of element
d.balanceBondedModel0();
d.mo.aKS=aKS;d.mo.setKNKS();%restore the stiffness of element
d.mo.mVis=d.mo.mVis*visRate;
d.balanceBondedModel();

d.mo.mVis=d.mo.mVis*C.SET.shellTNum;
for i=1:5
d.balance(400);
d.mo.mVX(:)=0;d.mo.mVY(:)=0;d.mo.mVZ(:)=0;
d.mo.bFilter(:)=true;
d.mo.zeroBalance();
end
d.mo.mVis=mVis;

%-----------save the model
d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('Box3DSlope2Finish');
save(['TempModel/' B.name '2.mat'],'B','d','C','-v7.3');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat'],'-v7.3');
d.calculateData();