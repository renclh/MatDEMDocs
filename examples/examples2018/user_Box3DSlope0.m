%-------------This file is used to create surface of model layers
clear;
r=10;%radius of element, in this example, it is between 5-20 m
surfPackNum=4;%number of surface element along depth direction
surfPackNum2=1;%additional surface element

botPackNum=1.5;topPackNum=1.5;%
load('slope/slopeSurface.mat');%you may use user_L3lpsXYZ2Surf.m to generate similar data
%Digital Elevation Model of model is saved in S, see Matlab commands
%"scatteredInterpolant" "meshgrid" "surf"
gSide=S.Y(2)-S.Y(1);
%--------------cut slope data;
cutX1=floor(250/gSide);cutX2=floor(150/gSide);%cut the digital elevation  data
cutY1=floor(400/gSide);cutY2=floor(300/gSide);
S.X=S.X(1+cutY1:end-cutY2,1+cutX1:end-cutX2);
S.Y=S.Y(1+cutY1:end-cutY2,1+cutX1:end-cutX2);
S.Z1=S.Z1(1+cutY1:end-cutY2,1+cutX1:end-cutX2);%Z1 is original height
S.Z2=S.Z2(1+cutY1:end-cutY2,1+cutX1:end-cutX2);%Z2 is the height after landslide
S.X=S.X-min(S.X(:));
S.Y=S.Y-min(S.Y(:));
S.dZ=S.Z2-S.Z1;
%--------------end cut slope data;

[imH,imW]=size(S.X);
S.Z=S.Z1;
S0min.X=S.X;S0min.Y=S.Y;
S0min.Z=min(S.Z1,S.Z2);
S0.X=S.X;S0.Y=S.Y;
S0.Z=S.Z1;

S2=S0;
oldSlopeT=30/3;
slopeOldFilter=mfs.image2RegionFilter('slope/slopeOld.png',imH,imW);
se1=strel('disk',40);%
slopeOldFilter2=imerode(slopeOldFilter,se1);
slopeOldFilter3=imerode(slopeOldFilter2,se1);
%imshow(slopeOldFilter3);return;
S2.Z(slopeOldFilter)=S2.Z(slopeOldFilter)-oldSlopeT;
S2.Z(slopeOldFilter2)=S2.Z(slopeOldFilter2)-oldSlopeT;
S2.Z(slopeOldFilter3)=S2.Z(slopeOldFilter3)-oldSlopeT;

S_bot=mfs.moveMeshGrid(S0min,-r*2*(surfPackNum+botPackNum));
%thickAreaFilter=mfs.loadImageRegion('slope/thickarea.png',imH,imW);
%S_bot.Z(~thickAreaFilter)=S0.Z(~thickAreaFilter)-2*r*2;
S1=mfs.moveMeshGrid(S_bot,r*2*botPackNum);

S_top=mfs.moveMeshGrid(S0,r*2*(topPackNum+surfPackNum2));
topRate=0.3;%add elements on top
dZ=max(S_top.Z(:))-min(S_top.Z(:));
topFilter=S_top.Z>max(S_top.Z(:))-dZ*topRate;
topAddH=100;
topZ=S_top.Z(topFilter);
dTopZ=topAddH*(topZ-min(topZ))/(dZ*topRate);

S_top.Z(topFilter)=S_top.Z(topFilter)+dTopZ;
S_top0=mfs.moveMeshGrid(S_top,-r*2*topPackNum);

S_source=S0;
S_source.Z=S.Z2;
sourceFilter=mfs.image2RegionFilter('slope/slopesource.png',imH,imW);
%imshow(sourceFilter);return;
S_source.Z(~sourceFilter)=max(S_source.Z(:))+100;
S_source.Z(sourceFilter)=S_source.Z(sourceFilter)-10;

V=S0;%original surface
surface(V.X,V.Y,V.Z,-1000*ones(size(V.X)));
hold all;
V=S_source;%slope source
%surface(V.X,V.Y,V.Z,mx.Z2-mx.Z1);
%surface(V.X,V.Y,S.Z2,S.Z2-S.Z1);
V=S1;%surface above bottom surface
%surface(V.X,V.Y,V.Z,50*ones(size(V.X)));
V=S2;%surface of bottom side of soil,soil2
%surface(V.X,V.Y,V.Z,1000*ones(size(V.X)));
V=S_bot;%bottom surface
%surface(V.X,V.Y,V.Z,0*ones(size(V.X)));
V=S_top;%top surface
%surface(V.X,V.Y,V.Z,10*ones(size(V.X)));
V=S_top0;%bottom side of top surface
%surface(V.X,V.Y,V.Z,30*ones(size(V.X)));

save('data/slopeSurface2.mat','S_bot','S_top','S_top0','S0','S1','S2','S_source','r');
%colorbar
fs.general3Dset();