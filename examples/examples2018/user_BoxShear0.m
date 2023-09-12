%make a box model, which will be put on a slope
clear;
fs.randSeed(1);%build random model
B=obj_Box;%build a box object
%B.name='BoxShear';
B.name='BoxShear';
B.SET.shearType='torsional';%may change it to shear
B.GPUstatus='auto';
B.ballR=0.005;
B.isClump=0;
B.distriRate=0.2;
B.SET.sampleR=0.0309;
B.SET.sampleH=0.02;
if strcmp(B.SET.shearType,'torsional')
    B.SET.sampleR=0.0309;
    B.SET.sampleH=0.06;
end

B.sampleW=B.SET.sampleR*2.2;
B.sampleL=B.SET.sampleR*2.2;
B.sampleH=B.SET.sampleH*1.5;
%B.BexpandRate=4;
%B.PexpandRate=4;
B.type='topPlaten';
%B.type='TriaxialCompression';
B.setType();
B.buildInitialModel();%B.show();
B.setUIoutput();

d=B.d;%d.breakGroup('sample');d.breakGroup('lefPlaten');
%--------------end initial model------------
B.gravitySediment();
B.compactSample(2);%input is compaction time
mfs.reduceGravity(d,10);%reduce the gravity of element

%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model
d.show('aR');

d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('Step0Finish');
save(['TempModel/' B.name '0.mat'],'B','d');
d.calculateData();%because data is clear, it will be re-calculated