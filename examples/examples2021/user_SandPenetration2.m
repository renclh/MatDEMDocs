%set the material of the model
clear
load('TempModel/Sand_Penetration1.mat');
B.setUIoutput();%set the output
d=B.d;
d.calculateData();%calculate data
d.mo.setGPU('off');%close the GPU calculation
d.getModel();%get xyz from d.mo

%---------------delele the box boundary and topelement
d.delElement(d.GROUP.lefB);
d.delElement(d.GROUP.rigB);
d.delElement(d.GROUP.botB);
d.delElement(d.GROUP.topB);
mZ=d.mo.aZ(1:d.mNum);%get the Z of elements
topLayerFilter=mZ>max(mZ)*0.8;
d.delElement(find(topLayerFilter));%delete elements according to id
mX=d.mo.aX(1:d.mNum);%get the Z of elements
rigLayerFilter=mX>max(mX)*0.8;
d.delElement(find(rigLayerFilter));%delete elements according to id
B=mfs.move(B,0,0,-0.024);

%--------------assign new material
matTxt=load('Mats\Soil1.txt');
Mats{1,1}=material('Soil1',matTxt,B.ballR);
Mats{1,1}.Id=1;
matTxt2=load('Mats\Brass.txt');
Mats{2,1}=material('Brass',matTxt2,B.ballR);
Mats{2,1}.Id=2;
d.Mats=Mats;
d.setGroupMat('sample','Soil1');
d.groupMat2Model({'sample'},2);

%----------make ProjectileObj------------
ProjectileObj=mfs.denseModel(0.8,@mfs.makeDisc,0.006,0.001);
ProjectileObj=mfs.rotate(ProjectileObj, 'YZ', 90);
ProjectileObj.Y(:)=0;
ProjectileObj=mfs.move(ProjectileObj,0.2,0,0.018);

%----------import bulletObj to model------------
ProjectileId=d.addElement(2,ProjectileObj);
d.addGroup('Projectile',ProjectileId);
d.setClump('Projectile');
d.mo.zeroBalance();
d.balance('Standard');
d.balanceBondedModel();%赋材料后，自动胶结和平衡模型，有单元间摩擦力

d.show('aR');
d.clearData(1);%clear dependent data
d.recordCalHour('Step2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();