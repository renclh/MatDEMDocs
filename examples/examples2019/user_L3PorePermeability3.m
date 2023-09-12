%test the permeability of sample
%in this example, there are two material with different permeability

clear
fs.randSeed(2);
load('TempModel/PorePermeability2.mat');
sampleH=0.04;%height of sample is 4 cm
dH=1;%water head is 1m
%---------define permeability
kRate=0.5;%change the kRate to change permeability
k=2e-10*kRate;%permeability factor
lowKRate=0.1;%percentage of low permeability elements
totalBalance=100000;%increase the value when highK:lowK increase
%---------end define permeability

%-----------initializing the model
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo
d.showB=2;
d.deleteConnection('boundary');
d.Rrate=1;
d.resetStatus();
d.getModel();
d.mo.isCrack=1;
%-----------end initializing the model

%------------remove top and bottom elements of sample
sampleHcenter=mean(d.mo.aZ(d.GROUP.sample));
topModelFilter=d.mo.aZ>sampleHcenter+sampleH/2;
botModelFilter=d.mo.aZ<sampleHcenter-sampleH/2;
delId=find(topModelFilter|botModelFilter);
maxS=max(d.GROUP.sample);
delId=delId(delId<=maxS);
d.delElement(delId);
%------------end remove top and bottom elements of sample

%------------initilizing pore system
p=pore(d);
p.pathLimitRate=0.3;%path diameter<pathLimitRate*ballR will be connection
p.isCouple=1;%fluid-solid coupling
p.setInitialPores();
p.setPlaten('fix');%fix the coordinates of platens
p.aWaterdR=d.mo.aR*0.025;%defind the water diameter
p.setWaterdR();

sLength=length(d.GROUP.sample);
lowKId=randperm(sLength,round(sLength*lowKRate));
p.aWaterdR(lowKId)=p.aWaterdR(lowKId)*0.1;
p.setWaterdR();
d.mo.SET.aWaterdR=p.aWaterdR;
%d.show('SETaWaterdR');
%return
%-----------------end set cracks in the model

%--------------setting of the simulation
p.dT=p.d.mo.dT/kRate;
fName=['data/step/' B.name  num2str(B.ballR) '-lowKRate' num2str(lowKRate) 'loopNum'];
topBallId=ceil(mean(d.GROUP.topPlaten));
botBallId=ceil(mean(d.GROUP.botPlaten));

pressureHigh=p.pPressure(2)+1e3*9.8*dH;
pressureLow=p.pPressure(2);
topPoreId=p.getBallConnectedPore(topBallId);
botPoreId=p.getBallConnectedPore(botBallId);
p.pPressure(topPoreId)=pressureHigh;
p.pPressure(botPoreId)=pressureLow;
p.setPressure();%set pore pressure of seawater
p.isCouple=0;%no fluid flow coupling
%--------------end setting of the simulation

save([fName '0.mat']);%return;
%-----------apply high pressure

cDiameterFlow=p.cDiameter+p.cDiameterAdd;%calculate the diameter of
cDiameterFlow(cDiameterFlow<0)=0;
p.cKFlow=cDiameterFlow*k./p.cPathLength;%default K of throat is determined by diameter and path length

pIndex=p.getPIndex();
topPIndex=pIndex(topPoreId,:);
botPIndex=pIndex(botPoreId,:);
balanceRates=[];
%-------------balancing the pore pressure
for i=1:totalBalance
    p.pPressure(topPoreId)=pressureHigh;
    p.pPressure(botPoreId)=pressureLow;
    p.setPressure();%set pore pressure of seawater
    p.balance();%rate defines the balance time
    toppMass=p.poreFlowMass{topPIndex(1)};
    botpMass=p.poreFlowMass{botPIndex(1)};
    if mod(i,1000)==0
        fs.disp(['Calculating ' num2str(i/1000) '/' num2str(totalBalance/1000)]);
        balanceRate=-sum(botpMass,2)/sum(toppMass,2);
        balanceRates=[balanceRates;balanceRate];
        fs.disp(['Balance rate is ' num2str(balanceRate*100) ' percent']);
    end
end
%-------------end balancing the pore pressure
fs.disp('Balance of pore pressure is finished');

fs.disp('Start the permeability test');
stableT=p.totalT;
massI=0;
totalCircle=20;
stepNum=500;
topPoreMass=zeros(totalCircle*stepNum,1);
botPoreMass=zeros(totalCircle*stepNum,1);
for i=1:totalCircle
    for j=1:stepNum
        p.pPressure(topPoreId)=pressureHigh;
        p.pPressure(botPoreId)=pressureLow;
        p.setPressure();%set pore pressure of seawater
        p.balance();%rate defines the balance time
        massI=massI+1;
        toppMass=p.poreFlowMass{topPIndex(1)};
        botpMass=p.poreFlowMass{botPIndex(1)};
        topPoreMass(massI)=sum(toppMass,2);
        botPoreMass(massI)=sum(botpMass,2);
    end
    fs.disp(['Calculating ' num2str(i) '/' num2str(totalCircle)]);
    %save([fName num2str(i) '.mat']);
end

topMassAll=sum(topPoreMass);
botMassAll=sum(botPoreMass);
flowT=p.totalT-stableT;

%k = Q*L /( A*△h)
%---------calculate the hydraulic conductivity K
Q=botMassAll/1e3/flowT;
L=sampleH;
A=B.sampleW*p.pThickness;
K=Q*L/(A*dH);
fs.disp(['Permeability coefficient of the sample is ' num2str(K)]);
%---------end calculate the hydraulic conductivity K

p.show('pPressure');
p.showData('poreFlowMass');
save([fName '0.mat']);%return;