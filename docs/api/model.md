# model

!!! api "class <span id="model-model">model</span>"
    ???+ api "<span id="model-props">Properties</span>"
        !!! api "<span id="model-%<------------    data objects      ------------>">%<------------    data objects      ------------></span>"
            

            

        !!! api "<span id="model-TAG;%structure to record additional information, such as data for debug">TAG;%structure to record additional information, such as data for debug</span>"
            模拟信息记录，用于记录和输出信息

            

        !!! api "<span id="model-SET;%structure to record running data">SET;%structure to record running data</span>"
            模拟设置信息，可记录二次开发新的数据

            

        !!! api "<span id="model-PAR;%parameters of parallel computing">PAR;%parameters of parallel computing</span>"
            用于平行计算的参数（未启用）

            

        !!! api "<span id="model-status;%model status">status;%model status</span>"
            模型状态

            

        !!! api "<span id="model-dem;%build object">dem;%build object</span>"
            母build对象

            

        !!! api "<span id="model-FnCommand='nFN0=obj.nKNe.*nIJXn;';%command of Fn">FnCommand='nFN0=obj.nKNe.*nIJXn;';%command of Fn</span>"
            正向力的定义，默认为线弹性接触。采用备注中的代码，可以定义hertz接触模型，具体原理可见《地质与岩土工程矩阵离散元分析》

            ```matlab
            d.mo.isShear=0;
            d.mo.FnCommand='nFN1=obj.nKNe.*nIJXn;
            nR=obj.aR(1:m_Num)*nRow;
            nJR=obj.aR(obj.nBall);
            Req=nR.*nJR./(nR+nJR);
            nE=obj.aKN(1:m_Num)*nRow./(pi*nR);
            nJE=obj.aKN(obj.nBall)./(pi*nJR);
            Eeq=nE.*nJE./(nE+nJE);
            nFN2=-4/3*Eeq.*Req.^(1/2).*abs(nIJXn).^(3/2);
            f=nIJXn＜0;
            nFN0=nFN1.*(～f)+nFN2.*f;';
            ```

        !!! api "<span id="model-balanceCommand">balanceCommand</span>"
            平衡函数的命令，用于自定义接触模型和计算（d.mo.setBalanceFunction）

            见Box_Crash1

        !!! api "<span id="model-afterBalance">afterBalance</span>"
            在运行完balanceCommand后运行的命令

            

        !!! api "<span id="model-%<------------    initial parameters      ------------>">%<------------    initial parameters      ------------></span>"
            

            

        !!! api "<span id="model-aNum;%ball number including boundary balls">aNum;%ball number including boundary balls</span>"
            模型单元和边界单元个数和

            

        !!! api "<span id="model-aMatId;">aMatId;</span>"
            单元的材料编号

            

        !!! api "<span id="model-aX;aY;aZ;aR;%XYZ components and radius of all balls (model balls and boundary balls)">aX;aY;aZ;aR;%XYZ components and radius of all balls (model balls and boundary balls)</span>"
            模型单元的X,Y,Z坐标和半径

            

        !!! api "<span id="model-aKN;aKS;%radius, stiffness of all balls">aKN;aKS;%radius, stiffness of all balls</span>"
            单元正向劲度系数和切向劲度系数

            

        !!! api "<span id="model-aBF;%, breaking force">aBF;%, breaking force</span>"
            单元断裂力

            

        !!! api "<span id="model-aFS0;%inter-ball shear resistance, ">aFS0;%inter-ball shear resistance, </span>"
            单元初始抗剪强度

            

        !!! api "<span id="model-aMUp;%coefficient of friction">aMUp;%coefficient of friction</span>"
            单元摩擦系数

            

        !!! api "<span id="model-mNum;%ball number of model">mNum;%ball number of model</span>"
            模型活动单元个数

            

        !!! api "<span id="model-mVis;mVisX;mVisY;mVisZ;%viscosity, ">mVis;mVisX;mVisY;mVisZ;%viscosity, </span>"
            单元阻尼系数

            当mVis=[]时，将启用mVisX,Y,Z，实现各向异性的阻尼

        !!! api "<span id="model-mM;%mass">mM;%mass</span>"
            单元质量

            

        !!! api "<span id="model-mVX;mVY;mVZ;">mVX;mVY;mVZ;</span>"
            单元在X,Y,Z方向上速度

            

        !!! api "<span id="model-mAX;mAY;mAZ;%acceleration">mAX;mAY;mAZ;%acceleration</span>"
            单元在X,Y,Z方向上加速度

            

        !!! api "<span id="model-mVFX;mVFY;mVFZ;%viscous force">mVFX;mVFY;mVFZ;%viscous force</span>"
            单元在X,Y,Z方向上阻尼力

            

        !!! api "<span id="model-g;">g;</span>"
            重力加速度

            

        !!! api "<span id="model-mGX;mGY;mGZ;%mGZ is generally the gravity, GX,GY can be used to define constant load on balls">mGX;mGY;mGZ;%mGZ is generally the gravity, GX,GY can be used to define constant load on balls</span>"
            单元在X,Y,Z方向上的体力，也用于给压力板platen设置体力，并产生压力作用

            

        !!! api "<span id="model-aHeat;%heat matrix, colomn [Viscosity Heat, Normal Breaking Heat, Shear Breaking Heat, Slipping Heat]">aHeat;%heat matrix, colomn [Viscosity Heat, Normal Breaking Heat, Shear Breaking Heat, Slipping Heat]</span>"
            单元热量

            

        !!! api "<span id="model-%<------------    running parameters      ------------>">%<------------    running parameters      ------------></span>"
            

            

        !!! api "<span id="model-%parameters for "remesh", i.e. setNearbyBall()-->">%parameters for "remesh", i.e. setNearbyBall()--></span>"
            用于邻居查找的参数

            

        !!! api "<span id="model-dSide;%border of ball grid, see documentation">dSide;%border of ball grid, see documentation</span>"
            邻居矩阵查找时的网格边长

            

        !!! api "<span id="model-dis_mXYZ;%summation of dmX and dmY of normal balls in balance, trigger of setNearbyBall">dis_mXYZ;%summation of dmX and dmY of normal balls in balance, trigger of setNearbyBall</span>"
            模型单元在上次邻居查找后的位移

            

        !!! api "<span id="model-dis_bXYZ;%summation of displacement boundary balls in newstep, trigger of setNearbyBall">dis_bXYZ;%summation of displacement boundary balls in newstep, trigger of setNearbyBall</span>"
            边界单元在上次邻居查找后的位移

            

        !!! api "<span id="model-dbXYZ;%boundary displacement, used to calculate friction, updated in newStep">dbXYZ;%boundary displacement, used to calculate friction, updated in newStep</span>"
            边界位移，用于内部计算

            

        !!! api "<span id="model-bFilter;%bond filter, n matrix">bFilter;%bond filter, n matrix</span>"
            胶结过滤器

            

        !!! api "<span id="model-cFilter;%compressive filter">cFilter;%compressive filter</span>"
            压缩过滤器

            

        !!! api "<span id="model-tFilter;%tensile filter">tFilter;%tensile filter</span>"
            张拉过滤器

            

        !!! api "<span id="model-nBondRate;%remained bond rate">nBondRate;%remained bond rate</span>"
            残余强度系数矩阵，连接的BF和FS0将乘以这个系数。可用于设置节理和裂隙，见user_Box3DJointStress示例

            

        !!! api "<span id="model-isBondRate=0">isBondRate=0</span>"
            是否设定单独强度系数，当其值为1时，且设定d.mo.SET.nBondRate.BF为系数矩阵时，则单元间连接的断裂力将乘以这个系数矩阵，，见user_Box3DJointStress示例使用于MUp

            

        !!! api "<span id="model-nBall;%Id of nearby balls">nBall;%Id of nearby balls</span>"
            邻居编号矩阵

            

        !!! api "<span id="model-nKNe;nKSe;nIKN;nIKS;%ball stiffness matrix, equivalent stiffness for normal force and shearing force">nKNe;nKSe;nIKN;nIKS;%ball stiffness matrix, equivalent stiffness for normal force and shearing force</span>"
            单元与邻居间劲度系数

            

        !!! api "<span id="model-nFnX;nFnY;nFnZ;%normal displacement along x,y,z directions">nFnX;nFnY;nFnZ;%normal displacement along x,y,z directions</span>"
            单元与邻居间正向力

            

        !!! api "<span id="model-nFsX;nFsY;nFsZ;%shear displacement along x,y,z directions">nFsX;nFsY;nFsZ;%shear displacement along x,y,z directions</span>"
            单元与邻居间切向力

            

        !!! api "<span id="model-nClump=[];">nClump=[];</span>"
            单元与邻居间clump重叠量，当其不为零时为clump连接

            

        !!! api "<span id="model-%<------------    system parameters      ------------>">%<------------    system parameters      ------------></span>"
            系统参数

            

        !!! api "<span id="model-dT=0;totalT=0;%current time interval, total time">dT=0;totalT=0;%current time interval, total time</span>"
            时间步；总时间

            

        !!! api "<span id="model-isGPU=0;%whether the GPU calculation is on">isGPU=0;%whether the GPU calculation is on</span>"
            是否用GPU计算

            

        !!! api "<span id="model-GPULevel;%the GPU calculation level in setNearbyBall, 0~3, more gpu memory will be used when it increases,basicfs.setModel">GPULevel;%the GPU calculation level in setNearbyBall, 0~3, more gpu memory will be used when it increases,basicfs.setModel</span>"
            邻居矩阵查找时的GPU使用层次，0不使用，1初步使用，2中度使用，3全面使用（占用大量显存，支持单元数降为一半）

            见user_SpeedTest

        !!! api "<span id="model-isHeat=0;%heat of the model; switch of heat calculation">isHeat=0;%heat of the model; switch of heat calculation</span>"
            是否计算热

            

        !!! api "<span id="model-isClump=0;%whether use the clump">isClump=0;%whether use the clump</span>"
            是否有clump

            

        !!! api "<span id="model-isFix=0;">isFix=0;</span>"
            是否锁定自由度，锁定活动单元自由度后，其类似固定墙单元

            

        !!! api "<span id="model-FixXId;FixYId;FixZId;">FixXId;FixYId;FixZId;</span>"
            锁定X,Y,Z坐标的单元编号

            

        !!! api "<span id="model-isWaterDiff;">isWaterDiff;</span>"
            是否进行有限差分计算

            

        !!! api "<span id="model-isCrack=0;%whether record the cracking process">isCrack=0;%whether record the cracking process</span>"
            是否统计生成的裂隙

            

        !!! api "<span id="model-isShear=1;%whether the shear force is calculated">isShear=1;%whether the shear force is calculated</span>"
            是否考虑单元间切向力

            

        !!! api "<span id="model-isFailure=0;%whether the failure is considered">isFailure=0;%whether the failure is considered</span>"
            是否考虑单元压密破坏

            

        !!! api "<span id="model-isSmoothB=0;%whether the boundary is smooth, data recorded in SET">isSmoothB=0;%whether the boundary is smooth, data recorded in SET</span>"
            是否采用平滑边界

            

    ???+ api "<span id="model-methods">Methods</span>"
        !!! api "<span id="model-balance()">balance()</span>"
            平衡迭代一次

            无

            无

            d.mo.balance();

        !!! api "<span id="model-dispNote(note)">dispNote(note)</span>"
            显示提示*

            无

            无

            

        !!! api "<span id="model-getBalanceData(dName,isBalance)">getBalanceData(dName,isBalance)</span>"
            获取求解中的指定参数，nIJXn单元重叠量

            dName参数名;isBalance，是否先做零时平衡

            参数的值 

            nIJXn=d.mo.getBalanceData('nIJXn');

        !!! api "<span id="model-gpuStatus=setGPU(type)">gpuStatus=setGPU(type)</span>"
            设置GPU状态

            type: 'on', 'off', 'auto','fixed','unfixed'

            当前的GPU状态：'on'或'off'

            详见以下示例

        !!! api "<span id="model-recement()">recement()</span>"
            将处于压缩状态的连接设为完整连接，再两单元接触后会重新粘结

            无

            无

            

        !!! api "<span id="model-setBalanceFunction(functionFileName)">setBalanceFunction(functionFileName)</span>"
            设置平衡函数命令d.mo.balanceCommand

            命令语句

            无

            见BoxCrash1示例

        !!! api "<span id="model-setContactModel(type,varargin)">setContactModel(type,varargin)</span>"
            设置接触模型*，未来将取消

            无

            无

            

        !!! api "<span id="model-setKNKS()  ">setKNKS()  </span>"
            设置单元与邻居间刚度，在改变单元刚度后需使用

            无

            无

            

        !!! api "<span id="model-setModel()">setModel()</span>"
            设置初始模型

            无

            无

            

        !!! api "<span id="model-setNearbyBall()%set nearby balls of each ball">setNearbyBall()%set nearby balls of each ball</span>"
            三维邻居查找

            无

            无

            

        !!! api "<span id="model-setNearbyBall2()%set nearby balls of each ball">setNearbyBall2()%set nearby balls of each ball</span>"
            二维邻居查找

            无

            无

            

        !!! api "<span id="model-setNewStep(dbXYZnew)">setNewStep(dbXYZnew)</span>"
            设置新的边界步(将取消）

            在新一步里，边界的位移

            无

            

        !!! api "<span id="model-setShear(type)">setShear(type)</span>"
            开启或关闭剪切力计算，当开启时，会初始化所有剪切力为0；关闭时，将所有剪切力矩阵置空

            on'或'off'

            无

            d.mo.setShear('on')

        !!! api "<span id="model-zeroBalance()%to intialize the model, break impossible intact bonds">zeroBalance()%to intialize the model, break impossible intact bonds</span>"
            零时平衡，用于计算模型当前状态

            无

            无

            

        !!! api "<span id="model-setFastComputing(type)">setFastComputing(type)</span>"
            启用或关闭单精度浮点计算，建议不要启用

            on'或'off'

            无

            

