clear
load('TempModel/CuTestNew1.mat');
allStressSteps=mfs.getBoxUniaxialStressSteps(B);
stressSteps=allStressSteps.CuStressSteps;
fs.disp('<----------------------Start mfs.makeUniaxialCuTest---------------------->');
B.setUIoutput();
d=B.d;
d.calculateData();
d.status=modelStatus(d);%initialize model status, which records running information
d.setStandarddT();
d.mo.isHeat=1;%calculate heat in the model
d.setStandarddT();
totalCircle=length(stressSteps);
d.tic(totalCircle);
%set the file saving
fName=['data/step/' B.name '-MatUniaxialCu-R'  num2str(B.ballR) '-' num2str(B.distriRate) 'aNum' num2str(d.aNum) 'loopNum'];
if B.saveFileLevel>1
    d.clearData(1);
    fs.save([fName '0.mat'],'B',B);
    d.calculateData();
end
d.mo.isFix=0;
%reduce the stiffness of lateral boundary for uniaxial test
bId=[d.GROUP.lefB;d.GROUP.rigB;d.GROUP.froB;d.GROUP.bacB];
d.mo.aKN(bId)=1e-100;d.mo.aKS(bId)=1e100;
d.mo.setKNKS();
%set the default value of test
if ~isfield(d.SET,'divNum')
    d.SET.divNum=10;
end
if ~isfield(d.SET,'balanceRate')||d.SET.balanceRate<=0
    d.SET.balanceRate=0.4;
end

divNum=d.SET.divNum;
balanceRate=d.SET.balanceRate;
stressStep=0;
maxForce=0;
d.mo.setGPU('auto');
for i=1:totalCircle
    for j=1:divNum
        B.setPlatenStress('StressZZ',stressStep+(stressSteps(i)-stressStep)/divNum*j);
        d.balance('Standard',balanceRate,'off');
        d.status.SET.isWHT=1;%record the WHT in recordStatus
        d.recordStatus();
    end
    if B.saveFileLevel>1
        d.clearData();
        fs.save([fName num2str(i) 'divNum' num2str(divNum) 'balanceRate' num2str(balanceRate) '.mat'],'B',B);
        d.calculateData();
    end
    d.toc();%show the note of time;
    stressStep=stressSteps(i);
    newForce=-d.status.bottomBFs(end,3);
    if newForce>maxForce
        maxForce=newForce;
    end
    if newForce<0.9*maxForce
        break;
    end
    
    %calculate the strain, when it >0.4, break
    meanTopPlatenZ0=mean(d.aZ(d.GROUP.topPlaten));
    meanTopPlatenZ1=mean(d.mo.aZ(d.GROUP.topPlaten));
    minSampleZ0=min(d.aZ(d.GROUP.sample));
    strainZZ=(meanTopPlatenZ0-meanTopPlatenZ1)/(meanTopPlatenZ0-minSampleZ0);
    if strainZZ>0.4
        break;
    end
end
Cu=d.status.calculateCu();%calculate Cu based on the saved data in d.statu.TAG, WHT and WHTTIds

d.recordCalHour('BoxTest3Finish');
if B.saveFileLevel>0
    d.clearData(1);
    fs.save(['data/' B.name '-MatUniaxialCu-R'  num2str(B.ballR) '-' num2str(B.distriRate) 'aNum' num2str(d.aNum) '.mat'],'B',B);
    d.calculateData();
end
fs.disp('<----------------------End mfs.makeUniaxialCuTest---------------------->');
%post-processing
figure('Position',[50,50,1200,400]);
subplot(1,2,1);
d.status.showBoundaryStresses();
xlabel('Time [s]');
ylabel('Magnitude of boundary stress [Pa]');
subplot(1,2,2);
d.status.showStrainStress();
xlabel('StressZZ [Pa]');

figure
S=fs.getBlockStrainStress(d.status);
plot(-S.strainZZ,-S.stressZZ,'k','LineWidth',1);
xlabel('Magnitude of StrainZZ');
ylabel('Magnitude of StressZZ [Pa]');
title('StressZZ-StrainZZ Curve during Cu test');

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxCuTestNewFinish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();