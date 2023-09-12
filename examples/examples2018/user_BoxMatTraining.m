clear
%---------------set parameters for material training
matName='mxRock2';
matFile=['Mats\' matName '.txt'];%material file, [E,v,Tu,Cu,Mui],Mui is coefficient of intrinsic friction
blockW=0.1;blockL=0.1;blockH=0.2;ballR=0.005;%width, length, height, radius
distriRate=0.2;%define distribution of ball radius, value from 0 to 0.5
interationNum=6;%number of interation, value from 3 to 6

randSeed=2;%change the seed to create a different model
saveFileLevel=2;%2:save all files, 1:save important files, 0: save one result file, -1: do not save
uniaxialStressRate=1;%default value is 1, generally do not have to change it
StandardBalanceNum=20;%define the balance number of simulation, 1-50

%--------------build initial model
B=obj_Box;%build a box object
B.GPUstatus='auto';
B=mfs.makeUniaxialTestModel0(B,blockW,blockL,blockH,ballR,distriRate,randSeed);%build initial box model

%you may change element size here
B.name=matName;
B.saveFileLevel=saveFileLevel;%save all related files
B.SET.uniaxialStressRate=uniaxialStressRate;
B.d.SET.StandardBalanceNum=StandardBalanceNum;
%-------------assign material to model
B=mfs.makeUniaxialTestModel1(B);%sedimentation, data will be save in 'TempModel/boxUniaxial1.mat'
B.save(1);%save file in 'TempModel', file name end with 'Step-1'
mfs.makeUniaxialTestModel2(B,matFile);%set the material of the model
mfs.makeUniaxialTest(B);%calculate E,v,Tu,Cu of block, data will be saved in 'data' and 'data/step'

for i=1:interationNum
    data=B.d.Mats{1}.calculateRate();
    %-----------set material and joints, etc
    matSet=B.d.Mats{1}.SET;%rate data is recorded in B.SET;
    B.load(1);%load the saved file in 'TempModel'
    mfs.makeUniaxialTestModel2(B,matFile,data.newRate);%apply the new rate
    B.d.Mats{1}.SET=matSet;%assign the material rate data
    mfs.makeUniaxialTest(B);%calculate E,v,Tu,Cu of block, data will be saved in 'data' and 'data/step'
end
B.d.Mats{1}.setTrainedMat();
B.d.Mats{1}.save();