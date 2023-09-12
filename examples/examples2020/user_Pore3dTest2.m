clear;
load('TempModel\pore3dTest1.mat');
%-----------initializing the model
B.setUIoutput();
d=B.d;	
d.calculateData();
d.mo.setGPU('off');
d.getModel();
d.resetStatus();
%-----------end initializing the model

%------------initializing pore system
p=build2pore(d);
p.setInitialPores();

p.fKFlow(:)=1e-8;
p.setTimeStep();%you may run p.setTimeStep() when you update p.fKFlow
%------------initializing top/bottom pressure BC
refP=p.Fluids.refP;%reference pressure, for default fluid water, refP=101.325e3 Pa
pPressure=1e3*9.8*(max(p.pZ)-p.pZ)+refP;%botPre=refP, topPre=refP+rho*g*h
pLim=[min(pPressure),max(pPressure)];

topPId=unique(p.facetP(p.GROUP.topF,1));topPre=pLim(2);
botPId=unique(p.facetP(p.GROUP.botF,1));botPre=pLim(1);
%------------setting of the simulation
rate=40;
steps=400;totalCircle=80;
p.dT=p.dT*rate;%here just for demo, may reduce accuracy
prefix=['data\step\',B.name,'-'];
save([prefix,'loopNum','0','.mat']);
Qtop=0;Qbot=0;
tic;
p.setGPU('on');
%d.showFilter('SlideY',0.5,1);
for idx=(1:totalCircle)
    for ii=1:steps
    p.pPressure(topPId)=topPre;%apply top Pressure BC
    p.pPressure(botPId)=botPre;%apply bottom Pressure BC
    p.setPressure();
    p.balance();
    end
    assert(~any(isnan(gather(p.pPressure))),'boom shakalaka!!!!');%check if correct
    poreFlowMass=p.fFlowMass(p.poreFacetIdx);
    Qtop=gather(sum(poreFlowMass(topPId,:),'all'));%record boundary flow mass
    Qbot=gather(sum(poreFlowMass(botPId,:),'all'));
    %p.show('pPressure');pause(0.1);
    save([prefix,'loopNum',num2str(idx),'.mat']);
    t=toc;
    fs.disp(['Step ',num2str(idx),'/',num2str(totalCircle),' finished, elapsed ',num2str(round(t/60,1)),' minutes.']);
    fs.disp(['Balance Rate: ',num2str(-Qbot/Qtop*100),' percent']);
end

rho=1e3;
Q=Qbot/p.dT/rho;
A=0.2*0.2;J=1;
K=Q/(A*J);
fs.disp(['Permeability coefficient of the sample is ' num2str(K)]);

save(['TempModel\',B.name,'2.mat'],'B','d','p');