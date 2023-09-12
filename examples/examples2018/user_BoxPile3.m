clear;
load('TempModel/BoxPile2.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
%initializing
d.getModel();%d.setModel();%reset the initial status of the model
d.status=modelStatus(d);%initialize model status, which records running information, same to d.resetStatus()

d.mo.bFilter(:)=0;%break all bonds, no tensile force, same to d.breakGroup();
d.mo.isHeat=1;%calculate heat in the model
d.mo.setGPU('auto');
d.setStandarddT();
pile1Id=d.GROUP.Pile1;%get the Id of pile 1
pile1Z=d.mo.aZ(pile1Id);
topPileId=pile1Id(pile1Z>max(pile1Z)-B.ballR*0.1);%get the Id of pile top
d.addGroup('topPile',topPileId);%add a new group
d.addFixId('Z',d.GROUP.topPile);%fix the X-coordinate of the pile top

totalCircle=20;
stepNum=100;
dis=1;%total distance
dDis=dis/totalCircle/stepNum;%distance of each step
d.tic(totalCircle*stepNum);
%.mat files will be saved in the folder data/step
fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;

for i=1:totalCircle
    for j=1:stepNum
        d.toc();%show the note of time
        d.moveGroup('topPile',0,0,dDis);
        d.balance('Standard',0.01);%
        %d.balance('Standard',1); is d.balance(50,d.SET.packNum);
    end
    d.clearData(1);%clear data in d.mo
    save([fName num2str(i) '.mat']);
    d.calculateData();
end

d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxPile3Finish');
save(['TempModel/' B.name '3.mat'],'B','d');
save(['TempModel/' B.name '3R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();