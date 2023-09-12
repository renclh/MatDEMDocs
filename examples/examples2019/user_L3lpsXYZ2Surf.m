%converting scattered XYZ data to digital elevation model, which can be
%used to define a surface and to cut discrete element model
clear;
d1=load('slope/lps1.txt');%scattered XYZ data before sliding
d2=load('slope/lps2.txt');%scattered XYZ data after sliding
gSide=5;%side of grid
baseZ=1150;%the base level of the data

%defined the coordinates of the digital elevation data
X1=d1(:,1);Y1=d1(:,2);Z1=d1(:,3)-baseZ;
X2=d2(:,1);Y2=d2(:,2);Z2=d2(:,3)-baseZ;
angle=-70;%rotate the data
[X1,Y1]=mfs.rotateIJ(X1,Y1,angle);
[X2,Y2]=mfs.rotateIJ(X2,Y2,angle);

%move the data
minX=min(X1);minY=min(Y1);
X1=X1-minX;Y1=Y1-minY;
X2=X2-minX;Y2=Y2-minY;
minX=min(X1);minY=min(Y1);
maxX=max(X1);maxY=max(Y1);

%interpret 3D surface according to the data
F1=scatteredInterpolant(X1,Y1,Z1,'natural','nearest');
F2=scatteredInterpolant(X2,Y2,Z2,'natural','nearest');

%get the mesh of the surface
[gX,gY]=meshgrid(minX:gSide:maxX,minY:gSide:maxY);
gZ1=F1(gX,gY);
gZ2=F2(gX,gY);
dgZ=gZ2-gZ1;
S.X=gX;S.Y=gY;
S.Z1=gZ1;S.Z2=gZ2;
save('TempModel/lps_Slope.mat');

figure
surface(gX,gY,gZ1,dgZ);
fs.general3Dset();
colorbar