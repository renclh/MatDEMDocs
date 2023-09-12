clear;
load('TempModel/BoxStruct2.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%d.setModel();%reset the initial status of the model
d.mo.bFilter(:)=true;
d.mo.zeroBalance();
d.resetStatus();
d.mo.isHeat=1;%calculate heat in the model
d.setStandarddT();
d.mo.isCrack=1;
d.addFixId('Y',d.GROUP.brLayer);

d.mo.aBF=d.mo.aBF/10;
d.mo.aFS0=d.mo.aFS0/10;
DisY=B.sampleL*0.01;

totalCircle=20;stepNum=100;
d.tic(totalCircle*stepNum);
fName=['data/step/' B.name  num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat'],'-v7.3');%return;
dis=DisY/(totalCircle*stepNum);
gpuStatus=d.mo.setGPU('auto');
for i=1:totalCircle
    d.mo.setGPU(gpuStatus);
    for j=1:stepNum
        d.moveGroup('brLayer',0,-dis,0);
        d.balance(5);
        d.recordStatus();
        d.toc();%show the note of time
    end
    d.clearData(1);
    save([fName num2str(i) '.mat'],'-v7.3');
    d.calculateData();
end

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxStruct3Finish');
save(['TempModel/' B.name '3.mat'],'B','d','-v7.3');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat'],'-v7.3');
d.calculateData();