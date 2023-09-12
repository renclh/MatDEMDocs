%build the geometrical model
clear;
%--------------initial model------------
fs.randSeed(1);%build random model
B=obj_Box;%build a box object
B.name='BoxStruct';
%B.type='TriaxialCompression';
B.GPUstatus='auto';
B.ballR=200;%average radius of elements
B.isClump=0;%make clump particles?
B.distriRate=0.2;%distribution coefficient
B.sampleW=10000;%sample size, width
B.sampleL=20000;%length
B.sampleH=4000;%height
B.setType();

B.buildInitialModel();%B.show();
B.setUIoutput();%set the output of the message

d=B.d;
d.showB=1;%show boundary elements
%d.breakGroup('sample');d.breakGroup('lefPlaten');

%--------------end initial model------------
B.gravitySediment(0.5);
B.compactSample(1);%input is compaction time
%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model

d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('BoxStruct0Finish');
save(['TempModel/' B.name '0.mat'],'B','d');
save(['TempModel/' B.name '0R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();%because data is clear, it will be re-calculated