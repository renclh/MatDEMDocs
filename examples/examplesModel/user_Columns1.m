%This code show the mixture of clumps and basic elements
clear;
%-----------step0: make object (struct data)------------
s=0.1;%size of the model
sampleW=s;sampleL=s;sampleH=s;
isSample=0;%defines whether including basic elements
ballR=0.0025;%radius of element
columnR=0.01;%size of a column
columnH=0.03;
Rrate=0.8;
columnObj=f.run('fun/makeColumn.m',columnR,columnH,ballR,Rrate);%make a column object
cellSide=sqrt(columnR*columnR*4+columnH*columnH);%define cell size of grid
xNum=floor(sampleW/cellSide);%define the number of cell along x
yNum=floor(sampleL/cellSide);
zNum=floor(sampleH/cellSide);

%make an empty initial object
allObj.X=[];allObj.Y=[];allObj.Z=[];allObj.R=[];allObj.groupId=[];
groupId=-10;%the groupId of a clump starts from -11
%making a series of columns
for i=1:xNum
    for j=1:yNum
        for k=1:zNum
            columnx=i*cellSide-cellSide/2;
            columny=j*cellSide-cellSide/2;
            columnz=k*cellSide-cellSide/2;
            newObj=columnObj;
            newObj=mfs.rotate(newObj,'YZ',rand()*360);
            newObj=mfs.rotate(newObj,'XY',rand()*360);
            newObj=mfs.move(newObj,columnx,columny,columnz);
            groupId=groupId-1;
            newObj.groupId=ones(size(newObj.X))*groupId;
            allObj=mfs.combineObj(allObj,newObj);
        end
    end
end
frame=mfs.getObjFrame(allObj);
allObj=mfs.move(allObj,(sampleW-frame.width)/2,(sampleL-frame.length)/2,(sampleH-frame.height)/2);

fs.showObj(allObj);
%-----------step1: build model------------
B=obj_Box;%declare a box object
B.name='Column';
B.ballR=ballR;%element radius
B.sampleW=sampleW;%width, length, height
B.sampleL=sampleL;%when L is zero, it is a 2-dimensional model
B.sampleH=sampleH;
B.isSample=isSample;%
B.setType('topPlaten');%add a top platen to compact model
B.buildInitialModel();
B.setUIoutput();
d=B.d;
d.mo.setGPU('off');
columnsId=d.addElement(1,allObj);
d.addGroup('columns',columnsId);
d.setClump();

%when isSample is 0, only clumps in the model
if isSample==0
    d.addGroup('sample',columnsId);
    d.mo.setShear('off');
    B.gravitySediment(10);%
else
    %when isSample is 1, basic elements are included
    d.minusGroup('sample','columns',0.8);
    d.mo.setShear('off');
    B.gravitySediment();%
end

d.setData();
f.run('fun/mixGroupId.m',d);%mix the groupId
d.showFilter('SlideZ',0.05,0.75);
d.showFilter('SlideY',0.05,0.85);
d.showFilter('SlideX',0.05,0.85);
figure;
d.show('StressZZ');
figure;
d.show('groupId');

d.status.dispEnergy();%display the energy of the model
d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('Step1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();