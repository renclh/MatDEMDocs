%step1: packing the elements
clear;
fs.randSeed(1);%random model seed, 1,2,3...
B=obj_Box;%declare a box object
B.name='HydraulicBlock';
%--------------initial model------------
B.GPUstatus='auto';%program will test the CPU and GPU speed, and choose the quicker one
B.ballR=0.001;
B.isShear=0;
B.isClump=0;%if isClump=1, particles are composed of several balls
B.distriRate=0.25;%define distribution of ball radius, 
B.SET.border=0.01;
B.SET.sampleW0=0.075;
B.SET.sampleH0=0.15;
B.sampleW=B.SET.sampleW0+B.SET.border*2;%width, length, height, average radius
B.sampleL=0;%when L is zero, it is a 2-dimensional model
B.sampleH=B.SET.sampleH0*1.15;
B.boundaryRrate=0.999999;
B.BexpandRate=2;%boundary is 4-ball wider than 
B.PexpandRate=1;
B.isSample=1;
B.type='TriaxialCompression';
B.setType();
B.buildInitialModel();%B.show();
d=B.d;%d.breakGroup('sample');d.breakGroup('lefPlaten');
%you may change the size distribution of elements here, e.g. d.mo.aR=d.aR*0.95;
d.showB=1;
%--------------end initial model------------

%----------remove overlap platen elements
d.mo.setGPU('off');
delId=[d.GROUP.topPlaten(end-1:end);d.GROUP.botPlaten(end-1:end)];
d.delElement(delId);
%----------end remove overlap platen elements

%---------remove elements around the sample %this part is new code @@@@@@@
delFilter=d.mo.aX<B.SET.border|d.mo.aX>B.SET.border+B.SET.sampleW0;
sampleFilter=false(d.aNum,1);
sampleFilter(d.GROUP.sample)=true;
delId=find(delFilter&sampleFilter);
d.delElement(delId);
d.moveGroup('lefPlaten',B.SET.border,0,0);
d.moveGroup('rigPlaten',-B.SET.border,0,0);
lrPlatenId=[d.GROUP.lefPlaten;d.GROUP.rigPlaten];
d.addFixId('X',lrPlatenId);
d.addFixId('Y',lrPlatenId);
d.addFixId('Z',lrPlatenId);
%---------end remove elements around the sample

d.mo.zeroBalance();
d.mo.setShear('off');%because d.mo.isShear will be reset to 1 in d.delElement
%---------- gravity sedimentation
B.gravitySediment(1);%you may use B.gravitySediment(10); to increase sedimentation time (10)
B.compactSample(5);%input is compaction time
mfs.reduceGravity(d,5);

%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model
d.Rrate=1;
d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('Step1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
d.show('aR');