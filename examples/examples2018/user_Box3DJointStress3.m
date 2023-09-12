%-------------------user_mxSlope3.m;
clear;
load('TempModel/3DJointStress2.mat');
B.setUIoutput();
%------------initialize model-------------------
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.mo.bFilter(:)=true;
d.deleteConnection('boundary');
d.mo.zeroBalance();
d.getModel();%d.setModel();%reset the initial status of the model
d.resetStatus();
d.mo.isHeat=1;%calculate heat in the model
d.setStandarddT();
d.mo.isCrack=1;
d.moveBoundary('right',B.sampleW*0.2,0,0);
d.moveBoundary('back',0,B.sampleL*0.2,0);
d.mo.isCrack=1;%will record crack data

%------------end initialize model-------------------
%--------------------apply initial stress-----------------------
type='break';%change type to 'break' to create crack
if strcmp(type,'glue')
    d.mo.bFilter(:)=false;
end

%------------crack-------------
TriX=[0.01,0.08,0.02];TriY=[0.05,0.1,0.05];TriZ=[0,0.05,0.1];
bondFilter=mfs.setBondByTriangle(d,TriX,TriY,TriZ,type);%make triangle crack, run d.mo.zeroBalance() after the function
d.mo.zeroBalance();
d.showFilter('Group',{'sample'});
%------------end crack-------------

bondFilter=bondFilter&(d.mo.cFilter|d.mo.bFilter);
connectFilter=sum(bondFilter,2)>0;
connectId=find(connectFilter);
d.addGroup('JointLayer',connectId);%add a new group
figure;
d.showFilter('Group','JointLayer','aR');

%------------weak or strong joint-------------
TriX=[0.09,0.09,0.1,0.01];TriY=[0,0.1,0,0.1];TriZ=[0,0,0.1,0.1];
bondFilter=mfs.setBondByPolygon(d,TriX,TriY,TriZ,'glue');%make triangle crack
d.mo.nBondRate(bondFilter)=2;%make strong joint
%------------end weak or strong joint------------

d.show('Crack','Stereo');

%-------------using Tool_Cut Triangle-------------
TriX2=[TriX(1:3);TriX([1,3,4])]-0.05;
TriY2=[TriY(1:3);TriY([1,3,4])];
TriZ2=[TriZ(1:3);TriZ([1,3,4])];
C=Tool_Cut(d);
C.setTriangle(TriX2,TriY2,TriZ2);
bondFilter=C.setBondByTriangle(type);
d.mo.nBondRate(bondFilter)=0.5;%make weak joint, BF and FS0 will reduce
d.show('BondRate');
C.showTriangle();
%-------------end using Tool_Cut Triangle-------------

%added in MatDEM 2.01
%------------nBondRate for breaking force (BF), friction coefficient (MUp), initial shear resistance (FS0)
d.mo.isBondRate=1;
nBondRateMUp=ones(size(d.mo.nBall));
nBondRateMUp(bondFilter)=0;
d.mo.SET.nBondRate.MUp=nBondRateMUp;%MUp could be replaced by 'BF', 'FS0'
d.show('BondRateMUp');
%------------end nBondRate for breaking force (BF), friction coefficient (MUp), initial shear resistance (FS0)

%---------------make triangle by scattered points----------------
%we modify Surf SurfTri or TriangleX,Y,Z to build new surface
fs.randSeed(2);
d.mo.bFilter(:)=false;
d.mo.zeroBalance();
randN=10;
PX=rand(randN,1)*0.1;PY=rand(randN,1)*0.1;PZ=0.05+rand(randN,1)*0.04;
C.addSurf(PX,PY,PZ);
C.getSurfTri(1,1);
C.getTriangle(1);
bondFilter=C.setBondByTriangle(type);
d.mo.bFilter=bondFilter;
d.showFilter('Group',{'sample'});
d.show('--');
C.showTriangle();
%---------------end make triangle by scattered points----------------

%--------------------start calculation-----------------------
totalCircle=5;
d.tic(totalCircle);%record the initial time of loop
fName=['data/step/' B.name  num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
gpuStatus=d.mo.setGPU('auto');
for i=1:totalCircle
    B.setPlatenStress(B.SET.stressXX,B.SET.stressYY,B.SET.stressZZ*(1+i/totalCircle),B.ballR*5);
    d.balance('Standard',1);%standard balance
    d.clearData(1);
    d.mo.setGPU('off');
    save([fName num2str(i) '.mat']);
    d.calculateData();
    d.mo.setGPU(gpuStatus);
    d.toc();%show the note of time;
end
d.recordCalHour('Step3Finish');
d.mo.setGPU('off');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.showFilter('Group',{'sample'},'StressZZ');