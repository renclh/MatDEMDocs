clear;
load('TempModel/BoxShear2.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
B.name='BoxShearTorsional';
%initializing
d.getModel();%d.setModel();%reset the initial status of the model
d.status=modelStatus(d);%initialize model status, which records running information

d.mo.bFilter(:)=0;%break all bonds, no tensile force
d.mo.isHeat=1;%calculate heat in the model
d.mo.setGPU('auto');
d.setStandarddT();

d.addGroup('topBox',[d.GROUP.topTubeRing;d.GROUP.topPlaten]);

totalCircle=20;
stepNum=10;
angle=60;%total rotation
dAngle=angle/totalCircle/stepNum;%distance of each step
d.tic(totalCircle*stepNum);
%.mat files will be saved in the folder data/step
fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;

for i=1:totalCircle
    for j=1:stepNum
        d.toc();%show the note of time
        d.rotateGroup('botBox','XY',dAngle,B.sampleW/2,B.sampleL/2,0,'mo');%only d.mo data will be rotate
        d.balance('Standard',0.1);%
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