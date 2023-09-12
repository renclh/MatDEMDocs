clear
load('TempModel/ParticleMigration1.mat');
B.setUIoutput();%set output of message
d=B.d;
d.calculateData();
d.mo.setGPU('off'); 
d.getModel();%get xyz from d.mo
d.resetStatus();
%---------------------
d.mo.aMUp(:)=0;
d.breakGroup();

coarseId=d.GROUP.Coarse;
fineId=d.GROUP.Fine;
%TR=getMesh(d,coarseId);
d.addFixId('X',coarseId);
d.addFixId('Y',coarseId);
d.addFixId('Z',coarseId);

% rigB=d.GROUP.rigB;
% rigBXYZ=[d.mo.aX(rigB),d.mo.aY(rigB),d.mo.aZ(rigB)];
% %F=vecnorm(rigBXYZ(:,[2,3])-[0.4,0.4],2,2)<0.1;
% fh=@(YZ,yz0,r0)vecnorm(YZ-yz0,2,2)<r0;
% F=fh(rigBXYZ(:,[2,3]),[0.2,0.2],0.05)|fh(rigBXYZ(:,[2,3]),[0.2,0.6],0.05);
% F=F|fh(rigBXYZ(:,[2,3]),[0.6,0.2],0.05)|fh(rigBXYZ(:,[2,3]),[0.6,0.6],0.05);
% F=F|fh(rigBXYZ(:,[2,3]),[0.4,0.4],0.05);
% 
% d.mo.aKN(rigB(F))=0;
% d.mo.aKS(rigB(F))=0;
% d.mo.setKNKS();
%d.showB=2;d.show('aKN');
d.moveGroup('rigB',0.1,0,0);

%p=build2pore(d,'Coarse');
%p.show;

w1=0.70;w2=0.20;
coarseWC=w2+(w1-w2)*(1-rescale(d.mo.aX(coarseId)));%

showFilter=abs(d.mo.aX-0.2)<0.05|abs(d.mo.aX-0.4)<0.05|abs(d.mo.aX-0.6)<0.05|abs(d.mo.aX-0.8)<0.05;
showFilter(end)=false;
showFilter(d.GROUP.Fine)=true;

saveDir=['data\',B.name,'_multifield'];
mkdir(saveDir);
save([saveDir,'\loopNum',num2str(0),'.mat']);
totalCircle=50;
steps=100;
d.tic(totalCircle);
for ii=1:totalCircle
    for jj=1:steps
        %1.场的演化
        %
        %2.建立粗颗粒场 & 梯度计算
        aPos=[d.mo.aX,d.mo.aY,d.mo.aZ];
        if ~exist('TR','var')
            TR=pfs3d.getMesh(aPos(coarseId,:),d.mo.aR(coarseId));
        end
        triGrad=pfs3d.calGrad(TR.ConnectivityList,aPos(coarseId,:),coarseWC);
        %3.映射细颗粒 & 受力计算
        fineLoc=TR.pointLocation(aPos(fineId,:));
        f=isnan(fineLoc);%out of boundingbox
        fineLoc(f)=1;%avoid index error
        fGrad=triGrad(fineLoc,:);
        fGrad(f,:)=0;
        kF=-2e4*median(d.mo.aR(coarseId))*9.8*d.mo.mM(fineId);%based on gravity
        d.mo.mGX(fineId)=fGrad(:,1).*kF;
        d.mo.mGY(fineId)=fGrad(:,2).*kF;
        d.mo.mGZ(fineId)=fGrad(:,3).*kF;
        %4.颗粒运动
        d.balance(1);
        %d.recordStatus();
    end
    %5.额外数据记录
    d.figureNumber=1;
    d.showFilter('Filter',showFilter);
    d.show('Displacement');
    frames(ii)=getframe();
    save([saveDir,'\loopNum',num2str(ii),'.mat']);
    d.toc();
end
fs.movie2gif('1.gif',frames,0.2);
%movie('1.gif');

% n=20;
% bins=linspace(0,1,n+1);
% N=histcounts(d.mo.aX(d.GROUP.Fine),bins);
% N=N/length(d.GROUP.Fine);
% plot(movmean(bins,2,'Endpoints','discard'),N,'-^')
% ylim([0.4,1.6]*1/n);
% yline(1/n,'--')

%---------save the data
d.mo.setGPU('off'); 
d.clearData(1);
d.recordCalHour('Step2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();