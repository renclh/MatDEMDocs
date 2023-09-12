clear;
load('TempModel/BoxCompaction2.mat');
d.calculateData();
d.mo.setGPU('off');
B.setUIoutput();
d=B.d;
d.getModel();%d.setModel();%reset the initial status of the model
d.resetStatus();%initialize model status, which records running information

showType='mV';
figureNumber=d.show(showType);
d.figureNumber=figureNumber;

SET=B.SET;
%reduce stiffness of topPlaten
d.mo.aKN(d.GROUP.topPlaten)=d.mo.aKN(d.GROUP.topPlaten)/10;
d.mo.aKS(d.GROUP.topPlaten)=d.mo.aKS(d.GROUP.topPlaten)/10;

topPlatenVis0=d.mo.mVis(d.GROUP.topPlaten)/10;
sampleVis0=d.mo.mVis(d.GROUP.sample)/10;
topPlatenVis1=d.mo.mVis(d.GROUP.topPlaten)/100;
sampleVis1=d.mo.mVis(d.GROUP.sample)/100;

d.setStandarddT();
%d.mo.dT=d.mo.dT*4;

fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
gpuStatus=d.mo.setGPU('auto');
compactionNum=2;
compactionCircle=2;
resetCircle=1;
standardBalanceNum=0.5;
boxHeight=mean(d.mo.aZ(d.GROUP.topPlaten))-6*B.ballR;
porosity=mfs.get2DPorosity(d,0,B.SET.boxDiameter,0,boxHeight);
d.tic(compactionCircle*compactionNum*2+resetCircle*compactionNum*2);

IStart=0;Iend=0;
for n=1:compactionNum
    %compaction of left hammer
    d.mo.mM(d.GROUP.hammer1)=SET.hammer1M;%assign load to left hammer
    d.mo.mGZ(d.GROUP.hammer1)=SET.hammer1GZ;
    d.mo.mVZ(d.GROUP.hammer1)=-SET.hammerV;
    d.mo.mVis(d.GROUP.topPlaten)=topPlatenVis1;
    d.mo.mVis(d.GROUP.sample)=sampleVis1;
    d.show('mVis');

    IStart=Iend+1;
    Iend=IStart+compactionCircle-1;
    for i=IStart:Iend
        d.mo.setGPU(gpuStatus);
        d.balance('Standard',standardBalanceNum);
        d.clearData(1);
        d.mo.setGPU('off');
        save([fName num2str(i) '.mat'],'-v7.3');
        d.calculateData();
        
        porosity1=mfs.get2DPorosity(d,0,B.SET.boxDiameter,0,boxHeight);
        porosity=[porosity;porosity1];
        d.toc();%show the note of time;
        d.show(showType);
    end
    %d.show('mV');return
    %reset hammer1
    d.mo.mM(d.GROUP.hammer1)=SET.hammer1M0;%reset left hammer
    d.mo.mGZ(d.GROUP.hammer1)=SET.hammer1GZ0;
    d.mo.mVis(d.GROUP.topPlaten)=topPlatenVis0;
    d.mo.mVis(d.GROUP.sample)=sampleVis0;
    IStart=Iend+1;
    Iend=IStart+resetCircle-1;
    for i=IStart:Iend
        d.mo.setGPU(gpuStatus);
        d.balance('Standard',standardBalanceNum);
        d.clearData(1);
        d.mo.setGPU('off');
        save([fName num2str(i) '.mat'],'-v7.3');
        d.calculateData();
        
        porosity1=mfs.get2DPorosity(d,0,B.SET.boxDiameter,0,boxHeight);
        porosity=[porosity;porosity1];
        d.toc();%show the note of time;
        d.show(showType);
    end
    
    %compaction of right hammer
    d.mo.mM(d.GROUP.hammer2)=SET.hammer2M;
    d.mo.mGZ(d.GROUP.hammer2)=SET.hammer2GZ;
    d.mo.mVZ(d.GROUP.hammer2)=-SET.hammerV;
    d.mo.mVis(d.GROUP.topPlaten)=topPlatenVis1;
    d.mo.mVis(d.GROUP.sample)=sampleVis1;
    IStart=Iend+1;
    Iend=IStart+compactionCircle-1;
    for i=IStart:Iend
        d.mo.setGPU(gpuStatus);
        d.balance('Standard',standardBalanceNum);
        d.clearData(1);
        d.mo.setGPU('off');
        save([fName num2str(i) '.mat'],'-v7.3');
        d.calculateData();
        
        porosity1=mfs.get2DPorosity(d,0,B.SET.boxDiameter,0,boxHeight);
        porosity=[porosity;porosity1];
        d.toc();%show the note of time;
        d.show(showType);
    end
    %reset hammer2
    d.mo.mM(d.GROUP.hammer2)=SET.hammer2M0;%reset right hammer
    d.mo.mGZ(d.GROUP.hammer2)=SET.hammer2GZ0;
    d.mo.mVis(d.GROUP.topPlaten)=topPlatenVis0;
    d.mo.mVis(d.GROUP.sample)=sampleVis1;
    IStart=Iend+1;
    Iend=IStart+resetCircle-1;
    for i=IStart:Iend
        d.mo.setGPU(gpuStatus);
        d.balance('Standard',standardBalanceNum);
        d.clearData(1);
        d.mo.setGPU('off');
        save([fName num2str(i) '.mat'],'-v7.3');
        d.calculateData();
        
        porosity1=mfs.get2DPorosity(d,0,B.SET.boxDiameter,0,boxHeight);
        porosity=[porosity;porosity1];
        d.toc();%show the note of time;
        d.show(showType);
    end
end
figure;
plot(porosity);

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxCrush3Finish');
save(['TempModel/' B.name '3.mat'],'d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();