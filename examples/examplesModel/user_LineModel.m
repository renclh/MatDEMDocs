%this example includes:
%1. use line segments to generate wall boundary
%2. use d.getGroupForce to calculate force between groups
%3. use d.status.recordCommand to record data
%4. draw curves of forces according to recorded data
%5. use d.addRecordProp to record data
%6. use d.addTimeProp to generate seismic wave
clear
ballR=0.005;%when it is 0.0005, 258k elements
Rrate=0.8;
sampleW=1;sampleL=0;sampleH=1.2;
stiffnessRate=0.001;%>=0.001, use low stiffness to increase speed

%-----------step0: make left and right lines
lineX=[ballR;0.45;0.45;0.40];
lineY=zeros(size(lineX));
lineZ=[1;0.50;0.30;0.25];
curveObj1=f.run('fun/make3DCurve.m',lineX,lineY,lineZ,ballR,Rrate);
lineX=[1-ballR;0.55;0.55;0.60];
lineY=zeros(size(lineX));
lineZ=[1;0.50;0.30;0.25];
curveObj2=f.run('fun/make3DCurve.m',lineX,lineY,lineZ,ballR,Rrate);

%-----------step1: build model------------
B=obj_Box;%declare a box object
B.name='LineModel';
B.ballR=ballR;%element radius
B.sampleW=sampleW;%width, length, height
B.sampleL=sampleL;%when L is zero, it is a 2-dimensional model
B.sampleH=sampleH;
B.GPUstatus='off';
B.isSample=1;%
B.distriRate=0;
B.setType('none');%add a top platen to compact model
B.buildInitialModel();
B.setUIoutput();
d=B.d;
d.mo.setGPU('off');

discR=sampleH/4.25;
mX=d.mo.aX(1:d.mNum);
mZ=d.mo.aZ(1:d.mNum);
cx=sampleW/2;
cz=sampleH*3/4;
filter=sqrt((mX-cx).^2+(mZ-cz).^2)<discR;
d.delElement(find(~filter));

%-----------step2: import lines to the model------------
[leftLineId,rightLineId]=d.addElement(1,{curveObj1,curveObj2});
lineId=[leftLineId;rightLineId];
d.addGroup('LeftLine',leftLineId);
d.addGroup('RightLine',rightLineId);
d.addGroup('Lines',lineId);
d.setClump('Lines');
d.addFixId('X',lineId);
d.addFixId('Y',lineId);
d.addFixId('Z',lineId);

d.setModelStiffness(stiffnessRate);
d.mo.mVis=d.mo.mVis*0.01;
d.mo.aR(d.GROUP.sample)=d.mo.aR(d.GROUP.sample)*0.9;
d.mo.dT=d.mo.dT*4;
d.mo.setShear('off');
d.mo.zeroBalance();
d.resetStatus();
d.recordStatus();

%two methods are introduced to monitor the data of elements during
%simulation. Data will be recorded in d.status.SET.PROP
%---------------------the first method----------------------
%record the mean Z and VZ of elements 2000 and 2001
d.addGroup('TwoElement',[2000;2001]);%define a group
d.addRecordProp('TwoElement','aZ');%declare recording aZ
d.addRecordProp('TwoElement','mVZ');%declare recording mVZ

%generating sine wave on the leftLine group, which shakes up and down
totalBalanceNum=10000;%data number of the wave
totalT=totalBalanceNum*d.mo.dT;%total time of the wave

period=0.2;%period of the wave
Ts=(0:totalBalanceNum)*d.mo.dT;
maxA=500;%maximum acceleration
Values=maxA*sin(Ts*(2*pi)/period);
figure;plot(Ts,Values);xlabel('Ts [second]');ylabel('Z acceleration of the LeftLine [m/s^2]');
title('Wave on the LeftLine');
d.addTimeProp('LeftLine','mAZ',Ts,Values);%assign the AZ to elements of LeftLine
%d.removeTimeProp('LeftLine','mAZ');

d.addGroup('LeftLine1',d.GROUP.LeftLine(1));%define a group
d.addRecordProp('LeftLine1','aZ');%declare recording aZ
d.addRecordProp('LeftLine1','mAZ');%declare recording mAZ
%---------------------end the first method----------------------

%---------------------the second method----------------------
%@@@@@record force on a group, curves will be shown after the loop
d.status.SET.leftFZ=[];%initilize the recorded parameters
d.status.SET.leftFX=[];
d.status.SET.rightFZ=[];
d.status.SET.rightFX=[];
%@@@@@two methods to record the force of a group
%method1: use the force recorded in the d.status.nFnZ and nFnX
leftCommand='obj.SET.leftFZ=[obj.SET.leftFZ;sum(sum(d.mo.nFnZ(d.GROUP.LeftLine,:)))];obj.SET.leftFX=[obj.SET.leftFX;sum(sum(d.mo.nFnX(d.GROUP.LeftLine,:)))];';
%method2: use the d.getGroupForce, see the help for details
rightCommand='d=obj.dem;rightF=d.getGroupForce(''RightLine'');obj.SET.rightFZ=[obj.SET.rightFZ;rightF.totalFZ];obj.SET.rightFX=[obj.SET.rightFX;rightF.totalFX];';

d.status.recordCommand=[leftCommand rightCommand];
d.status.runRecordCommand();%run the command to record the first value
%record force on a group, curves will be shown after the loop
%d.show('StressZZ');return;
%---------------------end the second method----------------------

totalCircle=10;
d.tic(totalCircle);
gpuStatus=d.mo.setGPU('auto');
fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
for i=1:totalCircle
    d.mo.setGPU(gpuStatus);
    d.balance('Standard',0.04);
    d.mo.setGPU('off');
    d.figureNumber=d.show('mV');
    d.toc();
    d.clearData(1);%clear data in d.mo
    save([fName num2str(i) '.mat']);
    d.calculateData()
end

leftF=d.getGroupForce('LeftLine','sample');%force act on LeftLine (from sample)
rightF=d.getGroupForce('RightLine');%get the force on the right line

%draw curves of the first method
figure;
subplot(2,2,1);
d.status.show('PROPTwoElement_aZ');
subplot(2,2,2);
d.status.show('PROPTwoElement_mVZ');
subplot(2,2,3);
d.status.show('PROPLeftLine1_aZ');
subplot(2,2,4);
d.status.show('PROPLeftLine1_mAZ');

%draw curves of the second method
figure;
subplot(2,2,1);
d.status.show('SETleftFX');%X force of left line
subplot(2,2,2);
d.status.show('SETrightFX');%X force of right line
subplot(2,2,3);
d.status.show('SETleftFZ');
subplot(2,2,4);
d.status.show('SETrightFZ');