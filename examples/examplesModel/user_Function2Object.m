%这个代码演示了如何利用函数来生成和修改物体，并将其导入到模型中
%using functions to build objects, modify and import objects
clear;
a1=f.run('examples/funtest.m',1,2,3);%sum of 1,2,3, a1 will be 6
%step1: make object (struct data)
hobObj=f.run('fun/makeHob.m',0.2,0.1,1,0.01,0.8);%see the function file about the input parameters
curveObj=f.run('fun/make3DCurve.m',[0;1;2;3],[2,3,5,3],[3,5,2,1],0.05,0.8);
columnObj=f.run('fun/makeColumn.m',0.1,0.28,0.01,0.8);
ringObj=f.run('fun/makeRing.m',0.1,3,0.01,0.6);
ringObj3D=mfs.make3Dfrom2D(ringObj,0.6,0.01);

%step2: modify and combine the object, more operations can be found in help->mfs
ringObj3D2=mfs.rotate(ringObj3D,'YZ',60);%rotate the object and then move it
ringObj3D2=mfs.move(ringObj3D2,0.5,0.5,0.5);
hobObj2=mfs.move(hobObj,0.5,0.8,0.2);
columnObj2=mfs.move(columnObj,0.5,0.5,0.3);
[columnObj2,ringObj3D2]=mfs.alignObj('front',columnObj2,ringObj3D2);%align objects
allObj=mfs.combineObj(ringObj3D2,hobObj2,columnObj2);%combine the objects
%figure;fs.showObj(allObj);

figure;%draw objects
subplot(2,2,1);%use subplot to draw four figures
fs.showObj(hobObj);
subplot(2,2,2);
fs.showObj(curveObj);
subplot(2,2,3);
fs.showObj(columnObj);
title('This is a column');
subplot(2,2,4);
fs.showObj(ringObj3D);
title('This is a ring');

%step3: make a Box, and import the objects to the box
B=obj_Box;%declare a box object
B.name='Objects';
B.ballR=0.01;%element radius
B.sampleW=1;%width, length, height
B.sampleL=1;%when L is zero, it is a 2-dimensional model
B.sampleH=1;
B.isSample=0;%an empty box without sample elements
B.setType('botPlaten');%add a top platen to compact model
B.buildInitialModel();

d=B.d;
[ringId,hobId,columnId]=d.addElement(1,{ringObj3D2,hobObj2,columnObj2});
d.addGroup('ring',ringId);
d.addGroup('hob',hobId);
d.addGroup('column',columnId);

figure;%show the model
d.setGroupId();%set groupId for each group
d.show('groupId');
view(30,20);