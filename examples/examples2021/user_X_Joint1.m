clear;
fs.randSeed(2);%build random model
B=obj_Box;%build a box object
B.name='X_Joint1';
B.GPUstatus='auto';
B.ballR=50;%单元平均半径
B.isClump=0;
B.distriRate=0.2;%颗粒直径分散系数，最大直径与最小直径比值为(1+rate)^2
B.sampleW=7e3;%模型箱子内部的宽
B.sampleL=0;%模型箱子内部的长
B.sampleH=10e3;%模型箱子内部的高
B.BexpandRate=10;%边界的延伸单元数
B.PexpandRate=10;%压力板的延伸单元数
B.type='TriaxialCompression';%根据模型类型（B.type）设置三轴压力板
B.setType();
B.buildInitialModel();%建立初始模型
B.show();
B.setUIoutput();
d=B.d;

d.mo.setGPU('auto');
%--------------end initial model------------
B.gravitySediment();%让单元随机运动，并在重力作用下堆积
B.compactSample(1);%input is compaction time%利用上压力板来压实样品
%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model

d.clearData(1);%clear dependent data
d.recordCalHour('Box1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
d.show('aR');