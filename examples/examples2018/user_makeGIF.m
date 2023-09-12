clear frames;
indexBegin=0;%begin index of data file
indexEnd=10;%end index of data file
showType='StressZZ';
for showCircle=(indexBegin:indexEnd)
load([fName num2str(showCircle) '.mat']);%load the saved file
d.calculateData();%calculate the data of the model
%d.showFilter('SlideY',0.5,1);%cut the model if necessary
d.showB=3;%show the frame
d.isUI=0;
d.show(showType);%show the result
%view(10*showCircle,30);
set(gcf,'Position',[10,10,1000,600]);%set the size of the figure
frames(showCircle+(1-indexBegin))=getframe();%record the figure
pause(0.1);%pause 0.1 second
close;%close the figure
end
dTime=0.5;%time step of GIF
fs.movie2gif([fName(11:end) showType '33.gif'],frames,dTime);%save the gif;