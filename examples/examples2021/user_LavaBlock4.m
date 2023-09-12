clear
fs.randSeed(2);
load('TempModel/LavaBlock3.mat');
B.setUIoutput();
%--------initializing the model
d=B.d;
d.calculateData();
d.mo.setGPU('off');

d.showB=0;
d.Rrate=1;
d.getModel();
d.resetStatus();
d.mo.isCrack=1;
d.mo.mVis=d.mo.mVis./d.vRate*0.1;%use uniform viscosity

hole_pId=d.findNearestId(B.sampleW/2,0,0);
top_pId=d.findNearestId(B.sampleW/2,0,B.sampleH);
d.Rrate=0.2;

%start building pore system
p=pore(d);
p.fluid_k=0.4615e-4;p.fluid_c=870;%use oil property, default value is water

d.mo.dT=d.mo.dT;%
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
k=k*10000;%change the permeability

pPressureHigh=100e6;%use greater pressure
pPressure0=0.1e6;%use greater pressure
%---------setting of the simulation
totalCircle=10;%default value is 40, use 10 to increase speed
dPressure=pPressureHigh/totalCircle;
stepNum=50;
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
        p.setBallPressure(hole_pId,pPressure);%set the pressure in the crack
        p.setBallPressure(top_pId,pPressure0);%set the pressure around the sample

        p.balance();
        d.balance(10);
        d.recordStatus();
        if j==0
            d.show('mV');
            return
        end
    end
    cla;%clear the previous figure
    p.show('pPressure');

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