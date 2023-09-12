%set the material of the model
clear
load('TempModel/PoreTunnel1.mat');
%------------initialize model-------------------
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.mo.aX(d.GROUP.topPlaten)=d.aX(d.GROUP.topPlaten);
d.mo.aY(d.GROUP.topPlaten)=d.aY(d.GROUP.topPlaten);
d.mo.aZ(d.GROUP.topPlaten)=d.aZ(d.GROUP.topPlaten);
platenId=[d.GROUP.lefPlaten;d.GROUP.rigPlaten;d.GROUP.botPlaten;d.GROUP.topPlaten];
d.addFixId('XYZ',platenId);
d.getModel();%get xyz from d.mo
%------------end initialize model-------------------

%-------------set new material----------------
matTxt=load('Mats\StrongSoil.txt');
Mats{1,1}=material('StrongSoil',matTxt,B.ballR);
Mats{1,1}.Id=1;
matTxt=load('Mats\Tunnel.txt');
Mats{1,2}=material('TunnelMat',matTxt,B.ballR);
Mats{1,2}.Id=2;
d.Mats=Mats;
%-------------end set new material----------------

%--------------------make tunnel-----------------------
sampleId=d.getGroupId('sample');
sX=d.mo.aX(sampleId);sY=d.mo.aY(sampleId);sZ=d.mo.aZ(sampleId);sR=d.mo.aR(sampleId);
dipD=0;dipA=90;radius=4;height=30;
columnFilter=f.run('fun/getColumnFilter.m',sX,sY,sZ,dipD,dipA,radius+B.ballR,height);
d.addGroup('Tunnel',find(columnFilter));
tunnelId=d.getGroupId('Tunnel');
d.delElement(tunnelId);

%--------------------end make tunnel-----------------------

B.name='PoreTunnel';
innerR=radius;
layerNum=3;
minBallR=min(sR);
Rrate=0.8;
ringObj=f.run('fun/makeRing.m',innerR,layerNum,minBallR,Rrate);
ringObj=mfs.rotate(ringObj,'YZ',90);%rotate the group along XZ plane

ringId=d.addElement(1,ringObj);%add a slope boundary
d.addGroup('ring',ringId);%add a new group
d.setClump('ring');%set the pile clump
d.moveGroup('ring',(max(sX)+min(sX))/2,0,(max(sZ)+min(sZ))/2);
d.minusGroup('sample','ring',0.4);%remove overlap elements from sample

d.setGroupMat('sample','StrongSoil');
d.setGroupMat('ring','TunnelMat');

d.groupMat2Model({'sample','ring'},1);

d.breakGroup();
d.mo.zeroBalance();
mfs.randomV(d,1:d.mNum);

d.mo.setShear('off');
d.mo.setGPU('auto');
d.balance('Standard',2);

d.balanceBondedModel();
for i=1:50
d.connectGroup('sample');
d.removePrestress(0.1);%remove internal stress of sample
d.balance('Standard',0.5);
end
d.mo.setShear('on');
d.balance('Standard',5);

%--------------------save data-----------------------
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Step2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
%--------------------end save data-----------------------

d.calculateData();
d.show('ZDisplacement');