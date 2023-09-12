clear;
load('TempModel/EarthMoon2.mat');
d.calculateData();
d.mo.setGPU('off');
B.setUIoutput();
d=B.d;
d.getModel();%reset the initial status of the model
d.resetStatus();%initialize model status, which records running information
d.mo.isHeat=1;%calculate heat in the model

visRate=0.0000;
d.mo.mVis=d.mo.mVis*visRate;
d.mo.mVY(d.GROUP.earth)=0;
d.mo.mVY(d.GROUP.sphere2)=5e3;
d.mo.mVX(d.GROUP.box)=-3e3;
planetfs.setZeroMomentum(d);
%----------set the drawing of result during iterations
showType='mV';
d.showB=4;%only frame is shown

groupCenter=planetfs.getGroupCenter(d);%record the center of each group
earthCenter=groupCenter.earth;
sphere2Center=groupCenter.sphere2;
boxCenter=groupCenter.box;
%----------end set the drawing of result during iterations
gpuStatus=d.mo.setGPU('auto');
totalCircle=100;

calGInterval=2;%gravitation calculation interval
recordInterval=2;%recordStatus interval
d.mo.dT=d.mo.dT*4;
d.tic(totalCircle);
fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
for i=1:totalCircle
    for j=1:100
        %---------computing
        d.balance();
        if mod(j,calGInterval)==0
            planetfs.resetmGXYZ(d);
            if B.SET.fastGroupModel==1
                planetfs.setGroupOuterGravitation(d,{'earth','sphere2','box'});
            else
                planetfs.setModelGravitation(d);
            end
        end
        
        %---------limit space
        sphereR=B.SET.spaceSize*sqrt(2)/2;
        planetfs.limitElementInSphere(d,sphereR);
        
        %---------record data
        if mod(j,recordInterval)==0
            groupCenter=planetfs.getGroupCenter(d);
            earthCenter=[earthCenter;groupCenter.earth];
            sphere2Center=[sphere2Center;groupCenter.sphere2];
            boxCenter=[boxCenter;groupCenter.box];
            d.recordStatus();
        end
    end
    %---------show the result
    d.figureNumber=d.show(showType);
    view(0,90);
    plot3(earthCenter(:,1),earthCenter(:,2),earthCenter(:,3),'-b');
    plot3(sphere2Center(:,1),sphere2Center(:,2),sphere2Center(:,3),'-r');
    plot3(boxCenter(:,1),boxCenter(:,2),boxCenter(:,3),'-k');
    
    save([fName num2str(i) '.mat']);
    pause(0.05);
end

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxCrush3Finish');
save(['TempModel/' B.name '3.mat'],'d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();