%这个代码演示了如何授权代码的使用
clear
%step0: set the parameters for simulation
ballR=0.02;%ball radius
Rrate=0.8;%0.5~0
tubeInnerR=1;
tubeInnerL=0.2;
speed=90;%rotation degree per second

totalCircle=1000;%loop time
stepNum=100;%step per loop

%step1: build the initial model
MatDEMfile('user_Roller1New.m');%original code
%MatDEMfile('user_Roller1NewPack.m');%the NewPack needs authorized
%step2: start the iteration
MatDEMfile('user_Roller2New.m');%original code
%MatDEMfile('user_Roller2NewPack.m');%the NewPack needs authorized