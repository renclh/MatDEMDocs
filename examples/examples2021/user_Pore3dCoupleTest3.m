warning off;
clear;
load('TempModel\pore3dCoupleTest2.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();
d.resetStatus();
%-----------------------
d.mo.mVis=d.mo.mVis./d.vRate*0.1;
d.mo.SET.isBalanceData=1;

p=build2pore(d);
p.setInitialPores();
%p.setPlaten('fix')

p.fKFlow(:)=1e-8;
%p.setTimeStep();
p.dT=d.mo.dT;
%tInterval=floor(p.dT/d.mo.dT);
%p.dT=d.mo.dT*tInterval;
%p.SET.tInterval=tInterval;
%------------------------
cXYZ=[median(p.X),median(p.Y),median(p.Z)];
[~,pId]=min(sum(([p.pX,p.pY,p.pZ]-cXYZ).^2,2));
refP=p.Fluids.refP;
cPre=refP+4e8;

p.setPressure(pId,cPre);
p.SET.totalMass0=sum(p.pMass);
pSign=p.pSign;

p.SET.pVolOld=p.pVol;
p.SET.killPoreId=p.SET.pVolOld<10*median(p.SET.pVolOld);

p.setCouple('on');
d.showFilter('SlideY',0.48,1);
% h=line(0,NaN);
totalCircle=20;stepNum=50*4;
d.tic(totalCircle);
save(['data\step\loopNum',num2str(0),'.mat'],'d');
for ii=1:totalCircle
    assert(~any(isnan(p.pPressure)),'boomshakalaka!!!')
    p.SET.pPressure=p.pPressure-refP;
     p.show('SETpPressure');
    view([0,-1,0]);colorbar();
    drawnow;
    for jj=1:stepNum
    p.setPressure(pId,cPre);
    %disp(sum(p.pMass)-p.SET.totalMass0);
    %disp(max(max(sqrt(d.mo.nFnX.^2+d.mo.nFnY.^2+d.mo.nFnZ.^2)./d.mo.nKNe))./median(d.aR));
    p.balance(2);
    if p.isCouple
        p.fluid2Ball();
        p.d.balance();%p.ball2Fluid();
    end
%     k=(max(abs(sum(p.poreFlowMass,2)./p.pMass)));
%     [k,ki]=max(abs(log10(p.SET.pVolOld./p.pVol)));
%     ki;
%     h.XData(end+1)=h.XData(end)+1;
%     h.YData(end+1)=k;
%     drawnow limitrate 
    %p.show('SETpPressure');
    %view([0,-1,0]);
    %drawnow
    end    
    d.toc();
    save(['data\step\loopNum',num2str(ii),'.mat'],'d');
end
d.showFilter('SlideY',0.48,1);
figure;p.show('SETpPressure');view([0,-1,0]);
d.show('Displacement')
