clear;%此代码由王波编写并维护，具体使用和修订请联系QQ群中王波，群号668903775
KeLiR=0.1;
ringObj=mfs.makeRing(2,1,KeLiR,0.5);%调用函数生成圆环
%ringObj=mfs.makeDisc(2, KeLiR*1.5/2,0.8);
ringObj=mfs.rotate(ringObj, 'YZ', 90);%旋转到XZ平面
ringObj.R(129)=ringObj.R(129)*1.0;%ID为129的颗粒半径变为原来1.2倍，便于后续建模观察圆环滚动
figure;fs.showObj(ringObj);
fs.randSeed(1);%build random model                                         
B=obj_Box;%build a box object                                              
B.name='粉末模型';                                                               
B.GPUstatus='auto';                                                        
B.ballR=KeLiR/0.8;%生成的颗粒半径为预定的5/4倍,相当于增加颗粒间距                                                           
B.isClump=0;                                                               
B.distriRate=0.2;
B.sampleW=6;                                                              
B.sampleL=0;                                                               
B.sampleH=4;
B.setType();                                                               
B.buildInitialModel();%B.show();                                           
B.setUIoutput();                                                           
d=B.d;%d.breakGroup('sample');d.breakGroup('lefPlaten');                   
d.mo.setGPU('auto');                                                       
SampleObj.X=d.mo.aX(d.GROUP.sample);
SampleObj.Y=d.mo.aY(d.GROUP.sample);
SampleObj.Z=d.mo.aZ(d.GROUP.sample);
SampleObj.R=d.mo.aR(d.GROUP.sample)*0.8;
d.SET.SampleObj=SampleObj;%以结构体形式保存sample样本
d.SET.ringObj=ringObj;%以结构体形式保存
d.SET.KeLiR=KeLiR;
d.status.dispEnergy();%display the energy of the model                     
d.mo.setGPU('off');                                                        
d.clearData(1);%clear dependent data
d.recordCalHour('Box1Finish');
save(['TempModel/' B.name '1.mat'],'B','d');
save(['TempModel/' B.name '1R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(d.aNum) '.mat']);
d.calculateData();
figure;d.showFilter('SlideY',0.45,0.05,'aR');                              