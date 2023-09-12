%note: this is an example to show thermomechanical coupling
%it is not completed, specified heat must considered in real applications
%Chun Liu, Nanjing University
%-------------------user_mxSlope3.m;
clear;
load('TempModel/BoxTunnelHeat2.mat');
B.setUIoutput();
%------------initialize model-------------------
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%d.setModel();%reset the initial status of the model
d.resetStatus();
d.mo.isHeat=1;%calculate heat in the model
d.setStandarddT();
d.mo.isCrack=1;
%------------end initialize model-------------------
%d.show();return;

%--------------------set block force--------------------
innerTubeId=d.GROUP.innerTube;
d.mo.SET.aT=ones(d.aNum,1)*15;%initial temperature is 15 degrees
initialT=d.mo.SET.aT(1:d.mNum);%record the initial temperatures
innerTubeT=25;
d.mo.SET.aT(d.mNum+1:d.aNum)=-1000;%boundary is insulated
mdR0=zeros(d.mNum,1);%deviation of radius of active elements
%--------------------end set block force--------------------

totalCircle=10;
stepNum=20;
fName=['data/step/' B.name  num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
gpuStatus=d.mo.setGPU('auto');
d.tic(totalCircle);%record the initial time of loop
for i=1:totalCircle
    d.mo.setGPU(gpuStatus);
    for j=1:stepNum
        %-----1. calculate the temperature difference, nTempDiff
        d.mo.SET.aT(innerTubeId)=innerTubeT;%assign temperture to innerTube group
        nRow=ones(1,size(d.mo.nBall,2));
        NBall=gather(d.mo.nBall);
        nTempDiff=d.mo.SET.aT(NBall)-d.mo.SET.aT(1:d.mNum)*nRow;%difference of water content bewteen elements and neighbors
        
        %-----2. heat conduction
        nThermalC=0.02;%Coefficient of thermal conductivity
        cbFilter=gather(d.mo.cFilter|d.mo.bFilter);%define the contact filter
        nBoundaryFilter=(d.mo.SET.aT(NBall)==-1000);%temperature of neighboring elements
        inslatedFilter=(~cbFilter|nBoundaryFilter);
        nTempFlow=nTempDiff.*nThermalC;%temperature various
        nTempFlow(inslatedFilter)=0;        
        mTempFlow=sum(nTempFlow,2);
        d.mo.SET.aT(1:d.mNum)=d.mo.SET.aT(1:d.mNum)+mTempFlow;
        %-----3. update element radius and properties according to temperature, i.e. aT
        expandRate=0.001;%expanded by 0.1% when temperature increased by 1 degree
        mdR1=gather(d.mo.aR(1:d.mNum).*(d.mo.SET.aT(1:d.mNum)-initialT)*expandRate);%describe how radius varies with T
        d.mo.aR(1:d.mNum)=d.aR(1:d.mNum)+mdR1;
        maxDis=gather(max(max(abs(d.mo.dis_mXYZ),[],2)+mdR1-mdR0));%transform data to CPU
        if (maxDis>0.5*d.mo.dSide)
            fs.disp(['balanceTime' num2str(d.mo.totalT) '->expand->setNearbyBall']);
            d.mo.setNearbyBall();
            mdR0(:)=mdR1;
        end
        %here, you may modify other properties of elements when temperature changed
        d.mo.balance();%calculation
        d.recordStatus();
    end
    %clear and save data
    d.clearData(1);
    d.mo.setGPU('off');
    save([fName num2str(i) '.mat']);
    d.calculateData();
    d.toc();%show the note of time
end

d.recordCalHour('BoxTunnelHeat3Finish');
d.mo.setGPU('off');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.show('aR');