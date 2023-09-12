clear;
ballR=0.001;
discR=0.01;
holeR=0.006;
poleL=0.1;
Rrate=0.8;
discObj0=f.run('fun/makeDisc.m',discR,ballR*0.8);%define the basic disc
discObj0.R=discObj0.R/0.8;
discObj0=mfs.cutBoxObj(discObj0,discR*2.1,discR*1.5,1);
f=sqrt(discObj0.X.^2+discObj0.Y.^2)>holeR;
discObj0=mfs.filterObj(discObj0, f);
fs.showObj(discObj0);

dDis=ballR*2*Rrate;
num=ceil(poleL/dDis);
dDis=poleL/num;
dAngle=360/num;

allObj.X=[];allObj.Y=[];allObj.Z=[];allObj.R=[];
for i=1:num
    discObjNew=mfs.rotate(discObj0,'XY',dAngle*i);
    discObjNew=mfs.move(discObjNew,0,0,dDis*i);
    allObj=mfs.combineObj(allObj,discObjNew);
end
figure;
fs.showObj(allObj);