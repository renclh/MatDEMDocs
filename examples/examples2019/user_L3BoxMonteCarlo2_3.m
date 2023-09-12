clear;
load('TempModel/BoxMonteCarlo2.mat');
d2=B.d;
load('TempModel/BoxMonteCarlo2.mat');
B.setUIoutput();

modelNum=5;%defines the number of slope in one model
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%d.setModel();%reset the initial status of the model
d.status=modelStatus(d);%initialize model status, which records running information

d.is2D=0;
disY=max(d.aR)*4;
d.GROUP.sample1=d.GROUP.sample;
d.SET.modelNum=modelNum;
%the slope model is added one by one here @@@@
%we can make a new object including all slopes, and add it to d
for i=2:modelNum
    newSampleId=mfs.addModel(d,d2,0,disY*(i-1),0);
    d.GROUP.(['sample' num2str(i)])=newSampleId;
end
%---------cut the model to make slope
C=Tool_Cut(d);%cut the model
lSurf=load('slope/layer surface.txt');%load the surface data
C.addSurf(lSurf);%add the surfaces to the cut
C.setLayer({'sample'},[1,2,3,4]);%set layers according geometrical data
%---------end cut the model to make slope

%---------assign material to layers and balance the model
d.setGroupMat('layer2','Soil2');
d.groupMat2Model({'sample','layer2'});
d.balanceBondedModel();
d.show('aR');
%---------end assign material to layers and balance the model

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxStep3Finish');
save(['TempModel/' B.name '2_3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();