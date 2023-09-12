%set the material of the model
clear
load('TempModel/PoreTunnel1.mat');
%------------initialize model-------------------
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');



d.getModel();%get xyz from d.m

%------------end initialize model-------------------


%-------------set new material----------------
matTxt=load('Mats\SandYanjie.txt');
Mats{1,1}=material('SandYanjie',matTxt,B.ballR);
Mats{1,1}.Id=1;
matTxt2=load('Mats\Tunnel.txt');
Mats{2,1}=material('Tunnel',matTxt2,B.ballR);
Mats{2,1}.Id=2;
d.Mats=Mats;
%-------------end set new material----------------


%--------------------make tunnel-----------------------
sampleId=d.getGroupId('sample');
sX=d.mo.aX(sampleId);sY=d.mo.aY(sampleId);sZ=d.mo.aZ(sampleId);sR=d.mo.aR(sampleId);
dipD=0;dipA=90;radius=2.75;height=30;
columnFilter=f.run('fun/getColumnFilter.m',sX,sY,sZ,dipD,dipA,radius+B.ballR,height);
d.addGroup('Tunnel',find(columnFilter));
tunnelId=d.getGroupId('Tunnel');
d.delElement(tunnelId);


%--------------------end make tunnel-----------------------


B.name='PoreTunnel';
innerR=radius;
layerNum=2;
minBallR=0.1;
Rrate=0.8;


ringObj=f.run('fun/makeRing.m',innerR,layerNum,minBallR,Rrate);
ringObj=mfs.rotate(ringObj,'YZ',90);%rotate the group along XZ plane
ringId=d.addElement(1,ringObj);%add a slope boundary
d.addGroup('ring',ringId);%add a new group
d.setClump('ring');%set the pile clump
d.moveGroup('ring',(max(sX)+min(sX))/2,0,(max(sZ)+min(sZ))/2);
d.minusGroup('sample','ring',0.4);%remove overlap elements from sample


d.setGroupMat('sample','SandYanjie');
d.setGroupMat('ring','Tunnel');
d.groupMat2Model({'sample','ring'},2);


R1=max(d.mo.aX(d.GROUP.ring))-min(d.mo.aX(d.GROUP.ring))+2*max(ringObj.R)


tp=d.GROUP.topPlaten
blockWidth=10;
tpX=d.mo.aX(tp);
tpXCenter=(max(tpX)+min(tpX))/2;
blockFilter=tpX>(tpXCenter-blockWidth/2)&tpX<(tpXCenter+blockWidth/2);
blockId=tp(blockFilter);
d.addGroup('block',blockId);
gpuStatus=d.mo.setGPU('auto');


d.breakGroup();
d.mo.zeroBalance();
d.mo.setShear('off');
d.mo.setGPU('auto');
d.balance('Standard',3)


R2=max(d.mo.aX(d.GROUP.ring))-min(d.mo.aX(d.GROUP.ring))+2*max(ringObj.R)


d.mo.mGZ(blockId)=d.mo.mGZ(blockId)+(-6e+05);

d.breakGroup();
d.mo.zeroBalance();
d.mo.setShear('off');
d.mo.setGPU('auto');
d.balance('Standard',3)

%d.mo.aX(d.GROUP.topPlaten)=d.aX(d.GROUP.topPlaten);
%d.mo.aY(d.GROUP.topPlaten)=d.aY(d.GROUP.topPlaten);
%d.mo.aZ(d.GROUP.topPlaten)=d.aZ(d.GROUP.topPlaten);
%platenId=[d.GROUP.lefPlaten;d.GROUP.rigPlaten;d.GROUP.botPlaten;d.GROUP.topPlaten];
%d.addFixId('XYZ',platenId);
%d.getModel();%get xyz from d.mo

R3=max(d.mo.aX(d.GROUP.ring))-min(d.mo.aX(d.GROUP.ring))+2*max(ringObj.R)


%--------------------save data-----------------------
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxTunnel2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
%--------------------end save data-----------------------