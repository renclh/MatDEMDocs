clear
load('TempModel/BoxTunnelHeat1.mat');
%------------initialize model-------------------
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo
%------------end initialize model-------------------

%---------------delele elements on the top
mZ=d.mo.aZ(1:d.mNum);%get the Z of elements
topLayerFilter=mZ>max(mZ)*0.9;
d.delElement(find(topLayerFilter));%delete elements according to id

%-------------set new material----------------
matTxt=load('Mats\StrongRock.txt');
Mats{1,1}=material('StrongRock',matTxt,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;
d.groupMat2Model({'sample'},1);
%-------------end set new material----------------

%-----------------make pipe--------------------
mX=d.mo.aX(1:d.mNum);mY=d.mo.aY(1:d.mNum);mZ=d.mo.aZ(1:d.mNum);mR=d.mo.aR(1:d.mNum);
innerR=0.2;
layerNum=2;
minBallR=min(mR)*0.9;
Rrate=1;
ringObj=f.run('fun/makeRing.m',innerR,layerNum,minBallR,Rrate);
tubeL=4;
dZ=minBallR*sqrt(3)/2;
ringNum=(tubeL-minBallR)/dZ+1;
ringZ=(1:ringNum)*dZ;
dAngle=180/(length(ringObj.R)/layerNum);
tubeObj=ringObj;
for i=1:ringNum-1
    newObj=mfs.rotate(ringObj,'XY',dAngle*i);
    newObj=mfs.move(newObj,0,0,dZ*i);
    tubeObj=mfs.combineObj(tubeObj,newObj);
end
outerR=(max(tubeObj.X)-min(tubeObj.X))/2;
%-----------------end make tube--------------------

%--------------------make tunnel-----------------------
sampleId=d.getGroupId('sample');
sX=d.mo.aX(sampleId);sY=d.mo.aY(sampleId);sZ=d.mo.aZ(sampleId);
dipD=0;dipA=0;radius=outerR;height=5;
columnFilter=f.run('fun/getColumnFilter.m',sX,sY,sZ,dipD,dipA,radius+B.ballR,height);
zFilter=sZ>1;
tunnelId=find(columnFilter&zFilter);
d.delElement(tunnelId);
%--------------------end make tunnel-----------------------

%-------------------insert the ringTube-------------------
tubeId=d.addElement(1,tubeObj);%add a slope boundary
d.addGroup('ringTube',tubeId);%add a new group
d.setClump('ringTube');%set the pile clump
d.moveGroup('ringTube',(max(mX)+min(mX))/2,(max(mY)+min(mY))/2,1);
d.minusGroup('sample','ringTube',0.4);%remove overlap elements from sample
innerTubeId=find(d.mo.aR==minBallR);
d.addGroup('innerTube',innerTubeId);%add a new group
%-------------------end insert the ringTube-------------------

d.addFixId('X', d.GROUP.ringTube);%fix the coordinates of elements of the pile
d.addFixId('Y', d.GROUP.ringTube);
d.addFixId('Z', d.GROUP.ringTube);
d.balanceBondedModel0();%bond the elements and balance the model
d.breakGroup();%break all connections
d.balance('Standard');%balance the model before saving

d.show();
%--------------------save data-----------------------
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxTunnelHeat2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
%--------------------end save data-----------------------

d.calculateData();
d.show('ZDisplacement');