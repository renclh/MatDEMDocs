%-------------------user_mxSlope1.m;
%build the geometrical model;
clear;
load('TempModel/lps_slopeSurface2.mat');

fs.randSeed(1);%build random model
B=obj_Box;%build a box object
B.name='lps_3DSlope';
%--------------initial model------------
B.GPUstatus='auto';
S_top=C.SurfData.S_top;
boxWidth=max(S_top.X(:));
boxLength=max(S_top.Y(:));
boxHeight=max(S_top.Z(:))*1.1;%increase the height of the model
ballR=C.SET.ballR;
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
%B.SET.shellHRate=0.1;%record the ratio of shell height to the height of the model
B.buildModel();
B.createSample();%create balls in the box
B.sample.R=B.sample.R*2^(1/12);%R deviation between close packing and cube packing is 2^(1/6)
S_Bbot=C.SurfData.S_bot;
S_Bbot.Z=S_Bbot.Z-ballR*4;
S_Btop=C.SurfData.S_top;%top limit of boundary
S_Btop.Z=S_Btop.Z+(max(S_top.Z)-min(S_top.Z))*0.8;%boudary limit greater

B.addSurf(C.SurfData.S_bot);%add the bottom surface
B.addSurf(C.SurfData.S_top);%add the top surface

B.addSurf(S_Bbot);%add the bot surface of boundary
B.addSurf(S_Btop);%add the top surface of boundary
B.cutGroup({'sample','botB','topB'},1,2);%cut sample and remove top platen
B.cutGroup({'lefB','rigB','froB','bacB'},3,4);

B.finishModel();%built the geometric model
B.setSoftMat();%set soft balls to increase the speed of computing

%-------------end initial parameters and build model--------------;
%------------generate random-packing balls-------------;
B.d=B.exportModel();%tranform model data to build object
B.d.mo.isShear=0;
%B.R=B.R*0.5;B.show();

d=B.d;d.showB=1;%d.breakGroup('sample');d.breakGroup('lefPlaten');
%d.show('aR');
%return
C.d=d;
gNames={'botShell','slopeBody','addedBody','topShell'};
I=C.SurfId;
C.setLayer({'sample'},[I.S_bot,I.S_bot0,I.S0,I.S_top0,I.S_top],gNames);%set layers according geometrical data
%layer1 is between surface 1 and 2, etc
d.makeModelByGroups(gNames);%make the model by using the layers.
%defined bottom shell
d.defineWallElement('botShell');
d.mo.aR(d.GROUP.botShell)=B.ballR*1.4;

%--------------defined top shell
mo=d.mo;
mo.isFix=1;%fix coordinates;
gId_top=d.getGroupId('topShell');%get element Id of group
mo.FixXId=gId_top;%fix X coordinate
mo.FixYId=gId_top;
mo.FixZId=gId_top;

nBall=d.mo.nBall;
bcFilter=sum(nBall>d.mNum&nBall~=d.aNum,2)>0;%boundary connected ball filter
gFilter=false(size(bcFilter));
gFilter(gId_top)=true;
mo.aR(gId_top)=B.ballR;
mo.aR(gFilter&(~bcFilter))=B.ballR*1.3;%not a boundary connected ball
d.setClump('topShell');
%--------------end defined top shell

%d.show('StressZZ');
%return;

B.uniformGRate=1;%the parameter used in B.gravitySediment
sampleRate=C.SET.sampleThickness/B.sampleH;
B.gravitySediment(sampleRate);
d.mo.FixZId=[];%unfix all Z coordinates
%d.show();return;

d.mo.dT=d.mo.dT*4;%increase the step time to increase the computing speed
d.balance('Standard',sampleRate*2);
d.mo.dT=d.mo.dT/4;
%------------return and save result--------------;
d.status.dispEnergy();%display the energy of the model;
d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('Step1Finished');
save(['TempModel/' B.name '1.mat'],'B','d','C','-v7.3');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat'],'-v7.3');
d.calculateData();