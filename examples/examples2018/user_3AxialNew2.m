%step2: assign formal mechanical parameters
%-------------assign new properties--------------
clear;
load('TempModel/3AxialTest1.mat');
A.setUIoutput();%set the output message
balanceNum=100;%define the balance number in the following simulation
d=A.d;
d.mo.setGPU('off');%please always close the GPU when modifing the model
A.importModel(d);
d=A.getFinalModel();%get the model from the object
%-----------use low gravity to balance the model---------------
%Hertz Model
%d.mo.FnCommand='nFN1=obj.nKNe.*nIJXn;nR=obj.aR(1:m_Num)*nRow;nJR=obj.aR(obj.nBall);Req=nR.*nJR./(nR+nJR);nE=obj.aKN(1:m_Num)*nRow./(pi*nR);nJE=obj.aKN(obj.nBall)./(pi*nJR);Eeq=nE.*nJE./(nE+nJE);nFN2=-4/3*Eeq.*Req.^(1/2).*abs(nIJXn).^(3/2);f=nIJXn<0;nFN0=nFN1.*(~f)+nFN2.*f;';
d.mo.mGZ(:)=0;
d.status=modelStatus(d);
aMUp0=d.mo.aMUp;%record the friction coefficient
d.mo.aMUp(:)=0;%no friction between balls
d.mo.dT=d.mo.dT*4;%use greater step time
d.mo.setGPU('auto');%set auto GPU
d.balance(balanceNum,20+d.SET.packNum);%d.SET.packNum is the particle number along vertical direction
A.setTubeFixId();%set the fixed Id of tube
d.balance(balanceNum,20+d.SET.packNum);
d.mo.aMUp=aMUp0;%restore friction coefficient
d.mo.dT=d.mo.dT/4;%restore the step time

d.showFilter('SlideY',0.3,1);
d.show('StressZZ');

d.mo.setGPU('off');
d.clearData(1);%clear dependent data
d.recordCalHour('AxialStep2Finish');%record the time
save(['TempModel/' A.name '2.mat'],'A','d');
save(['TempModel/' A.name '2R' num2str(A.ballR) '-distri' num2str(A.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();