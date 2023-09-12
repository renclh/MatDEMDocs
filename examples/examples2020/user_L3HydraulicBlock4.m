clear
fs.randSeed(2);
load('TempModel/HydraulicBlock3.mat');
B.setUIoutput();
%--------initializing the model
d=B.d;
d.calculateData();
d.mo.setGPU('off');

d.showB=2;
d.deleteConnection('boundary');
d.Rrate=1;
d.getModel();
d.resetStatus();
d.mo.isCrack=1;
d.mo.mVis=d.mo.mVis./d.vRate*0.01;%use uniform viscosity

px1=B.sampleW/2;%
pz1=0.15/2;
center_pId=d.findNearestId(px1,0,pz1);
top_pId=d.findNearestId(px1,0,B.sampleH-B.ballR*2);

d.Rrate=1;

%start building pore system
p=pore(d);
p.fluid_k=0.4615e-4;p.fluid_c=870;%use oil property, default value is water

d.mo.dT=d.mo.dT*2;%
p.dT=p.d.mo.dT;
p.pathLimitRate=0.3;%path diameter<pathLimitRate*ballR will be connection
p.isCouple=1;%fluid-solid coupling
p.setInitialPores();
p.setPlaten('fix');%fix the coordinates of platens
%---------end initializing the model

%----------set the drawing of result during iterations
%setappdata(0,'simpleFigure',1);%use simpleFigure to increase drawing speed
%setappdata(0,'ballRate',0.01);%use small ballRate to increase drawing speed
showType='*pPressure';
d.figureNumber=1;
%----------end set the drawing of result during iterations

%d.show('Crack');hold all;d.show('--');

%---------calculate connection diameter and flow K
k=0.00000001;%permeability factor
%---------end calcualte connection diameter and flow K
k=k/10;%change the permeability

pPressureHigh=100e6;%use greater pressure
pPressure0=0.1e6;%use greater pressure
%---------setting of the simulation
totalCircle=5;
dPressure=pPressureHigh/totalCircle;
stepNum=100;
fName=['data/step/2' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
d.tic(totalCircle);%record the initial time of loop
%d.mo.setGPU('on');
%p.setGPU('on');

for i=1:totalCircle
    pPressure=dPressure*totalCircle;
    for j=1:stepNum
        cDiameterFlow=p.cDiameter+p.cDiameterAdd;%calculate the diameter of
        cDiameterFlow(cDiameterFlow<0)=0;
        p.cKFlow=cDiameterFlow*k./p.cPathLength;%default K of throat is determined by diameter and path length
        cbFilter=d.mo.bFilter(p.cnIndex);%bonded filter of cList
        p.cKFlow(cbFilter)=p.cKFlow(cbFilter)/100;%K of intacted bond is very small
        p.setBallPressure(center_pId,pPressure);%set the pressure in the crack
        p.setBallPressure(top_pId,pPressure0);%set the pressure around the sample

        p.balance();
        d.balance(10);
        d.recordStatus();
    end
    cla;%clear the previous figure
    d.show('Displacement');
    %p.show(showType);
    %pause(0.1);%pause and show the figure
    save([fName num2str(i) '.mat']);%save data
    d.recordStatus();
    d.toc();
end
%---------save the data
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Step3Finish');
save(['TempModel/' B.name '4.mat'],'B','d');
save(['TempModel/' B.name '4R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
%user_makeGIF