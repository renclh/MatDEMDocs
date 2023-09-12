%---------------1. load data
clear
load('TempModel/BoxMicroParticle1.mat');
B.setUIoutput();%set output of message
d=B.d;
d.calculateData();
d.mo.setGPU('off');
d.getModel();%get xyz from d.mo

%---------------2. get the gray rank matrix
fileName='slope\micro particle.PNG';%the file to 
source=imread(fileName);%read image
source=double(source);%change to double data
imH=size(source,1);imW=size(source,2);%the height and width of the image
RGB=(source(:,:,1)*256+source(:,:,2))*256+source(:,:,3);%changed to RGB values
RGB=flipud(RGB);%flip data along vertical direction
[uColor,iA,iC]=unique(RGB);%find unique color
Gray=mean(source,3);%get gray level
Gray=flipud(Gray);%flip data along vertical direction
uGray=Gray(iA);%unique gray level
[v,grayI]=sort(uGray);%sort the groupId according to gray level
GrayRank=reshape(grayI(iC),size(Gray));%gray rank matrix

%---------------3. get the groupId of clump by image
sampleId=d.GROUP.sample;%the sample group will be used
sampleX=d.mo.aX(sampleId);
sampleZ=d.mo.aZ(sampleId);
sampleR=d.mo.aR(sampleId);

x1=min(sampleX-sampleR);%get the four limits of the model
x2=max(sampleX+sampleR);
z1=min(sampleZ-sampleR);
z2=max(sampleZ+sampleR);
sFilter=false(d.mNum,1);
sFilter(d.GROUP.sample)=true;%filter of elements

dX=(x2-x1)/imW;
dZ=(z2-z1)/imH;
imageXI=ceil((sampleX-x1)/dX);%get the location of element in image
imageZI=ceil((sampleZ-z1)/dZ);

startId=min([d.GROUP.groupId;-10])-1;%clump starts from -11 or lowest groupId-1
GrayGId=-GrayRank+1+startId;%change gray rank to groupId
imageIndex=(imageXI-1)*imH+imageZI;%element index in image
imageGId=GrayGId(imageIndex);%element groupId in image

%---------------4. set the clump by groupId
d.GROUP.groupId(sFilter)=imageGId;%assing groupId to the group
d.setClump();%set clump for groupId<=-11
delFilter=d.GROUP.groupId==startId;%groupId of pores is startId
d.delElement(find(delFilter));%delete pores

figure
subplot(1,2,1);
imshow(fileName);
subplot(1,2,2);
d.showData('groupId');
colorbar off;

%---------------5. save the data
d.mo.setGPU('off');
d.clearData(1);
d.recordCalHour('BoxModel2Finish');
save(['TempModel/' B.name '2.mat'],'B','d');
save(['TempModel/' B.name '2R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();