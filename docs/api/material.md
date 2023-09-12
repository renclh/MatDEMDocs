# material

!!! api "class <span id="material-material">material</span>"
    ???+ api "<span id="material-props">Properties</span>"
        !!! api "<span id="material-name">name</span>"
            材料名

            

        !!! api "<span id="material-Id">Id</span>"
            材料编号

            

        !!! api "<span id="material-SET">SET</span>"
            记录设置信息

            

        !!! api "<span id="material-TAG">TAG</span>"
            记录输出信息

            

        !!! api "<span id="material-SH">SH</span>"
            比热容（用于热传导模拟）

            

        !!! api "<span id="material-rate">rate</span>"
            宏观力学参数的系数

            

        !!! api "<span id="material-E">E</span>"
            杨氏模量

            

        !!! api "<span id="material-v">v</span>"
            泊松比

            

        !!! api "<span id="material-Tu">Tu</span>"
            抗拉强度

            

        !!! api "<span id="material-Cu">Cu</span>"
            抗压强度

            

        !!! api "<span id="material-Mui">Mui</span>"
            内摩擦系数

            

        !!! api "<span id="material-G">G</span>"
            推算出的剪切模量

            

        !!! api "<span id="material-lame">lame</span>"
            推算出的拉姆常数

            

        !!! api "<span id="material-Copen">Copen</span>"
            见（Liu et al., 2013，JGR）

            

        !!! api "<span id="material-St">St</span>"
            推算出的张拉破坏应变

            

        !!! api "<span id="material-Sc">Sc</span>"
            推算出的压缩破坏应变

            

        !!! api "<span id="material-Sopen">Sopen</span>"
            见（Liu et al., 2013，JGR）

            

        !!! api "<span id="material-Vp">Vp</span>"
            推算出的P波速度

            

        !!! api "<span id="material-Vs">Vs</span>"
            推算出的S波速度

            

        !!! api "<span id="material-kn">kn</span>"
            单元正向劲度系数

            

        !!! api "<span id="material-ks">ks</span>"
            单元切向劲度系数

            

        !!! api "<span id="material-xb">xb</span>"
            单元断裂位移

            

        !!! api "<span id="material-mup">mup</span>"
            单元摩擦系数

            

        !!! api "<span id="material-fs0">fs0</span>"
            单元初始抗剪力

            

        !!! api "<span id="material-Mp">Mp</span>"
            单元质量

            

        !!! api "<span id="material-period">period</span>"
            单元振动周期（当与固定墙胶结时）

            

        !!! api "<span id="material-criticalVis">criticalVis</span>"
            单元临界阻尼

            

        !!! api "<span id="material-d">d</span>"
            单元直径

            

        !!! api "<span id="material-den">den</span>"
            密度（紧密堆积时）

            

        !!! api "<span id="material-isFailure">isFailure</span>"
            是否可破坏（见Liu et al., 2015，JGR）

            

        !!! api "<span id="material-is2D">is2D</span>"
            是否为二维单元

            

    ???+ api "<span id="material-methods">Methods</span>"
        !!! api "<span id="material-setTrainedMat(obj, varargin)">setTrainedMat(obj, varargin)</span>"
            从训练的材料属性中选取最接近的rate赋给材料，训练好的rate记录于materal.SET.UniaxialPara中

            

            见user_MatTraining

        !!! api "<span id="material-save(obj, varargin)">save(obj, varargin)</span>"
            保存材料于Mats文件夹中，格式为Matlab的.mat文件

            

            见user_MatTraining

        !!! api "<span id="material-calculateRate(obj)">calculateRate(obj)</span>"
            计算比率*

            

            

        !!! api "<span id="material-material(varargin)">material(varargin)</span>"
            material(matName,matTxt,meanBallR);

            matName(string):材料名；matTxt(string):材料文本路径；meanBallR(double):单元的平均半径，通常取B.ballR

            

        !!! api "<span id="material-getMicroPara(obj, ballD)">getMicroPara(obj, ballD)</span>"
            

            

            

        !!! api "<span id="material-setMaterial(obj, varargin)">setMaterial(obj, varargin)</span>"
            设置微观或宏观参数

            

            

        !!! api "<span id="material-setFailure(obj, Ff_rate, ellipseK, dR_rate, failureMax)">setFailure(obj, Ff_rate, ellipseK, dR_rate, failureMax)</span>"
            用于设置单元的破坏性质（见Liu et al., 2015，JGR）

            

            

        !!! api "<span id="material-show(obj)">show(obj)</span>"
            显示单元破坏包络面（见Liu et al., 2015，JGR）

            

            

        !!! api "<span id="material-calMicro(obj)">calMicro(obj)</span>"
            计算单元微观参数*

            

            

        !!! api "<span id="material-calMacro(obj)">calMacro(obj)</span>"
            计算模型宏观参数*

            

            

