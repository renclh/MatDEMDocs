clear;
load('TempModel/3AxialTest2.mat');
A.setUIoutput();%set the output message
d=A.d;
d.calculateData();
d.mo.setGPU('off');%please always close the GPU when modifing the model
%----------set the parameters of numerical simulation
balanceRate=1;
balanceNum=20;%balance number in each step
loopNum=0;
totalCircle=5;%default value is 50
stepNum=100;
isSave=1;%save the .mat data

d.setStandarddT();%set the standard step time
d.mo.dT=d.mo.dT/balanceRate;
A.moveTop();%move top boundary to the top of the sample
%-----------set the loop-------------
platenArea=pi*A.sampleR^2;%the area of the platen
forceStep=A.stressStep*platenArea;%get the force step on the platen
botPlatenNum=length(d.GROUP.botPlaten);%element number of the platen
sampleH=mean(d.mo.aZ(d.GROUP.topPlaten))-mean(d.mo.aZ(d.GROUP.botPlaten));%original height of model
d.status=modelStatus(d);%initialize the status recorder
if strcmp(A.loadingType,'stress')
    totalCircle=length(forceStep);
end

botPlatenZZ=zeros(totalCircle+1,1);%initialize the position of bottom platen
topPlatenZZ=zeros(totalCircle+1,1);
botStressZZ=zeros(totalCircle+1,1);%initialize the position of bottom boundary
topStressZZ=zeros(totalCircle+1,1);
botPlatenZZ(1)=mean(d.mo.aZ(d.GROUP.botPlaten));
topPlatenZZ(1)=mean(d.mo.aZ(d.GROUP.topPlaten));
d.mo.mGZ(:)=0;
%-----------end set the loop-------------
%-----------the loop-------------
fName=['data/step/' A.name  num2str(A.ballR) '-' num2str(A.distriRate) 'loopNum'];
d.tic(totalCircle*stepNum);%record start time
save([fName '0.mat']);%return;
for circle=1:totalCircle
    if strcmp(A.loadingType,'stress')%when loading type is stress
        d.mo.mGZ(d.GROUP.topPlaten)=forceStep(circle)/botPlatenNum;%increase the stress
    end
    for step=1:stepNum
        for i=1:balanceNum*balanceRate
            d.mo.balance();
        end
        %d.status.SET.isWHT=1;%record the WHT in recordStatus
        d.recordStatus();
        d.toc();%show the note of time
    end
    botPlatenZZ(circle+1)=mean(gather(d.mo.aZ(d.GROUP.botPlaten)));
    topPlatenZZ(circle+1)=mean(gather(d.mo.aZ(d.GROUP.topPlaten)));
    botStressZZ(circle+1)=gather(d.status.bottomBFs(end,3))/platenArea;
    topStressZZ(circle+1)=gather(d.status.topBFs(end,3))/platenArea;
    if isSave==1
        d.clearData(1);
        save([fName num2str(circle) '.mat']);
        d.calculateData();
    end
end
A.data.topPlatenZZ=topPlatenZZ;%record the data
A.data.topStressZZ=topStressZZ;
A.data.botPlatenZZ=botPlatenZZ;
A.data.botStressZZ=botStressZZ;
A.data.sampleH=sampleH;

if  strcmp(A.loadingType,'stress')&&strcmp(A.type,'3Axial')
    loopNum=10;
end
for circle=1:loopNum%additional balance loops
    d.balance(100,5);%balance the model 500 times, record 5 times
    save(['data\step\' A.type '-R' num2str(A.ballR) '-' num2str(A.distriRate) 'circleLoop' num2str(circle) '.mat'],'A','d');
end
%-----------end the loop-------------

%------------return and save result--------------
d.setData();%set data for show()
data=A.data;
%calculate the strain and stress of sample
dPlatenZZ=data.topPlatenZZ-data.topPlatenZZ(1);
A.data.strain=-dPlatenZZ/data.sampleH;
A.data.stress=-data.botStressZZ;
figure;
plot(A.data.strain,A.data.stress,'-o');
xlabel('StrainZZ');
ylabel('StressZZ');

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('AxialStep3Finish');
save(['TempModel/' A.name '3.mat'],'A','d');
save(['TempModel/' A.name '3R' num2str(A.ballR) '-distri' num2str(A.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();