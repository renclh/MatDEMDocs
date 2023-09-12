clear
fs.randSeed(2);
load('TempModel/HydraulicBlockTest2.mat');
B.setUIoutput();%set output of message

%-------------set parameters of test
TestType='Tu';
isClumpBlock=1;%is pressure block a clump or not
stressZZ=0e6;%do not change it in Tu and Cu tests
stressXX=0;%do not change it in Tu and Cu tests
stressXXFinal=0e6;%do not change it in Tu and Cu tests

if strcmp(TestType,'Cu')
    stressZZFinal=-200e6;
    borderRate=0.125;
else
    stressZZFinal=20e6;
    borderRate=0.25;
end
%-------------end set parameters of test
totalCircle=20;
stepNum=100;%10~500, 100 is OK
balanceRate=0.001;%0.001~0.01, 0.002 is OK

%---------set the boundary condition
B.name=[B.name TestType];
d=B.d;
d.calculateData();
d.getModel();
d.resetStatus();
d.mo.isCrack=1;

d.mo.setGPU('off'); 
d.moveGroup('lefPlaten',-B.SET.border,0,0);
d.moveGroup('rigPlaten',B.SET.border,0,0);

%-------set the pressure blocks
borderW=B.SET.sampleW0*borderRate;%set the block size
borderH=B.SET.sampleH0*borderRate;
sFilter=false(d.aNum,1);%filter of sample
sFilter(d.GROUP.sample)=true;

lefFilter=d.mo.aX<B.SET.border+borderW;%filter of left block
lefId=find(lefFilter&sFilter);%Id of left block of sample
rigFilter=d.mo.aX>B.sampleW-B.SET.border-borderW;
rigId=find(rigFilter&sFilter);
botFilter=d.mo.aZ<borderH;
botId=find(botFilter&sFilter);
topFilter=d.mo.aZ>max(d.mo.aZ(d.GROUP.sample))-borderH;
topId=find(topFilter&sFilter);
centerId=find(sFilter&~(botFilter|topFilter|lefFilter|rigFilter));

d.addGroup('botBlock',botId);%define groups
d.addGroup('topBlock',topId);
d.addGroup('lefBlock',lefId);
d.addGroup('rigBlock',rigId);
d.addGroup('centerBlock',centerId);

%-------end set the pressure blocks

%define the parameters of loop
Ts=[];
botBlockForceZZ=[];
topBlockForceZZ=[];
lefBlockForceXX=[];
rigBlockForceXX=[];
botBoundaryForceZZ=[];
center_botBlockForceZZ=[];
center_topBlockForceZZ=[];

dStressZZ=(stressZZFinal-stressZZ)/(totalCircle*stepNum);%increment of stress
dStressXX=(stressXXFinal-stressXX)/(totalCircle*stepNum);
d.tic(totalCircle*stepNum);
fName=['data/step/' B.name  num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];

%when this value is 1, the top and bottom block will become clumps
%which will not break and generate boundary friction
if isClumpBlock==1
d.setClump('topBlock');
d.setClump('botBlock');
end

d.connectGroup('botPlaten','botB');%bond the bottom side of the sample
d.connectGroup('botPlaten','sample');
d.mo.zeroBalance();
%increase strength of bottom elements in Tu test
if strcmp(TestType,'Tu')
    botId=[d.GROUP.botBlock;d.GROUP.botPlaten;d.GROUP.botB];
    d.mo.aBF(botId)=d.mo.aBF(botId)*1000;
end

save([fName '0.mat']);%return;
gpuStatus=d.mo.setGPU('auto');
for i=1:totalCircle
    d.mo.setGPU(gpuStatus);
    for j=1:stepNum
        stressZZ=stressZZ+dStressZZ;
        areaZZ=B.SET.sampleW0*B.ballR*2;
        forceZZ=areaZZ*stressZZ;
        
        %fs.setBodyForce(d,d.GROUP.botBlock,'Z',-forceZZ);
        fs.setBodyForce(d,d.GROUP.topBlock,'Z',forceZZ);
        
        stressXX=stressXX+dStressXX;
        areaXX=B.SET.sampleH0*B.ballR*2;
        forceXX=areaXX*stressXX;
        
        fs.setBodyForce(d,d.GROUP.lefBlock,'X',-forceXX);
        fs.setBodyForce(d,d.GROUP.rigBlock,'X',forceXX);
        
        d.balance('Standard',balanceRate);
        d.recordStatus();
        
        %record the parameters and draw the curve later
        nFZ=d.mo.nFnZ+d.mo.nFsZ;
        botBlockForcezz=gather(sum(sum(nFZ(d.GROUP.botBlock,:))));
        topBlockForcezz=gather(sum(sum(nFZ(d.GROUP.topBlock,:))));
        
        nFX=d.mo.nFnX+d.mo.nFsX;
        lefBlockForcexx=gather(sum(sum(nFX(d.GROUP.lefBlock,:))));
        rigBlockForcexx=gather(sum(sum(nFX(d.GROUP.rigBlock,:))));
        
        FCB=d.getGroupForce('centerBlock','botBlock');
        FCT=d.getGroupForce('centerBlock','topBlock');
        
        Ts=[Ts,d.mo.totalT];
        botBlockForceZZ=[botBlockForceZZ;botBlockForcezz];
        topBlockForceZZ=[topBlockForceZZ;topBlockForcezz];
        lefBlockForceXX=[lefBlockForceXX;lefBlockForcexx];
        rigBlockForceXX=[rigBlockForceXX;rigBlockForcexx];
        botBoundaryForceZZ=[botBoundaryForceZZ;d.status.bottomBFs(end,3)];
        
        center_botBlockForceZZ=[center_botBlockForceZZ;FCB.totalFZ];
        center_topBlockForceZZ=[center_topBlockForceZZ;FCT.totalFZ];
        
        d.toc();%show the note of time
    end
    d.clearData(1);%clear data before saving
    save([fName num2str(i) '.mat']);
    d.calculateData();%calculate the data for further calculation
end

%draw the curves
areaZZcenter=B.SET.sampleW0*(1-borderRate*2)*B.ballR*2;

figure
plot(Ts,botBlockForceZZ/areaZZ);
hold all
plot(Ts,-topBlockForceZZ/areaZZ);
plot(Ts,lefBlockForceXX/areaXX);
plot(Ts,rigBlockForceXX/areaXX);

plot(Ts,botBoundaryForceZZ/areaZZ,'--b');
plot(Ts,-center_botBlockForceZZ/areaZZcenter,'--r');
plot(Ts,center_topBlockForceZZ/areaZZcenter,'--g');
legend('botBlock','topBlock','lefBlock','rigBlock','botBoundary','botP','topP');

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('Step3Finish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();