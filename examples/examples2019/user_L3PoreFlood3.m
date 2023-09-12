%set the material of the model
clear
fs.randSeed(2);
load('TempModel/PoreFlood2.mat');
B.setUIoutput();

%--------initializing the model
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo
d.showB=2;
d.deleteConnection('boundary');
d.Rrate=1;
d.getModel();
d.mo.isCrack=1;
d.mo.bFilter(:)=false;%break all connections
d.mo.zeroBalance();
d.mo.mVis=d.mo.mVis./d.vRate*0.001;%use uniform viscosity

p=pore(d);
d.mo.dT=d.mo.dT/5;%use small step time
p.dT=p.d.mo.dT;
p.pathLimitRate=0.3;%path diameter<pathLimitRate*ballR will be connection
p.isCouple=1;%fluid-solid coupling
p.setInitialPores();
p.setPlaten('fix');%fix the coordinates of platens
%---------end initializing the model

%-----------drawing setting
setappdata(0,'simpleFigure',1);%use simpleFigure to increase drawing speed
setappdata(0,'ballRate',0.01);%use small ballRate to increase drawing speed
showType='*pPressure';
figureNumber=d.show('mV');%define figureNumber, figure will shown in one form during iterations
d.figureNumber=figureNumber;
%-----------end drawing setting

%---------calculate connection diameter and flow K
k=0.00000001;%permeability factor
%---------end calcualte connection diameter and flow K
k=k/10;

pPressureHigh=p.pPressure(1)*10000;%use greater pressure
totalCircle=10;
stepNum=200;
fName=['data/step/2' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
d.tic(totalCircle);%record the initial time of loop

tic
for i=1:totalCircle
    for j=1:stepNum
        cDiameterFlow=p.cDiameter+p.cDiameterAdd;%calculate the diameter of
        cDiameterFlow(cDiameterFlow<0)=0;
        p.cKFlow=cDiameterFlow*k./p.cPathLength;%default K of throat is determined by diameter and path length
        p.setBallPressure(1,pPressureHigh);
        p.balance();
        d.balance();
        
    end
    save([fName num2str(i) '.mat']);
    d.recordStatus();
    p.show(showType);
    d.toc();
end
p.show('pPressure');
toc
%---------save the data
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Step3Finish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();