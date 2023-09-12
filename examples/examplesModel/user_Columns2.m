%set the material of the model
clear
load('TempModel/Column1.mat');
B.setUIoutput();%set the output
d=B.d;
d.calculateData();%calculate data
d.mo.setGPU('off');%close the GPU calculation
d.getModel();%get xyz from d.mo

d.delElement('topPlaten');
d.delElement('topB');

visRate=0.0001;
d.mo.mVis=d.mo.mVis*visRate;
d.mo.setShear('off');
%add all elements to the AllSample group
d.addGroup('AllSample',(1:d.mNum)');
d.moveGroup('AllSample',0,0,B.sampleH/2);

showType='mV';
d.mo.dT=d.mo.dT*4;
gpuStatus=d.mo.setGPU('auto');
totalCircle=30;
d.tic(totalCircle);
fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
for i=1:totalCircle
    d.balance('Standard',0.1);
    d.show(showType);
    pause(0.05);
    
    d.clearData(1);%clear data in d.mo
    save([fName num2str(i) '.mat']);
    d.calculateData()
end

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxCrush3Finish');
save(['TempModel/' B.name '3.mat'],'d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();