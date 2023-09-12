%用于展示自定义函数和全局参数的使用
%show the use of functions and global parameters
clear;
f.clearFunction();%clear all defined functions
f.define('examples/funTest.m');%define the function to increase the speed
f.define('fun/makeColumn.m');
f.define('fun/makeDisc.m');

functionList=f.getFunctionList();%list of defined functions
columnObj=f.run('fun/makeColumn.m',0.1,0.28,0.01,0.8);
figure;
fs.showObj(columnObj);

f.setGlobalData('data1',1234);
data=f.getGlobalData('data1');