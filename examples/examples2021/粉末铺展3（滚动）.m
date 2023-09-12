clear;
load('增材制造汇报/粉末模型1.mat');
ringObj=d.SET.ringObj;
RingR=((max(ringObj.Z)+max(ringObj.R))-(min(ringObj.Z)-min(ringObj.R)))/2;
d=[];
B=[];
%load('增材制造/增材制造汇报/增材制造2.mat');
load('增材制造汇报/增材制造020.mat');
%------------initialize model-------------------
B.setUIoutput();
d=B.d;d.calculateData();d.mo.setGPU('off');d.getModel();%get xyz from d.mo
d.mo.setShear('on');
RingId=d.addElement(1,ringObj);d.addGroup('Ring',RingId);d.setClump('Ring');d.moveGroup('Ring',1.5,0,2.12);%2.12
d.addFixId('XYZ', d.GROUP.Ring);
d.moveGroup('Ring',0.85,0,0.65);
d.setStandarddT();
d.mo.dT=5*d.mo.dT;
%d.delElement(d.GROUP.sample);
%figure;d.show('aR');
%return;%d.show('Id');%
fName=['data/滚筒铺粉OK/' B.name num2str(B.ballR) '000-' num2str(B.distriRate) 'loopNum'];save([fName '0.mat']);%return
totalCircle=8;%40
stepNum=1;%20
d.mo.setGPU('auto');
dis=0.0024;%total distance
dDis=dis/totalCircle/stepNum;%distance of each step
d.tic(totalCircle*stepNum);
%figure;
d.figureNumber=d.show('aR');%绘图的窗口号，可指定在某一窗口绘图
save([fName num2str(0) '.mat']);
for i=1:totalCircle
    for j=1:stepNum
        d.toc();%show the note of time
        d.moveGroup('Ring',dDis,0,0,'mo');
         d.rotateGroup('Ring', 'XZ',  -dDis/(2*pi*RingR)*360);
        %d.balance('Standard',0.02);%
    end
    d.clearData(1);%clear data in d.mo
    save([fName num2str(i) '.mat']);
   d.show('aR');
    d.calculateData();
end

d.mo.setGPU('off');
d.clearData(1);
figure;d.showFilter('SlideY',0.45,0.05,'aR');