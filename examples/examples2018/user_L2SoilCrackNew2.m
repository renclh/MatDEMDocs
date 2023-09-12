clear
load('TempModel/SoilCrack1.mat','d');
normFactor=1;%all element has the same properties when normFactor is 0
d.calculateData();
d.mo.setGPU('off');
d.setUIoutput();
fs.randSeed(1);%determine 

initialWC=0.5;%initial water content is 50%
d.mo.SET.aWC=ones(d.aNum,1)*initialWC;
d.mo.SET.mWater=d.mo.mM.*d.mo.SET.aWC(1:d.mNum);
d.mo.SET.aWC(d.mNum+1:d.aNum)=-1;%-1 indicates isulated boundary
normDistri=fs.getDistribution('norm',d.aNum,normFactor);
d.mo.aBF=d.mo.aBF.*normDistri;%cracking is mainly influenced by normal breaking force
fs.mixProperty(d,'aBF');%value of d.aBF of element is influenced by element neighbors

d.mo.dT=d.mo.dT*4;%increase the speed of calculation

totalCircle=10;
stepNum=10;%see the teaching video and to increase the stepNum
d.tic(totalCircle*stepNum);
fName=['data/step/' d.name 'loopNum'];
save([fName '0.mat']);
fs.disp('Start calculation');
for i=1:totalCircle
    for j=1:stepNum
        d.toc();%show the note of time
        %---------------1. determine the surface of the model
        cbFilter=d.mo.cFilter|d.mo.bFilter;
        mConnectNum=sum(cbFilter,2);
        %when connection number of an element is <= 10, it is a surface
        %element
        mSurfaceFilter=(mConnectNum<=10);%this limit must be lower than 12, it can be 11 or 10
        %-----2. calculate new water content of surface elements
        d.mo.SET.aWC(mSurfaceFilter)=d.mo.SET.aWC(mSurfaceFilter)*0.999;%water content of surface element reduces
        d.mo.SET.mWater=d.mo.mM.*d.mo.SET.aWC(1:d.mNum);
        
        %-----3. update element radius and properties according to water content
        d.mo.aR(1:d.mNum)=d.aR(1:d.mNum).*(1-0.1*(initialWC-d.mo.SET.aWC(1:d.mNum))/initialWC);%describe how radius varies with water content
        %d.mo.setNearbyBall();%if elements are expanded, the command is required
        %here, you may modify other properties of elements when aWC changed
        d.mo.balance();%calculation
        
        %-----4. calculate the water content difference, nWaterDiff
        nRow=ones(1,size(d.mo.nBall,2));%a row whose width is the same as nBall  
        nWaterDiff=d.mo.SET.aWC(d.mo.nBall)-d.mo.SET.aWC(1:d.mNum)*nRow;%difference of water content bewteen elements and neighbors
        nWaterDiff(~cbFilter)=0;%if elements are not connected, water differences are zero
        nWC=d.mo.SET.aWC(d.mo.nBall);%water content of neighboring elements
        nWaterDiff(nWC==-1)=0;%boundary is isulated, water content differences also are zero
        %-----5. water migation
        nK=0.00000002;%because all elements have the same size, a uniform K is used, in case of different element radius, K will be a matrix (like nBall)
        nWaterFlow=nWaterDiff.*nK;%similar to darcy flow
        mWaterFlow=sum(nWaterFlow,2);%variation of water flow
        d.mo.SET.mWater=d.mo.SET.mWater+mWaterFlow;%new water mass of element
        d.mo.SET.aWC(1:d.mNum)=d.mo.SET.mWater./d.mo.mM;%calculate water content
        
        d.recordStatus();
    end
    %clear and save data
    d.clearData(1);
    save([fName num2str(i) '.mat']);
    d.calculateData();
end

fs.disp('Calculation finished');
d.showB=2;
d.show('SETaWC');%show the data in d.mo.SET.aWC
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('SoilCrack2Finish');
save(['TempModel/' d.name '-normFactor' num2str(normFactor) '-2.mat']);
d.calculateData();