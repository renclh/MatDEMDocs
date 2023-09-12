clear;clc
fs.randSeed(2);
bBox=[0,0,0;1,0.5,0.5];
WLH=bBox(2,:)-bBox(1,:);
boxV=prod(WLH);

grainV=0.25*0.7;%packing rate: 0.7
grainR=0.5*mfs.getGradationDiameter([0.01,0.02,0.02;0.05,0.10,0.98],grainV);
%grainR=0.5*mfs.getGradationDiameter([0.005,0.010,0.015;0.025,0.050,0.985],grainV);

fineId=find((2*grainR)<0.04);

tic;sampleObj=pfs3d.genAssembly(grainR,bBox);toc
%fs.showObj(sampleObj);
%--------------------------
B=obj_Box();
B.name='ParticleMigration';
B.ballR=0.02;%mean(grainR.^3).^(1/3);
B.isSample=0;
B.sampleW=WLH(1);
B.sampleL=WLH(2);
B.sampleH=WLH(3);

B.buildInitialModel();
d=B.d;
%--------------------------
sampleId=d.addElement(1,sampleObj);
d.addGroup('sample',sampleId);
d.delElement(d.GROUP.topPlaten);
d.moveGroup('topB',0,0,-2*B.ballR);
d.show('aR')

moNum=2;
rRanges=fs.getAutoRanges(d.mo.aR,moNum);
aMoId=fs.getMoId(d.mo.aR,rRanges);
aMoId(end)=0;
d.mo.setChildModel(aMoId,rRanges);
d.addGroup('Coarse',d.mo.moCell{1}.parent_mId);
d.addGroup('Fine',d.mo.moCell{2}.parent_mId);
%---------------------------
%d.mo.mGZ(:)=0;
n=20;
for ii=1:n
   %d.mo.afterBalance='';
   d.connectGroup();
   d.deleteConnection('boundary');
   %d.mo.mVX(:)=0;
   %d.mo.mVY(:)=0;
   %d.mo.mVZ(:)=0;
   fs.limitFrame(d,d.GROUP.sample,0,1,0,0.5,0,0.5);
   d.balance('Standard',1/n);
end
d.show('-aR','EnergyCurve','ForceCurve','HeatCurve');
%histogram(d.mo.aZ(d.GROUP.Fine),linspace(bBox(1,3),bBox(2,3),21));

%---------save the data
d.mo.setGPU('off'); 
d.clearData(1);
d.recordCalHour('Step1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
