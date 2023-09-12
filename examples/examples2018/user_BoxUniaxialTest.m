clear
%---------------step 1: make random model
matName='mxRock';
matFile='Mats\mxRock.txt';%material file (.txt or material obj), [E,v,Tu,Cu,Mui],Mui is coefficient of intrinsic friction
blockW=0.1;blockL=0.1;blockH=0.2;ballR=0.01;%width, length, height, radius
distriRate=0.25;%define distribution of ball radius,
randSeed=1;%change the seed to create a block with different element size
randPositionSeed=2;%change it to make a new packing

saveFileLevel=2;%2:save all files, 1:save important files, 0: save one result file, -1: do not save
uniaxialStressRate=1;%default value is 1, generally do not have to change it
StandardBalanceNum=50;%define the balance number of simulation, 1-50

B=obj_Box;%build a box object
B.GPUstatus='auto';
B=mfs.makeUniaxialTestModel0(B,blockW,blockL,blockH,ballR,distriRate,randSeed);%build initial box model
mfs.mixGroupElement(B.d,'sample',randPositionSeed);%mix elements in sample
%B.d.show('aR');return;
%---------------end step 1: make random model

%---------------step 2: balance the random model
B.name=matName;
B.saveFileLevel=saveFileLevel;%save all related files
B.SET.uniaxialStressRate=uniaxialStressRate;
B.d.SET.StandardBalanceNum=StandardBalanceNum;
%assign material to model
B=mfs.makeUniaxialTestModel1(B);%sedimentation, data will be save in 'TempModel/boxUniaxial1.mat'
mfs.makeUniaxialTestModel2(B,matFile);%set the material of the model
B.d.balance('Standard',2);%two times of standard balance
fs.save(['TempModel/' B.name '1.mat'],'B',B);%initial model
%---------------end step 2: balance the random model

%---------------step 3: make unaxial compressive (Cu), tensile (Tu) and
%elastic tests (Young's modulus E and Poisson's ratio v)
B.d.mo.isCrack=1;%record the cracking process
B.d.SET.divNum=80;
mfs.makeUniaxialTest(B);%data will be saved in the folders 'data' and 'data/step'
%tested Cu, Tu, E and v will be recorded in B.d.Mats{1}.TAG.UniaxialTest
fs.save(['data/' B.name '-divNum' num2str(B.d.SET.divNum) '-balanceRate' num2str(B.d.SET.balanceRate) '.mat'],'B',B);
