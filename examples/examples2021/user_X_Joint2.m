clear
load('TempModel/X_Joint11.mat');
B.setUIoutput();%set output of message
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo
d.connectGroup();
%StressXX=5e6;
%StressZZ=5e6;
%B.setPlatenFixId()

%B.setPlatenStress(StressXX,0,0,B.ballR*5);
d.showB=2;
topPartId=[d.GROUP.topB;d.GROUP.topPlaten];%将上压力板与上边界组合
d.addGroup('topPart',topPartId);%构建组
d.show;
matTxt2=load('Mats\XRock.txt');%load a un-trained material file
Mats{1,1}=material('XRock',matTxt2,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;
d.groupMat2Model({'sample'},1);    %赋予材料属性

d.mo.mGZ(:)=0;%消除z方向体力，即消除重力
stressXX=5e6;
stressZZ=5e6;
d.mo.setShear('off');
B.setPlatenStress(-stressXX,0,-stressZZ,B.ballR*5);
d.mo.mGX(d.GROUP.lefPlaten)=-d.mo.mGX(d.GROUP.rigPlaten);%模型左拉右压

d.breakGroup();%断开所有单元的连接
d.mo.setGPU('auto');
d.balance('Standard',1);
  
d.connectGroup();%胶结所有连接
d.removePrestress();%将单元的抗拉力临时减小，断开胶结，消除单元间的张力（预应力
d.deleteConnection('boundary');%删除胶结
%消除内应力
%B.compactSample(1);
d.balance('Standard',1);

ddis=d.mo.aZ(d.GROUP.topPlaten);
dddis=d.mo.aZ(d.GROUP.topB);
d.moveGroup('topB',0,0,ddis-dddis+2*B.ballR);
d.moveGroup('lefB',-200,0,0);
d.moveGroup('rigB',200,0,0);
%C=Tool_Cut(d);%cut the model
%lSurf=load('slope/IntermittentX3.txt');%load the surface data
%C.addSurf(lSurf);%add the sur faces to the cut 导入离散点数据
%C.getSurfTri(1,1);
%C.getTriangle(1);
%C.setBondByTriangle('break');

%C=Tool_Cut(d);%cut the model
%lSurf=load('slope/IntermittentX4.txt');%load the surface data
%C.addSurf(lSurf);%add the sur faces to the cut
%C.getSurfTri(1,1);%获取离散元三角面信息
%C.getTriangle(1); %获取三角面顶点坐标
%C.setBondByTriangle('break');%使三角面破裂
%d.show('--');
d.show('aR')


%---------------5. save the data
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxModel2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();