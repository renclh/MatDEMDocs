%-------------------user_mxSlope1.m;
%build the geometrical model;
clear;
load('data/slopeSurface2.mat');
fs.randSeed(1);%build random model
B=obj_Box;%build a box object
B.name='3DSlope';
%--------------initial model------------
B.GPUstatus='auto';
boxWidth=2800;boxLength=1500;boxHeight=1800;ballR=r;
distriRate=0.2;%define distribution of ball radius, 
isClump=0;
%--------------initial model------------;
B.isUI=1;%when run the code in UI_command, isUI=1
B.ballR=ballR;
B.isClump=isClump;
B.distriRate=distriRate;
B.sampleW=boxWidth;
B.sampleL=boxLength;
B.sampleH=boxHeight;
B.platenStatus(:)=0;%no platen in the model
B.buildModel();
B.createSample();%create balls in the box
B.sample.R=B.sample.R*2^(1/12);%R deviation between close packing and cube packing is 2^(1/6)
S_Bbot=S_bot;
S_Bbot.Z=S_Bbot.Z-ballR*4;
S_Btop=S_top;%top limit of boundary
S_Btop.Z=S_Btop.Z+1000;%boundary limit greater
B.addSurf(S_bot);%add the bottom surface
B.addSurf(S_top);%add the top surface

B.addSurf(S_Bbot);%add the bot surface of boundary
B.addSurf(S_Btop);%add the top surface of boundary
B.cutGroup({'sample','botB','topB'},1,2);%cut sample and remove top boundary
B.cutGroup({'lefB','rigB','froB','bacB'},3,4);

B.finishModel();%built the geometric model
B.setSoftMat();%set soft balls to increase the speed of computing

%-------------end initial parameters and build model--------------;
%------------generate random-packing balls-------------;
B.d=B.exportModel();%tranform model data to build object
B.d.mo.isShear=0;
%B.R=B.R*0.5;B.show();

d=B.d;d.showB=1;%d.breakGroup('sample');d.breakGroup('lefPlaten');
%d.show('aR');return

C=Tool_Cut(d);%use the tool to cut sample and get layers
C.addSurf(S_bot);
C.addSurf(S1);
C.addSurf(S2);
C.addSurf(S0);
C.addSurf(S_top0);
C.addSurf(S_top);
C.addSurf(S_source);
C.setLayer({'sample'},[1,2,3,4,5,6]);%set layers according geometrical data
%layer1 is between surface 1 and 2, etc

gNames={'layer1';'layer2';'layer3';'layer4';'layer5'};
d.makeModelByGroups(gNames);%make the model by using the layers.
d.defineWallElement('layer1');
d.mo.aR(d.GROUP.layer1)=B.ballR*1.3;

mo=d.mo;
mo.isFix=1;%fix coordinates;
gId_top=d.getGroupId('layer5');%get element Id of group
mo.FixXId=gId_top;%fix X coordinate
mo.FixYId=gId_top;
mo.FixZId=gId_top;

nBall=d.mo.nBall;
bcFilter=sum(nBall>d.mNum&nBall~=d.aNum,2)>0;%boundary connected ball filter
gFilter=zeros(size(bcFilter));
gFilter(gId_top)=1;
mo.aR(gId_top)=B.ballR;
mo.aR(gFilter&(~bcFilter))=B.ballR*1.3;%not a boundary connected ball
d.setClump('layer5');

%d.show('aR');return;

B.uniformGRate=1;%the parameter used in B.gravitySediment
B.gravitySediment(0.5);
d.mo.FixZId=[];%unfix all Z coordinates

d.mo.dT=d.mo.dT*4;
d.balance('Standard');
d.mo.dT=d.mo.dT/4;

%--------------end initial model------------;
%B.compactSample(6);%input is compaction time;
%------------return and save result--------------;
d.status.dispEnergy();%display the energy of the model;
d.clearData(1);%clear dependent data
d.recordCalHour('Box3DSlope1Finish');
save(['TempModel/' B.name '1.mat'],'B','d','C');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();