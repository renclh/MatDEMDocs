%clear;
fs.randSeed(1);%
totalCircle=2;%define the number of random simulation
load('TempModel/BoxMonteCarlo2_3.mat');
%----------define the parameters of the slopes
aBFRates=(2+rand(d.SET.modelNum,1)*8)/20;%rates of d.mo.aBF, tensile strength
aMUpRates=(2+rand(totalCircle,1)*8)/20;%rate of d.mo.aMUp, friction coefficient

fName=['data/step/' B.name  num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
for i=1:totalCircle
    load('TempModel/BoxMonteCarlo2_3.mat');
    B.setUIoutput();
    d=B.d;
    d.calculateData();
    d.mo.setGPU('off');
    d.getModel();%d.setModel();%reset the initial status of the model
    d.resetStatus();%initialize model status, which records running information
    
    d.mo.isHeat=1;%calculate heat in the model
    visRate=0.001;
    d.mo.mVis=d.mo.mVis*visRate;
    d.setStandarddT();
    sId=d.GROUP.sample;
    d.mo.aMUp(sId)=d.mo.aMUp(sId)*aMUpRates(i);%assign a different friction coefficient@@@
    
    d.SET.aMUpRate=aMUpRates(i);%record the setup of this model
    d.SET.aBFRates=aBFRates;
    for j=1:d.SET.modelNum
        sName=['sample' num2str(j)];
        sId=d.GROUP.(sName);
        d.mo.aBF(sId)=d.mo.aBF(sId)*aBFRates(j);%assign a different break force (tensile strength)@@@
    end
    d.mo.setGPU('auto');
    d.balance('Standard',0.5);%we may reduce the value to 0.2 to increase the speed
    
    d.clearData(1);%save the data
    save([fName num2str(i) '.mat']);
    d.calculateData();
end

%show the displacement of each slope, and mark them
d.show('Displacement');
title(['Displacement, aMUpRate: ' num2str(d.SET.aMUpRate)]);
for i=1:d.SET.modelNum
    maxSZ=max(d.mo.aZ(d.GROUP.sample));
    sY=d.aY(d.GROUP.(['sample' num2str(i)]));
    text(0.05*maxSZ,sY(1),0.1*maxSZ+maxSZ,num2str(i));
end