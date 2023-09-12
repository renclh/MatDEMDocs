clear
figure
ballR=0.02;Rrate=0.4;
%create a hob, define the size of a hob
hobR=0.2;hobT=0.1;cutRate=2;
hob=f.run('fun/makeHob.m',hobR,hobT,cutRate,ballR,Rrate);%run function with internal functions
subplot(2,2,1);
fs.showObj(hob);%show the hob

columnR=0.05;columnHeight=0.1;
column=f.run('fun/makeColumn.m',columnR,columnHeight,ballR,Rrate);%run function with internal functions
subplot(2,2,2);
fs.showObj(column);%show the hob

moveDis=(hobT+columnHeight)/2-ballR*(1-Rrate);
column=mfs.move(column,0,0,moveDis);
hobColumn=mfs.combineObj(hob,column);
subplot(2,2,3);
fs.showObj(hobColumn);%show the hob

hobWidth=0.3;hobLength=0.5;hobHeight=1;
hobColumn2=mfs.cutBoxObj(hobColumn,hobWidth,hobLength,hobHeight);
hobColumn2=mfs.rotate(hobColumn2,'YZ',90);
hobColumn2=mfs.rotate(hobColumn2,'XY',30);
subplot(2,2,4);
fs.showObj(hobColumn2);%show the hob