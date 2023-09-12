%-------------This file is used to create surface of model layers
%-----basic setup of the layer surface
clear;
ballR=15;%radius of element, it is between 5-20 m. default value is 5, use 15 to increase speed
additionalDepth=15;%determine additional elements
surfPackNum=ceil(additionalDepth/(ballR*2));%number of surface element along depth direction

surfPackNum2=1;%additional surface element
shellTNum=6;%thickness of wall elements
botPackNum=2;
topPackNum=1.5;%elements of bottom and top shell
%-----end basic setup of the layer surface

%------------record the basic setup parameters
C=Tool_Cut();%use the tool to cut sample and get layers
C.SET.additionalDepth=additionalDepth;%additional elements
C.SET.surfPackNum=surfPackNum;%number of surface element along depth direction

C.SET.surfPackNum2=surfPackNum2;%additional surface element
C.SET.shellTNum=shellTNum;%thickness of wall elements
C.SET.botPackNum=botPackNum;
C.SET.topPackNum=topPackNum;%elements of bottom and top shell
C.SET.ballR=ballR;
%------------end record the basic setup parameters

load('TempModel/lps_Slope.mat');%run user_L3lpsXYZ2Surf.m to get the data
%Digital Elevation Model of model is saved in S, see Matlab commands
%"scatteredInterpolant" "meshgrid" "surf"
gSide=S.Y(2)-S.Y(1);
%--------------cut slope data;
cutX1=floor(0/gSide);cutX2=floor(120/gSide);%cut the digital elevation  data
cutY1=floor(160/gSide);cutY2=floor(200/gSide);
S.X=S.X(1+cutY1:end-cutY2,1+cutX1:end-cutX2);
S.Y=S.Y(1+cutY1:end-cutY2,1+cutX1:end-cutX2);
S.Z1=S.Z1(1+cutY1:end-cutY2,1+cutX1:end-cutX2);%Z1 is original height
S.Z2=S.Z2(1+cutY1:end-cutY2,1+cutX1:end-cutX2);%Z2 is the height after landslide
S.X=S.X-min(S.X(:));
S.Y=S.Y-min(S.Y(:));
S.dZ=S.Z2-S.Z1;
%--------------end cut slope data;
S0.X=S.X;S0.Y=S.Y;S0.Z=S.Z1;
S0.name='S0';
S0min=S;S0min.name='S0min';
S0min.Z=min(S.Z1,S.Z2);

S_bot=mfs.moveMeshGrid(S0min,-ballR*2*(botPackNum+surfPackNum));
S_bot.name='Sbot';
S_bot0=mfs.moveMeshGrid(S_bot,ballR*2*botPackNum);%i.e. S1 of previous code
S_bot0.name='Sbot0';

S_top=mfs.moveMeshGrid(S0,ballR*2*(topPackNum+surfPackNum2));
S_top.name='Stop';
topRate=0.3;%add elements on top
dZ=max(S_top.Z(:))-min(S_top.Z(:));
topFilter=S_top.Z>max(S_top.Z(:))-dZ*topRate;
topAddH=100;
topZ=S_top.Z(topFilter);
dTopZ=topAddH*(topZ-min(topZ))/(dZ*topRate);
S_top.Z(topFilter)=S_top.Z(topFilter)+dTopZ;

S_top0=mfs.moveMeshGrid(S_top,-ballR*2*topPackNum);
S_top0.name='Stop0';

S_source=S0;
S_source.Z=S.Z2;
[imH,imW]=size(S.X);
sourceFilter=mfs.image2RegionFilter('slope/lps_slopesource.png',imH,imW);
%imshow(sourceFilter);return;
S_source.Z(~sourceFilter)=max(S_source.Z(:))+100;
S_source.Z(sourceFilter)=S_source.Z(sourceFilter)-ballR;
S_source.name='Ssource';

C.addSurf(S_bot,'S_bot');
C.addSurf(S_bot0,'S_bot0');
C.addSurf(S0,'S0');
C.addSurf(S_top0,'S_top0');
C.addSurf(S_top,'S_top');
C.addSurf(S_source,'S_source');
C.addSurf(S0min,'S0min');

C.SET.sampleThickness=max(abs(S.dZ(:)))+additionalDepth;
C.SET.S=S;

V=S_source;surface(V.X,V.Y,S.Z2,S.Z2-S.Z1);fs.general3Dset();colorbar

save('TempModel/lps_slopeSurface2.mat','C');