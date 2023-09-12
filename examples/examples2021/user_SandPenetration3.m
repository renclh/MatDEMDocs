clear;
load('TempModel/Sand_Penetration2.mat');
d.calculateData();
d.mo.setGPU('off');
B.setUIoutput();
d=B.d;
d.getModel();
d.status=modelStatus(d);

d.mo.isHeat=1;
visRate=0.0001;
d.mo.mVis=d.mo.mVis*visRate;
ProjectileId=d.GROUP.Projectile;
d.mo.mVX(ProjectileId)=-200;
d.setStandarddT();
 
gpuStatus=d.mo.setGPU('auto');

totalCircle=20;%default value is 500, use 20 to increase speed
d.tic(totalCircle);
fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;

for i=1:totalCircle
    d.mo.setGPU(gpuStatus);
    d.balance(50,2);
    d.figureNumber=1;
    d.showB=0;
    d.show('mV');
    axis([0 0.25 -1 1 -0.05 0.1]);
    axis manual
 
    d.mo.setGPU('off');
    d.clearData(1);
    save([fName num2str(i) '.mat']);
    d.calculateData();
    d.toc()
end
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Step3Finish');
save(['TempModel/' B.name '3.mat'],'d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
d.show('aR');