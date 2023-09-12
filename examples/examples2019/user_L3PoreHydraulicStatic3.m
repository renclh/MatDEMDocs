%set the material of the model
clear
fs.randSeed(2);
load('TempModel/PoreHydraulic2.mat');
B.setUIoutput();
%---------------regular setting
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo
d.showB=2;
d.deleteConnection('boundary');
d.Rrate=1;
d.getModel();
d.mo.isCrack=1;
%---------------end regular setting

%-------------initializing the pore network
p=pore(d);
p.dT=p.d.mo.dT;
p.pathLimitRate=0.3;%path diameter<pathLimitRate*ballR will be connection
p.isCouple=0;%fluid-solid coupling
p.setInitialPores();
p.setPlaten('fix');%fix the coordinates of platens
%-------------end initializing the pore network

%-----------------set cracks in the model
C=Tool_Cut(d);%cut the model
lSurf=[0.3,0,0;10,0,5;20,0,20]/100;%load the surface data
lSurf2=[0.5,0,0;5,0,15]/100;%load the surface data
C.addSurf(lSurf);%add the surfaces to the cut
C.addSurf(lSurf2);%add the surfaces to the cut
s1Filter=d.setSurfBond(C.Surf(1),'break');
s2Filter=d.setSurfBond(C.Surf(2),'break');
%-----------------end set cracks in the model
d.show('--');
C.showSurf();

%---------calculate connection diameter and flow K
k=0.00000001;%permeability factor
%---------end calcualte connection diameter and flow K
k=k/10;
pPressureHigh=p.pPressure(1)*10000;%use greater pressure

for step=1:2000
    cDiameterFlow=p.cDiameter+p.cDiameterAdd;%calculate the diameter of
    cDiameterFlow(cDiameterFlow<0)=0;
    cbFilter=d.mo.bFilter(p.cnIndex);%bonded filter of cList
    cs1Filter=s1Filter(p.cnIndex);%s2Filter, select connection of crack 2
    cs2Filter=s2Filter(p.cnIndex);%s2Filter, select connection of crack 2
    
    p.cKFlow=cDiameterFlow*k./p.cPathLength;%default K of throat is determined by diameter and path length
    p.cKFlow(cbFilter)=p.cKFlow(cbFilter)*0.01;%K of intacted bond is very small
    p.cKFlow(cs1Filter)=p.cKFlow(cs1Filter)*2;%bottom crack K is greater
    p.cKFlow(cs2Filter)=p.cKFlow(cs2Filter)*1;%top crack K is greater
    p.setBallPressure(1,pPressureHigh);%you may fix the element
    p.balance();
end
p.show('pPressure');

%---------save the data
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Step3Finish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();