%in this code, we will learn how to generate seismic wave and make
%receivers to record data of seismic wave
clear;
load('TempModel/BoxWave2.mat');
d.calculateData();
d.mo.setGPU('off');
B.setUIoutput();
d=B.d;
d.getModel();%d.setModel();%reset the initial status of the model
d.resetStatus();%initialize model status, which records running information
d.mo.isHeat=1;%calculate heat in the model
visRate=0.0001;
d.mo.mVis=d.mo.mVis*visRate;
d.mo.isCrack=1;

%---------------------define the source of the wave
%leftBlock is used to generate wave
mX=d.mo.aX(1:d.mNum);
leftFilter=mX<B.sampleW*0.05;
d.addGroup('leftBlock',find(leftFilter));
%generating sine wave on the leftLine group
totalBalanceNum=10000;%data number of the wave
totalT=totalBalanceNum*d.mo.dT;%total time of the wave

period=1e-4;%period of the wave
Ts=(0:totalBalanceNum)*d.mo.dT;
maxA=100;%maximum acceleration
Values=maxA*sin(Ts*(2*pi)/period);

waveProp='mAX';
d.addTimeProp('leftBlock',waveProp,Ts,Values);%assign the AZ to elements of LeftLine
d.addRecordProp('leftBlock',waveProp);%declare recording mAZ
%---------------------end define the source of the wave

%-------------------define the receiver
receiverNum=6;%receiver number
centerx=B.sampleW/receiverNum;%center position of the receiver
centery=0;
centerz=B.sampleH/2;
R=B.ballR*4;%radius of the receiver
gNames={};
prop1='mAX';%record the property 1
prop2='aX';%record the property 2
for i=1:receiverNum
    gName=['Receiver' num2str(i)];
    gNames=[gNames(:);gName];
    f.run('fun/defineSphereGroup.m',d,gName,centerx*i,centery,centerz,R);
    d.addRecordProp(gName,prop1);%declare recording mAZ
    d.addRecordProp(gName,prop2);%declare recording mAZ
end
figure;
subplot(2,1,1);
d.setGroupId();
d.showFilter('Group',gNames,'aR');
subplot(2,1,2);
plot(Ts,Values);xlabel('Ts [second]');ylabel('X acceleration of the leftBlock [m/s^2]');title('Wave on the leftBlock');
%-------------------end define the receiver

gpuStatus=d.mo.setGPU('auto');
totalCircle=30;
d.tic(totalCircle);
fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
figure;
d.figureNumber=d.show('mV');
for i=1:totalCircle
    d.mo.setGPU(gpuStatus);
    d.balance('Standard',0.01);
    d.show('mV');
    d.clearData(1);
    save([fName num2str(i) '.mat']);
    d.calculateData();
    d.toc();%show the note of time
end
d.mo.setGPU('off');

%show the curves
curveFigure=figure;
for i=1:receiverNum
    subplot(6,2,i*2-1);
    d.status.show(['PROPReceiver' num2str(i) '_' prop1]);
    subplot(6,2,i*2);
    d.status.show(['PROPReceiver' num2str(i) '_' prop2]);
end
set(curveFigure, 'position', get(0,'ScreenSize'));

d.clearData(1);
d.recordCalHour('BoxCrush3Finish');
save(['TempModel/' B.name '3.mat'],'d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();