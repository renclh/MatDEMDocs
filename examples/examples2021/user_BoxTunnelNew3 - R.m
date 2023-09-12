%-------------------user_mxSlope3.m;
clear;
load('TempModel/PoreTunnel2.mat');
B.setUIoutput();
%------------initialize model-------------------
d=B.d;
d.calculateData();
d.getModel();
d.mo.setGPU('off');
d.breakGroup();
d.mo.setShear('on');
d.Rrate=1;
d.resetStatus();
d.mo.isCrack=1;
d.mo.mVis=d.mo.mVis./d.vRate*0.1;
top_pId=d.findNearestId(B.sampleW/2,0,B.sampleH);

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
showType='*pPressure';
d.figureNumber=1;
%----------end set the drawing of result during iterations

%d.show('Crack');hold all;d.show('--');

%---------calculate connection diameter and flow K
k=0.00001;%permeability factor
%---------end calcualte connection diameter and flow K
%k=k*5000;%change the permeability

pPressureHigh=3.25e+07;%use greater pressure
pPressure0=0.1e6;%use greater pressure
%---------setting of the simulation
totalCircle=10;%default value is 100, use 10 to increase speed
dPressure=pPressureHigh/totalCircle;
stepNum=20;
fName=['data/step/2' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
d.tic(totalCircle*stepNum);%record the initial time of loop6547145258/*963
R4=zeros(totalCircle,1);
SUM=zeros(totalCircle,1);

tunnel_cx0=mean(d.mo.aX(d.GROUP.ring));
tunnel_cz0=mean(d.mo.aZ(d.GROUP.ring));




for i=1:totalCircle
   for j=1:stepNum
        d.toc();
        cDiameterFlow=p.cDiameter+p.cDiameterAdd;%calculate the diameter of
        cDiameterFlow(cDiameterFlow<0)=0;
        p.cKFlow=cDiameterFlow*k./p.cPathLength;%default K of throat is determined by diameter and path length
        cbFilter=d.mo.bFilter(p.cnIndex);%bonded filter of cList
        p.cKFlow(cbFilter)=p.cKFlow(cbFilter)/2;%K of intacted bond is smaller
        %set pressure
        tunnel_cx=mean(d.mo.aX(d.GROUP.ring));
        tunnel_cz=mean(d.mo.aZ(d.GROUP.ring));
        x1=tunnel_cx-6.7;
        x2=tunnel_cx+6.7;
        z1=tunnel_cz-2.5;
        z2=tunnel_cz+2.5;
        border=0.6;
        pIdLeft=pfs.getRectAreaPoreId(p,x1-border,z1,x1+border,z2);
        p.setPressure(pIdLeft,pPressureHigh); 
       pIdRight=pfs.getRectAreaPoreId(p,x2-border,z1,x2+border,z2);
         
        p.setPressure(pIdRight,pPressureHigh);
        p.pDensity(pIdLeft)=1700;
        p.pDensity(pIdRight)=1700;
        %end set pressure
        p.balance();
       %d.mo.setShear('off');
        d.balance();
        d.recordStatus();
    end
    cla;%clear the previous figure
    p.show('pPressure');
    save([fName num2str(i) '.mat']);%save data
    R4(i)=max(d.mo.aX(d.GROUP.ring))-min(d.mo.aX(d.GROUP.ring))+2*max(d.mo.aR(d.GROUP.ring));


    save([fName num2str(i) '.mat']);%save data
    d.recordStatus();

end
%---------save the data
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Step3Finish');
save(['TempModel/' B.name '4.mat'],'B','d');
save(['TempModel/' B.name '4R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
%user_makeGIF