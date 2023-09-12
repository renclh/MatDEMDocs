%converting scattered XYZ data to digital elevation model, which can be
%used to define a surface and to cut discrete element model
clear;
d1=load('slope/XYZData.txt');%scattered XYZ data

X1=d1(:,1);Y1=d1(:,2);Z1=d1(:,3);
[X1,Y1]=mfs.rotateIJ(X1,Y1,90);%rotate the surface data
x1=min(X1);x2=max(X1);%find the span of the data
y1=min(Y1);y2=max(Y1);

%make function for scattered data, see Matlab scatteredInterpolant
F1=scatteredInterpolant(X1,Y1,Z1,'natural','nearest');
gSide=20;%side of grid
[gX,gY]=meshgrid(x1:gSide:x2,y1:gSide:y2);%X, Y mesh coordinates
gZ=F1(gX,gY);%calculate Z by using function of scattered data

figure
surface(gX,gY,gZ,gZ);
fs.general3Dset();
view(120,30);