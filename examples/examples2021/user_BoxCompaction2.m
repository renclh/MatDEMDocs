%set the material of the model
clear
load('TempModel/BoxCompaction1.mat');
B.setUIoutput();%set the output
d=B.d;
d.calculateData();%calculate data
d.mo.setGPU('off');%close the GPU calculation
d.getModel();%get xyz from d.mo
%---------------delele elements on the top
SET=B.SET;

%--------------assign new material
matTxt=load('Mats\Soil1.txt');%load material file
Mats{1,1}=material('Soil1',matTxt,B.ballR);
Mats{1,1}.Id=1;
d.Mats=Mats;%assign new material
d.groupMat2Model({'sample'},1);%apply the new material
if isempty(SET.sampleFileName)
d.mo.mM=B.SET.grainDensity*(4/3*pi*d.mo.aR(1:d.mNum).^3);
B.convert2D(B.ballR);%change ball properties to 2D
end

%------------set of compaction @@@@@@@@@@@@@@
platenId=[d.GROUP.lefPlaten;d.GROUP.rigPlaten;d.GROUP.botPlaten;d.GROUP.topPlaten];
d.mo.aMUp(platenId)=0;

topX=d.mo.aX(d.GROUP.topPlaten);
topFilter=topX>SET.hammerX&topX<SET.hammerX+SET.hammerDiameter;
d.addGroup('hammer1',d.GROUP.topPlaten(topFilter));

topFilter=topX<SET.boxDiameter-SET.hammerX&topX>SET.boxDiameter-SET.hammerX-SET.hammerDiameter;
d.addGroup('hammer2',d.GROUP.topPlaten(topFilter));

hammer1Rate=ones(size(d.GROUP.hammer1))/length(d.GROUP.hammer1);
hammer2Rate=ones(size(d.GROUP.hammer2))/length(d.GROUP.hammer2);
SET.hammer1M0=d.mo.mM(d.GROUP.hammer1);
SET.hammer2M0=d.mo.mM(d.GROUP.hammer2);
SET.hammer1GZ0=d.mo.mGZ(d.GROUP.hammer1);
SET.hammer2GZ0=d.mo.mGZ(d.GROUP.hammer2);

SET.hammer1M=SET.hammerMass2D*hammer1Rate;
SET.hammer2M=SET.hammerMass2D*hammer2Rate;
SET.hammer1GZ=SET.hammerGZ2D*hammer1Rate;
SET.hammer2GZ=SET.hammerGZ2D*hammer2Rate;
B.SET=SET;
%------------end set of compaction @@@@@@@@@@@@@@

d.mo.setGPU('auto');
d.mo.aMUp(d.GROUP.topPlaten)=0;
%d.balanceBondedModel(0.5);
%d.breakGroup();%break all connections and glue the sample
d.balance('Standard',4);
porosity=mfs.get2DPorosity(d,0,B.sampleW,0,B.sampleH/2);
d.show('StressZZ');

d.clearData(1);%clear dependent data
d.recordCalHour('Step2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();