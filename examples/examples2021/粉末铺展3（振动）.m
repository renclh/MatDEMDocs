clear;
load('增材制造汇报/粉末模型1OK.mat');
Hight=2;
ringObj=d.SET.ringObj;
d=[];
B=[];
load('增材制造汇报/增材制造020.mat');
%------------initialize model-------------------
B.setUIoutput();
d=B.d;d.calculateData();d.mo.setGPU('off');d.getModel();%get xyz from d.mo
d.delElement(d.GROUP.sample);
d.mo.setShear('on');
RingId=d.addElement(1,ringObj);d.addGroup('Ring',RingId);d.setClump('Ring');d.moveGroup('Ring',1.5,0,2.12);
d.moveGroup('Ring',0.85,0,0.65);
d.setStandarddT();
d.mo.dT=0.5*d.mo.dT;
%d.delElement(d.GROUP.sample);
%============================================
WaveN=10;
totalBalanceNum=100*0.67*WaveN;%data number of the wave
totalT=totalBalanceNum*d.mo.dT;%total time of the wave
period=2e-3;%period of the wave
Ts=((0:totalBalanceNum)*d.mo.dT.*10)';
maxA=5;%maximum acceleration
d.addGroup('Point',d.GROUP.Ring(1));%设置监测点
Values=maxA*sin(Ts*(2*pi)/period);
figure;plot(Ts,Values,'-');
d.addTimeProp('Ring','mAZ',Ts,Values);
d.addRecordProp('Point','mAZ');
%figure;d.show('aR');
%return;
%============================================
%fName=['data/滚筒铺粉OK/' B.name num2str(B.ballR) '000-' num2str(B.distriRate) 'loopNum'];save([fName '0.mat']);%return
totalCircle=5;%80
stepNum=1;%100
d.mo.setGPU('auto');
dis=0.025;%total distance
dDis=dis/totalCircle/stepNum;%distance of each step
d.tic(totalCircle*stepNum);
figure;
d.figureNumber=d.show('mAZ');%绘图的窗口号，可指定在某一窗口绘图
%save([fName num2str(0) '.mat']);
for i=1:totalCircle
    for j=1:stepNum
        d.toc();%show the note of time
        d.moveGroup('Ring',dDis,0,0,'mo');
        d.balance('Standard',0.03);%
       d.show('XDisplacement');
    end
    d.clearData(1);%clear data in d.mo
    %save([fName num2str(i) '.mat']);
    d.calculateData();
end
d.mo.setGPU('off');
figure;plot(d.status.Ts,d.status.SET.PROP.Point_mAZ(:),'ro-');
d.clearData(1);
%figure;d.showFilter('SlideY',0.45,0.05,'aR');