ufs.setTitle('MatDEM滚筒搅拌实时模拟');
%set the material of the model
clear;

speed=180;%rotation degree per second
load('TempModel/Roller1.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo

d.showB=2;
showType='mV';
d.showFilter('Group',{'tube','sample'});
d.status.legendLocation='West';
figureNumber=d.show(showType);
d.figureNumber=figureNumber;

d.mo.setShear('off');
d.setStandarddT();
d.mo.dT=d.mo.dT*4;

gpuStatus=d.mo.setGPU('auto');

dAngle=speed*d.mo.dT;%rotation angle per time step

totalCircle=100;
stepNum=5;
d.tic(totalCircle);
fName=['data/step/' B.name num2str(B.ballR) '-' num2str(B.distriRate) 'loopNum'];
save([fName '0.mat']);%return;
for i=1:totalCircle
    for j=1:stepNum
        d.rotateGroup('tube','XZ',dAngle,d.SET.Cx,d.SET.Cy,d.SET.Cz,'mo');
        d.balance();
    end
    d.recordStatus();
    d.showFilter('Group',{'tube','sample'});
    d.show(showType);
    d.toc();%show the note of time
    pause(0.05);
end

setappdata(0,'simpleFigure',0);
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxTunnelHeat2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
%--------------------end save data-----------------------
d.calculateData();