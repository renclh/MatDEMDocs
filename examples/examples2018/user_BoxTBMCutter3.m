clear;
load('TempModel/BoxTBMCutter2.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
%initializing
d.getModel();%d.setModel();%reset the initial status of the model
d.mo.mVX(:)=0;d.mo.mVY(:)=0;d.mo.mVZ(:)=0;
d.status=modelStatus(d);%initialize model status, which records running information


d.mo.isHeat=1;%calculate heat in the model
visRate=0.00001;
d.mo.mVis=d.mo.mVis*visRate;
d.setStandarddT();%set standard step time

%--------------define the interation
totalCircle=20;stepNum=100;
balanceNum=5;%you may use greater stepNum and balanceNum
disp(['Total real time is ' num2str(d.mo.dT*totalCircle*stepNum*balanceNum)]);
d.tic(totalCircle*stepNum);
fName=['data/step/' B.name  num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];

%define the movement of the hob
sampleX=d.mo.aX(d.GROUP.sample);
hobX=d.mo.aX(d.GROUP.Hob);
hobR=(max(hobX)-min(hobX))/2+B.ballR*2;
dis=(max(sampleX)-min(sampleX))-hobR*2;
Dis=[1,0,-0.1]*dis;
dDis=Dis/(totalCircle*stepNum);
dDis_L=sqrt(sum(dDis.^2));
dAngle=dDis_L/hobR*180/pi;

%d.show('Displacement');return;
d.mo.bFilter(:)=1;%bond all elements
d.mo.zeroBalance();
save([fName '0.mat']);%return;
gpuStatus=d.mo.setGPU('auto');
for i=1:totalCircle
    d.mo.setGPU(gpuStatus);
    for j=1:stepNum
        d.moveGroup('Hob',dDis(1),dDis(2),dDis(3));
        hobId=d.GROUP.Hob;%rotate the hob along its center (last element)
        hobCx=gather(d.mo.aX(hobId(end)));
        hobCy=gather(d.mo.aY(hobId(end)));
        hobCz=gather(d.mo.aZ(hobId(end)));
        d.rotateGroup('Hob','XZ',-dAngle,hobCx,hobCy,hobCz);
        d.balance(balanceNum);
        d.recordStatus();
        d.toc();%show the note of time
    end
    d.clearData(1);%clear data before saving
    save([fName num2str(i) '.mat']);
    d.calculateData();%calculate the data for further calculation
end

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxTBMCutter3Finish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();