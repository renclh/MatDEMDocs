clear;
load('TempModel/粉末模型1.mat');
%------------initialize model-------------------
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo
ringObj=d.SET.ringObj;
SampleObj=d.SET.SampleObj;
ballR=d.SET.KeLiR;
%figure;fs.showObj(ringObj);hold on;fs.showObj(SampleObj);
%return;

fs.randSeed(1);%random model seed, 1,2,3...
B=obj_Box;%declare a box object
B.name='增材制造';
B.GPUstatus='auto';%program will test the CPU and GPU speed, and choose the quicker one
B.ballR=ballR;
B.isShear=1;
B.isClump=0;%if isClump=1, particles are composed of several balls
B.distriRate=0.2;%define distribution of ball radius, 
B.sampleW=36;
B.sampleL=0;
B.sampleH=6;
B.BexpandRate=2;%boundary is 4-ball wider than 
B.PexpandRate=0;
B.isSample=0;
B.setType();
B.buildInitialModel();
d=B.d;
Rate=0.3;
h=0.5;
Wall1Obj.X=[0:2*(B.ballR*(1-Rate)):(B.sampleW)/6-B.ballR]';
Wall1Obj.Y=Wall1Obj.X.*0;
Wall1Obj.Z=Wall1Obj.X.*0-B.ballR;
Wall1Obj.R=Wall1Obj.X.*0+B.ballR;

Wall2Obj.Z=[-2*(B.ballR*(1-Rate)):-2*(B.ballR*(1-Rate)):-h]'-B.ballR;
Wall2Obj.X=Wall2Obj.Z.*0+max(Wall1Obj.X);
Wall2Obj.Y=Wall2Obj.X.*0;
Wall2Obj.R=Wall2Obj.X.*0+B.ballR;

Wall3Obj.X=[max(Wall1Obj.X)+2*(B.ballR*(1-Rate)):2*(B.ballR*(1-Rate)):(B.sampleW/2)]';
Wall3Obj.Y=Wall3Obj.X.*0;
Wall3Obj.Z=Wall3Obj.X.*0+min(Wall2Obj.Z);
Wall3Obj.R=Wall3Obj.X.*0+B.ballR;
%figure;fs.showObj(Wall1Obj);figure;fs.showObj(Wall2Obj);figure;fs.showObj(Wall3Obj);
%return;
Wall0Obj.X=[Wall1Obj.X;Wall2Obj.X;Wall3Obj.X];
Wall0Obj.Y=[Wall1Obj.Y;Wall2Obj.Y;Wall3Obj.Y];
Wall0Obj.Z=[Wall1Obj.Z;Wall2Obj.Z;Wall3Obj.Z];
Wall0Obj.R=[Wall1Obj.R;Wall2Obj.R;Wall3Obj.R];
WallObj=mfs.rotateCopy(Wall0Obj,180,2,'XY')
WallObj.Z=-h-B.ballR-WallObj.Z;
WallObj.X=B.ballR+WallObj.X+B.sampleW/2;
%figure;fs.showObj(WallObj);
%return;
d.mo.setGPU('off');
SampleId=d.addElement(1,SampleObj);
d.addGroup('sample',SampleId);%add a new group
d.moveGroup('sample',5,0,h+2*B.ballR);
WallGroupId=d.addElement(1,WallObj);
d.addGroup('WallGroup',WallGroupId);%add a new group
d.setClump('WallGroup')
d.moveGroup('WallGroup',0,0,h+B.ballR);
d.defineWallElement('WallGroup');
matTxt=load('Mats\Soil1.txt');
Mats{1,1}=material('KeiLi',matTxt,B.ballR);
Mats{1,1}.Id=1;
matTxt2=load('Mats\Soil1.txt'); 
%matTxt2=[2.00E+10	    0.12     2.00E+06	2.00E+07	0.5]
Mats{2,1}=material('WallG',matTxt2,B.ballR); 
Mats{2,1}.Id=2; 
d.Mats=Mats;
d.setGroupMat('sample','KeiLi');
d.groupMat2Model({'sample'});
d.delElement(d.GROUP.topPlaten);
d.setStandarddT();
d.mo.dT=5*d.mo.dT;%增大时间步缩短沉积时间
n=2000;d.mo.mGZ(:)=d.mo.mGZ(:).*n;%增大重力缩短沉积时间
%fName=['data/沉积8.23/' B.name num2str(B.ballR) '000-' num2str(B.distriRate) 'loopNumT'];
%d.mo.mVX=(-1+2*rand(length(d.GROUP.sample),1))*200;
d.showB=2;
figure;
d.mo.setGPU('auto');
d.figureNumber=d.show('mV');%绘图的窗口号，可指定在某一窗口绘图
d.mo.isShear=0;
%return;
for i=1:8
 d.balance('Standard',0.2);
 d.show('ZDisplacement');
 pause(0.1);
 %save([fName num2str(i) '.mat']);
end
d.mo.mGZ(:)=d.mo.mGZ(:)./n;%恢复重力
d.balance('Standard',0.20);%重新平衡
d.status.dispEnergy();%display the energy of the model                     

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxModel2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();