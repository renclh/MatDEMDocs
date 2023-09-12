%make a box model, which will be put on a slope
clear;
fs.randSeed(1);%build random model
B=obj_Box;%build a box object
B.name='EarthMoon';
B.GPUstatus='auto';
B.ballR=7e5;
B.isClump=0;
B.distriRate=0.2;
B.sampleW=16e6;
B.sampleL=16e6;
B.sampleH=18e6;
B.setType('topPlaten');

B.buildInitialModel();%B.show();
d=B.d;
d.mo.aR(1:d.mNum)=d.mo.aR(1:d.mNum)*0.98;%reduce the element size a bit
%--------------end initial model------------
B.gravitySediment();
B.compactSample(2);
mfs.reduceGravity(d,5);%reduce the gravity of element
%------------return and save result--------------
d.status.dispEnergy();%display the energy of the model
%d.showFilter('Group',{'sample'});
d.show('mGZ');

d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('Step1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();%because data is clear, it will be re-calculated