%set the material of the model
clear
load('TempModel/BoxTunnelNew1.mat');
%------------initialize model-------------------
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo
%------------end initialize model-------------------

%-------------set new material----------------
matTxt=load('Mats\StrongRock.txt');
Mats{1,1}=material('StrongRock',matTxt,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;
d.groupMat2Model({'sample'},1);
%-------------end set new material----------------

%-------------------apply stress, and balance model------------------
B.SET.stressZZ=-10e6;
B.setPlatenFixId();
d.resetStatus();
fs.setPlatenStress(d,0,0,B.SET.stressZZ,B.ballR*5);%apply no
%-------------------end apply stress, and balance model------------------

%--------------------make tunnel-----------------------
sampleId=d.getGroupId('sample');
sX=d.mo.aX(sampleId);sY=d.mo.aY(sampleId);sZ=d.mo.aZ(sampleId);
dipD=0;dipA=90;radius=4;height=30;
mX=d.mo.aX(1:d.mNum);mY=d.mo.aY(1:d.mNum);mZ=d.mo.aZ(1:d.mNum);mR=d.mo.aR(1:d.mNum);
columnFilter=f.run('fun/getColumnFilter.m',sX,sY,sZ,dipD,dipA,radius+B.ballR,height);
d.addGroup('Tunnel',find(columnFilter));
tunnelId=d.getGroupId('Tunnel');
d.delElement(tunnelId);
%--------------------end make tunnel-----------------------

B.name='BoxTunnelNew';
innerR=radius;
layerNum=3;
minBallR=min(mR);
Rrate=0.8;
ringObj=f.run('fun/makeRing.m',innerR,layerNum,minBallR,Rrate);
ringObj=mfs.rotate(ringObj,'YZ',90);%rotate the group along XZ plane

ringId=d.addElement(1,ringObj);%add a slope boundary
d.addGroup('ring',ringId);%add a new group
d.setClump('ring');%set the pile clump
d.moveGroup('ring',(max(mX)+min(mX))/2,0,(max(mZ)+min(mZ))/2);
d.minusGroup('sample','ring',0.4);%remove overlap elements from sample
d.breakGroup();
B.gravitySediment();
d.show();

%--------------------save data-----------------------
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxTunnel2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
%--------------------end save data-----------------------

d.calculateData();
d.show('ZDisplacement');