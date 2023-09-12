clear
R=1e-4;r=R./cosd(30);h=sqrt((2*R).^2-r.^2);
theta=linspace(0,360,4);theta=theta(1:end-1).';
mX=r.*[0;cosd(theta);0];mY=r.*[0;sind(theta);0];mZ=h.*[-1;zeros(3,1);1];
mR=ones(size(mX)).*R;
Mo=struct('X',mX,'Y',mY,'Z',mZ,'R',mR);
%fs.showObj(Mo);

p=pore3d(mX,mY,mZ,mR);
p.setInitialPores();
pre0=p.pPressure(1);
p.pPressure(1)=pre0+1e4*2*R;
p.pDen=pfs3d.setDensity(p.pPressure);

rate=1;
p.dT=1e-11/rate;steps=50*rate;
t=p.dT*(0:steps);
pre=zeros(steps+1,2);pre(1,:)=p.pPressure;

figure;
AL1=animatedline('Color','b','LineWidth',1);
AL2=animatedline('Color','r','LineWidth',1);
xlabel('\fontname{Times New Roman}Time / s');
ylabel('\fontname{Times New Roman}Pressure / Pa');
tic
for ii=1:steps
    p.balance();
    pre(ii+1,:)=p.pPressure;
    %if std(p.pPressure)/mean(p.pPressure)<1e-6,disp(ii);return;end
    if any(isnan(p.pPressure))
        error('Boom Shakalaka in step %d',ii);
    end
    
    addpoints(AL1,t(ii),pre(ii,1)-pre0);
    addpoints(AL2,t(ii),pre(ii,2)-pre0);
    drawnow;
end
toc
%plot(t,pre-1e5,'-*')