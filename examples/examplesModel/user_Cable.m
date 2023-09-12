%the code shows how to make noodles object from 2D disc
%step 1.1: define the parameters of modeling
clear;
dAngle1=360/14;%rotation angle of disc in each copy
curveR=0.003;
curveH=0.02;
circle=5;
discR=0.001;
ballR=0.00025;
dDis=ballR*1.2;%displacement of disc in each copy

Lwidth=ballR*6;
Lheight=ballR*6;
dAngle2=10;%rotation angle of L shape in each copy

%step 1.2: define the path of the noodles
t=0:0.01:(circle*2*pi);
X1=curveR*sin(t);%path X, Y, Z
Y1=curveR*cos(t);
Z1=curveH*(t/max(t));
%plot3(X1,Y1,Z1);axis equal;%show the path

t=0:0.01:(circle*2*pi);
X2=curveR*sin(t);%path X, Y, Z
Y2=curveR*cos(t);
Z2=curveH*(t/max(t));
plot3(X2,Y2,Z2);axis equal;%show the path

%step 1.3: make 3D noodles object according to a disc and a path
discObj0=f.run('fun/makeDisc.m',discR,ballR);%define the basic disc
%allObj=mfs.make3DalongPath(discObj0,X,Y,Z,dDis,dAngle);
allDiscObj=f.run('fun/make3DalongPath.m',discObj0,X1,Y1,Z1,dDis,dAngle1);

Rrate=0.8;
LObj=mfs.makeLShape(Lwidth, Lheight, ballR*0.8);
LObj=mfs.rotate(LObj,'YZ',-90);
LObj=mfs.moveObj2Origin(LObj);
LObj.R=LObj.R/Rrate;
allLObj=f.run('fun/make3DalongPath.m',LObj,X1,Y1,Z1,dDis,dAngle2);

allDiscObj=mfs.align2Value('bottom',allDiscObj,0);
sampleH=mfs.getObjEdge('top',allDiscObj);
sampleW=sampleH;sampleL=sampleH;
allDiscObj1=mfs.move(allDiscObj,sampleW/4,sampleH/4,0);

allLObj2=mfs.move(allLObj,sampleW/2,sampleH*3/4,0);
allLObj2=mfs.align2Value('bottom',allLObj2,0);

%step 2: make a box and import the objects
B=obj_Box;%declare a box object
B.name='Cable';
B.ballR=ballR;%element radius
B.sampleW=sampleW;%width, length, height
B.sampleL=sampleL;%when L is zero, it is a 2-dimensional model
B.sampleH=sampleH;
B.isSample=0;%
B.boundaryStatus=[1,1,1,1,1,0];%left, right, front, back, bottom and top sides
B.setType('botPlaten');%add a top platen to compact model
B.buildInitialModel();
B.setUIoutput();
d=B.d;
d.mo.setGPU('off');

[cableId1,cableId2]=d.addElement(1,{allDiscObj1,allLObj2});
d.addGroup('Cable1',cableId1);
d.setClump('Cable1');
d.addGroup('Cable2',cableId2);
d.setClump('Cable2');
d.mo.setShear('off');
d.mo.zeroBalance();
d.resetStatus();
d.mo.mVis=d.mo.mVis*0.01;

%step 3: drop of the two noodles
fName=['data/step/' B.name num2str(B.ballR) '-2,' num2str(B.distriRate) 'loopNum'];
d.mo.setGPU('auto');
d.mo.dT=d.mo.dT*4;
for i=1:10
    d.balance('Standard',0.2);
    d.figureNumber=d.show('Displacement');
    view(10*i,30);
    save([fName num2str(i) '.mat']);
end