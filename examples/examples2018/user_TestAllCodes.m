%copy all the examples2018 to the root folder of the MatDEM
%and run the code to test all the examples2018
clear
steps=[0,1];
%step0: test function
k1=f.run('examples2018/funtest.m',1,2,3);%run one function
d1=f.run('examples2018/testFun.m',1,2,3);%run function with internal functions
[d2,k2]=f.run('examples2018/testFun.m',1,2,3);%run function with two output parameters

%step1: test 2D simple examples2018
MatDEMfile('examples2018/user_3AxialNew1.m');
MatDEMfile('examples2018/user_3AxialNew2.m');
MatDEMfile('examples2018/user_3AxialNew3.m');
MatDEMfile('examples2018/user_BoxCrash1.m');
MatDEMfile('examples2018/user_BoxCrash2.m');
MatDEMfile('examples2018/user_BoxCrash3.m');
MatDEMfile('examples2018/user_BoxCuTestNew1and2.m');
MatDEMfile('examples2018/user_BoxCuTestNew3.m');
MatDEMfile('examples2018/user_BoxMatTraining.m');
MatDEMfile('examples2018/user_BoxMixMat1.m');
MatDEMfile('examples2018/user_BoxMixMat2.m');
MatDEMfile('examples2018/user_BoxMixMat3.m');
MatDEMfile('examples2018/user_BoxModel1.m');
MatDEMfile('examples2018/user_BoxModel2.m');
MatDEMfile('examples2018/user_BoxModel3.m');
MatDEMfile('examples2018/user_L2Model3Exploision.m');
MatDEMfile('examples2018/user_BoxPile1.m');
MatDEMfile('examples2018/user_BoxPile2.m');
MatDEMfile('examples2018/user_BoxPile3.m');
MatDEMfile('examples2018/user_BoxTunnel1.m');
MatDEMfile('examples2018/user_BoxTunnel2.m');
MatDEMfile('examples2018/user_BoxTunnel3.m');
MatDEMfile('examples2018/user_BoxTunnelNew1.m');
MatDEMfile('examples2018/user_BoxTunnelNew2.m');
MatDEMfile('examples2018/user_BoxTunnelNew3.m');
MatDEMfile('examples2018/user_BoxUniaxialTest.m');