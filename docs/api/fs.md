# fs

!!! api "class <span id="fs-fs">fs</span>"
    ???+ api "<span id="fs-props">Properties</span>"
    ???+ api "<span id="fs-methods">Methods</span>"
        !!! api "<span id="fs-M=fs.getMatDEMscore(varargin)">M=fs.getMatDEMscore(varargin)</span>"
            通过测试获得计算机的MatDEM计算评分

            无输入时测试最多可能颗粒数；一个整数输入时，赋为testNum

            

            user_BoxTestSpeed.m

        !!! api "<span id="fs-density=calcualteBlockDensity(mo, x1, y1, z1, x2, y2, z2)">density=calcualteBlockDensity(mo, x1, y1, z1, x2, y2, z2)</span>"
            计算块体的密度

            mo:模型d.mo; x1,yz…:块体的对角线点坐标

            密度

            

        !!! api "<span id="fs-gData=chooseGPU(varargin)">gData=chooseGPU(varargin)</span>"
            测试所有可用GPU，并选择可用显存最多的GPU

            无输入时或输入为'auto'自动选择空闲GPU，输入数字时选择指定GPU

            GPU信息结构体

            fs.chooseGPU();

        !!! api "<span id="fs-B=copyDataA2B(A, B)">B=copyDataA2B(A, B)</span>"
            将A的所有属性复制给B

            A:对象A; B:对象B，参数可为结构体或Box,build等对象

            对象B

            

        !!! api "<span id="fs-disp(note)">disp(note)</span>"
            在消息框中显示结果

            note:需要显示的消息字符串

            无

            fs.show('message');

        !!! api "<span id="fs-general3Dset()">general3Dset()</span>"
            设置三维显示函数，用在show()中

            无

            无

            

        !!! api "<span id="fs-generalView()">generalView()</span>"
            设置三维观看位置，用在show()中

            无

            无

            

        !!! api "<span id="fs-limitFrame(d,sId,x1,x2,y1,y2,z1,z2)">limitFrame(d,sId,x1,x2,y1,y2,z1,z2)</span>"
            增加一个刚性外框，限制单元在其中运动。当单元要接触到x1,x2,y1,y2,z1,z2定义边界框时，就会被反射回来。需要在每步d.mo.balance()命令后运行这个命令，可以与d.mo.afterBalance属性一起使用

            sId：单元编号；其余：外框的边界坐标

            

            

        !!! api "<span id="fs-movie2gif(name, frames, dt)">movie2gif(name, frames, dt)</span>"
            根据frames里的信息，生成gif动画，并保存在gif文件夹

            name:动画名; 动画帧结构体;动帧时间间隔，见user_makeGIF示例

            

            见makegif示例

        !!! api "<span id="fs-save(path,name,value)">save(path,name,value)</span>"
            保存参数到.mat文件

            path:保存路径; name:变量名; value:变量值

            无

            fs.save('data/a.mat','B',B)

        !!! api "<span id="fs-data=testSpeed(d)">data=testSpeed(d)</span>"
            测试模型的邻居检索和平衡计算速度

            d对象

            速度数据结构体

            

        !!! api "<span id="fs-xyzFilter=selectBlockBalls(mo, x1, y1, z1, x2, y2, z2)">xyzFilter=selectBlockBalls(mo, x1, y1, z1, x2, y2, z2)</span>"
            找出在两顶点间块区域的单元

            mo:模型d.mo; x1,y1…:块体的对角线点坐标

            过滤布尔矩阵，1代表在块体内

            

        !!! api "<span id="fs-setPlatenStress(d, StressXX, StressYY, StressZZ, border)">setPlatenStress(d, StressXX, StressYY, StressZZ, border)</span>"
            设置压力板上正向压力，仅给border范围内有接触的单元设置体力，力作用于right,back和top压力板上

            可为4个或5个输入参数，施加三轴力为(d, StressXX, StressYY, StressZZ, border)，施加单轴力为(d,type,stress,border)，d: build对象; StressXX, StressYY, StressZZ: 三个方向的法向应力; border: 施加应力的距离; type可取'StressXX','StressYY','StressZZ'

            无

            

        !!! api "<span id="fs-showObj(obj,varargin)">showObj(obj,varargin)</span>"
            显示结构体中的三维球，默认会清除已有的显示

            obj:结构体，包含.X,.Y,.Z,.R信息; varargin: 当有输入参数时，不会清除当前显示

            无

            fs.showObj(obj,'add'); 不渲染

        !!! api "<span id="fs-fig=surfaceValue(X, Y, Z, R, V)">fig=surfaceValue(X, Y, Z, R, V)</span>"
            画三维球和标量

            X,Y,Z,R:坐标和R半径数组; V:标量值数组

            图的句柄

            

        !!! api "<span id="fs-fig=surfaceVector(X, Y, Z, R, U, V, W)">fig=surfaceVector(X, Y, Z, R, U, V, W)</span>"
            画三维球和向量

            X,Y,Z,R:坐标和R半径数组; U,V,W: 方向量数组

            图的句柄

            

        !!! api "<span id="fs-0以下为程序内部函数，通常不直接使用（部分新函数未列出）">0以下为程序内部函数，通常不直接使用（部分新函数未列出）</span>"
            

            

            

            

        !!! api "<span id="fs-adjustSize(d, requiredStrain, time, varargin)">adjustSize(d, requiredStrain, time, varargin)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-adjustSize0(d, requiredStrain, varargin)">adjustSize0(d, requiredStrain, varargin)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-blockXYZ(blockW,blockL,blockH,ballR)">blockXYZ(blockW,blockL,blockH,ballR)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-commandRep(str)">commandRep(str)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-cube(modelSize, R)">cube(modelSize, R)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-CuCalculate2D(d)">CuCalculate2D(d)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-dataA2B(A, B)">dataA2B(A, B)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-dataA2B2(varargin)">dataA2B2(varargin)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-dataCurveLongLine(valueName, d, x1, z1, x2, z2, disLimit)">dataCurveLongLine(valueName, d, x1, z1, x2, z2, disLimit)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-dispNote(note, isUI, handle)">dispNote(note, isUI, handle)</span>"
            显示结果*

            ()

            

            

        !!! api "<span id="fs-drawDisc(cX, cY, cZ, R, nX, nY, nZ, color)">drawDisc(cX, cY, cZ, R, nX, nY, nZ, color)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-EvCalculate(d)">EvCalculate(d)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-EvCalculate2D(d)">EvCalculate2D(d)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-fillValue(X, Y, R, value)">fillValue(X, Y, R, value)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-fluidHead2Den(fluidHead, fluidSpan)">fluidHead2Den(fluidHead, fluidSpan)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getBallPara(ballR, MatId, Mats)">getBallPara(ballR, MatId, Mats)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getBlockEdge(mX, mY, mZ, border)">getBlockEdge(mX, mY, mZ, border)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getBlockStrainStress(obj)">getBlockStrainStress(obj)</span>"
            计算块体的应力应变曲线*

            ()

            

            

        !!! api "<span id="fs-getBlockStrength(obj)">getBlockStrength(obj)</span>"
            计算块体强度*

            ()

            

            

        !!! api "<span id="fs-getBlockWHT(X, Y, Z, edge)">getBlockWHT(X, Y, Z, edge)</span>"
            用于单轴强度测试

            ()

            

            

        !!! api "<span id="fs-getCuCircle(mSize)">getCuCircle(mSize)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getDistribution(type, num, maxRrate)">getDistribution(type, num, maxRrate)</span>"
            获取单元粒径分布*

            ()

            

            

        !!! api "<span id="fs-getDropStepNum(d)">getDropStepNum(d)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getEdgeId(d, platenId, edge, type)">getEdgeId(d, platenId, edge, type)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getEdgePlatenId(d0, border, platenType)">getEdgePlatenId(d0, border, platenType)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getnBreakFilter(d, aBreakFilter)">getnBreakFilter(d, aBreakFilter)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getNewElementId(Id, delId)">getNewElementId(Id, delId)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getPbyId(d, Ids)">getPbyId(d, Ids)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getPlatenEdgeId(aX, aY, platenId, border)">getPlatenEdgeId(aX, aY, platenId, border)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getPricipalStress(m)">getPricipalStress(m)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getStrain(d)">getStrain(d)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getStrain0(d)">getStrain0(d)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getStrain2(d)">getStrain2(d)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getStress(m)">getStress(m)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getTwoGroupConnect(G1_gId, G2_gId, nBall)">getTwoGroupConnect(G1_gId, G2_gId, nBall)</span>"
            获取两组单元编号的相连接矩阵过滤器

            两组单元编号，邻居矩阵

            过滤布尔矩阵，1代表胶结

            

        !!! api "<span id="fs-getTuCircle(mSize)">getTuCircle(mSize)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-getVisRate(mX, mY, mZ, mR)">getVisRate(mX, mY, mZ, mR)</span>"
            

            ()

            

            

        !!! api "<span id="fs-insertArray(oldA, addA, addI)">insertArray(oldA, addA, addI)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-isExistInCells(str, strCells)">isExistInCells(str, strCells)</span>"
            判断某字符串是否在字符串cell数组中*

            ()

            

            

        !!! api "<span id="fs-layeredModel(V, Span, Id)">layeredModel(V, Span, Id)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-loadOriginalData(obj, aId0, mNum)">loadOriginalData(obj, aId0, mNum)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-macroToMicro3(E, v, Tu, Cu, Mui, d, den)">macroToMicro3(E, v, Tu, Cu, Mui, d, den)</span>"
            基于三维转换公式，计算相应单元间参数

            杨氏模量，泊松比，抗拉强度，抗压强度，摩擦系数，直径，密度

            

            

        !!! api "<span id="fs-microToMacro3(Kn, Ks, Xb, Fs0, Mup, d, den)">microToMacro3(Kn, Ks, Xb, Fs0, Mup, d, den)</span>"
            基于三维转换公式，计算相应模型整体参数

            正向刚度，切向刚度，断裂位移，抗剪力，单元摩擦系数，直径，密度

            

            

        !!! api "<span id="fs-macro3Dto2D(E, v, Tu, Cu, Mui, d, den)">macro3Dto2D(E, v, Tu, Cu, Mui, d, den)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-macroToMicro2(E, v, Tu, Cu, Mui, d, den)">macroToMicro2(E, v, Tu, Cu, Mui, d, den)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-microToMacro2(Kn, Ks, Xb, Fs0, Mup, d, den)">microToMacro2(Kn, Ks, Xb, Fs0, Mup, d, den)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-mixProperty(d, Pname)">mixProperty(d, Pname)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-moveBalls(d)">moveBalls(d)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-moveBallsNew(d, Id)">moveBallsNew(d, Id)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-nFilter2Con(Nball, filterIn)">nFilter2Con(Nball, filterIn)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-noBIntact(d)">noBIntact(d)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-platenStress2Gravity(d0, gName, direction, stress)">platenStress2Gravity(d0, gName, direction, stress)</span>"
            根据压力板的压力计算每个单元所受体力

            build对象，组名，方向(X,Y,Z)，应力

            每个单元所受体力

            见user_BoxTunnel2

        !!! api "<span id="fs-randSeed(seed)">randSeed(seed)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-rectDisc(w, h, ballR)">rectDisc(w, h, ballR)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-saveRecord(tl)">saveRecord(tl)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-selectBall(mX, mY, mZ, span)">selectBall(mX, mY, mZ, span)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-selectBlockClump(mX, mY, mZ, r, span)">selectBlockClump(mX, mY, mZ, r, span)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-setBlock(w, h, t, r)">setBlock(w, h, t, r)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-setBoundary(mX, mY, mZ, mR, type, sXYZ)">setBoundary(mX, mY, mZ, mR, type, sXYZ)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-setBox(mX, mY, mZ, r, type, sXYZ)">setBox(mX, mY, mZ, r, type, sXYZ)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-setEdgeSize(d, edge)">setEdgeSize(d, edge)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-setFlotage(obj, fluidDensity, fluidMin, fluidMax)">setFlotage(obj, fluidDensity, fluidMin, fluidMax)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-setTwoBoundaries(mX, mY, mZ, r, type, tag)">setTwoBoundaries(mX, mY, mZ, r, type, tag)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-showCrack(breakId, aX, aY, aZ, aR)">showCrack(breakId, aX, aY, aZ, aR)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-showCrackMovie(breakId, aX, aY, aZ, aR)">showCrackMovie(breakId, aX, aY, aZ, aR)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-showFailureMovie(failureId, aX, aY, aZ, aR)">showFailureMovie(failureId, aX, aY, aZ, aR)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-showLayerFrame(obj)">showLayerFrame(obj)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-showLines(X, Y, Z, startId, endId, lineColor)">showLines(X, Y, Z, startId, endId, lineColor)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-showMovement(d, loopTime, balanceNum, type)">showMovement(d, loopTime, balanceNum, type)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-showRect(x1, y1, z1, x2, y2, z2, style)">showRect(x1, y1, z1, x2, y2, z2, style)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-sizeRate(mSize)">sizeRate(mSize)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-transferData(nBallOld, nBallNew, a_Num, m_Num, nValue)">transferData(nBallOld, nBallNew, a_Num, m_Num, nValue)</span>"
            *

            ()

            

            

        !!! api "<span id="fs-uniformSize(d, rate)">uniformSize(d, rate)</span>"
            *

            ()

            

            

