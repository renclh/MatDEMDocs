%set the material of the model
clear;
load('TempModel/BoxWord1.mat');
B.setUIoutput();
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo

%-----------------draw word
pictureName='slope/MatDEM.png';%word should be in black color
sX=d.mo.aX(1:d.mNum);sZ=d.mo.aZ(1:d.mNum);
imH=1200;imW=800;%image will be resized to imW*imH
%read the image and change the size,image is in black and white color
regionFilter=mfs.image2RegionFilter(pictureName,imH,imW);%white is true
sFilter=f.run('fun/applyRegionFilter.m',regionFilter,sX,sZ);
sId=find(sFilter);
sId(sId>d.mNum)=[];
d.addGroup('word',sId);

d.makeModelByGroups({'word'});
%d.mo.bFilter(:)=true;d.mo.zeroBalance();
d.setClump('word');
%d.showFilter('Group',{'word'},'aR');
d.show('aR');
view(0,-10);

%-----------save the model
d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('BoxStep2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();