# pore

!!! api "class <span id="pore-pore">pore</span>"
    ???+ api "<span id="pore-props">Properties</span>"
        !!! api "<span id="pore-d">d</span>"
            build对象

            

        !!! api "<span id="pore-SET">SET</span>"
            模拟设置信息，可记录二次开发新的数据

            

        !!! api "<span id="pore-TAG">TAG</span>"
            模拟信息记录，用于记录和输出信息

            

        !!! api "<span id="pore-solutePara">solutePara</span>"
            pore.addSolutePara命令执行后，将求解参数结构体存于这个参数，结构体字段详见pore函数工作表下方

            见示例GeoThermalBox3

        !!! api "<span id="pore-pathLimitRate">pathLimitRate</span>"
            孔喉距离阈值比率，默认值0.5，取值范围建议[0.1,0.8]，孔喉宽度小于rate*min(ballR)的连接视作构成孔隙的连接

            

        !!! api "<span id="pore-cDiameterAdd">cDiameterAdd</span>"
            连接对应的孔喉附加宽度。由于二维颗粒堆积通常会封闭孔喉，需要增加一定的孔喉直径，以保证流体运移

            

        !!! api "<span id="pore-cList">cList</span>"
            连接列表，每一行代表连接的起始单元Id与终止单元Id(连接1—3与3—1为不同连接)，共2列，按单元Id升序排列

            

        !!! api "<span id="pore-cIndexInverse">cIndexInverse</span>"
            连接的反向连接Id，用于计算孔隙网络

            

        !!! api "<span id="pore-cIndexNext">cIndexNext</span>"
            连接的下一个连接Id，同一颗粒的连接按逆时针排序，用于计算孔隙网络

            

        !!! api "<span id="pore-cPore">cPore</span>"
            连接所在孔隙Id，连接方向与孔隙遵循右手螺旋法则，故连接与孔隙一一对应，边界连接不在任何孔隙中，其值为反向连接所在孔隙

            

        !!! api "<span id="pore-cPoreInverse">cPoreInverse</span>"
            反向连接所在孔隙Id

            

        !!! api "<span id="pore-cDiameter">cDiameter</span>"
            连接对应孔喉的实际宽度（孔喉垂直于连接）

            

        !!! api "<span id="pore-cLength">cLength</span>"
            连接长度

            

        !!! api "<span id="pore-cPathLength">cPathLength</span>"
            孔喉长度，等于孔喉对应的两个单元较小的半径（不是直径！）

            

        !!! api "<span id="pore-cKFlow">cKFlow</span>"
            连接（孔喉）渗透系数

            

        !!! api "<span id="pore-cnIndex">cnIndex</span>"
            连接在nBall中的索引，用于将nBall大小的填充矩阵转化为对应接触对数组 e.g. cbFilter=d.mo.bFilter(cnIndex);%bonded filter of cList

            见示例PoreHydraulicStatic3

        !!! api "<span id="pore-nBallP">nBallP</span>"
            孔隙连接对应的nBall，当出现孤立颗粒时，需要加入额外邻居颗粒，可能与d.mo.nBall不同

            

        !!! api "<span id="pore-nConnectFilter1">nConnectFilter1</span>"
            与nBallP对应的构成有效孔隙连接的过滤器

            

        !!! api "<span id="pore-nConnectFilter2">nConnectFilter2</span>"
            用于记录孤立颗粒(团)的连接过滤器，避免孔隙面积计算出错

            

        !!! api "<span id="pore-aWaterdR">aWaterdR</span>"
            单元流体作用减少半径，用于定义cDiameterAdd

            

        !!! api "<span id="pore-NcPore">NcPore</span>"
            单元邻居孔隙Id，mNum行，每行记录对应单元邻居孔隙Id

            

        !!! api "<span id="pore-poreC">poreC</span>"
            孔隙对应连接元胞数组

            

        !!! api "<span id="pore-poreNearby">poreNearby</span>"
            孔隙的邻居孔隙元胞数组

            

        !!! api "<span id="pore-poreFlowMass">poreFlowMass</span>"
            孔隙渗流流体质量元胞数组

            

        !!! api "<span id="pore-poreIndex">poreIndex</span>"
            孔隙Id对应元胞数组

            

        !!! api "<span id="pore-poreP">poreP</span>"
            孔隙构成颗粒元胞数组（首尾列相同）

            

        !!! api "<span id="pore-poreCAngle">poreCAngle</span>"
            *用于孔隙几何计算

            

        !!! api "<span id="pore-porePAngle">porePAngle</span>"
            *同上

            

        !!! api "<span id="pore-porePAngleOverlap1">porePAngleOverlap1</span>"
            *同上

            

        !!! api "<span id="pore-porePAngleOverlap2">porePAngleOverlap2</span>"
            *同上

            

        !!! api "<span id="pore-porePOuterLength">porePOuterLength</span>"
            *同上

            

        !!! api "<span id="pore-porePOuterAngle">porePOuterAngle</span>"
            *同上

            

        !!! api "<span id="pore-fluid_k">fluid_k</span>"
            obj.pDensity=obj.fluid_k*obj.pPressure+obj.fluid_c;

            

        !!! api "<span id="pore-fluid_c">fluid_c</span>"
            obj.pDensity=obj.fluid_k*obj.pPressure+obj.fluid_c;

            

        !!! api "<span id="pore-pNum">pNum</span>"
            划分孔隙数目

            

        !!! api "<span id="pore-pPoints">pPoints</span>"
            孔隙构成单元元胞数组，pNum行，每行记录构成孔隙的颗粒Id，由于poreP转化得到

            

        !!! api "<span id="pore-pMass">pMass</span>"
            孔隙流体质量列表

            

        !!! api "<span id="pore-pArea">pArea</span>"
            孔隙流体面积列表

            

        !!! api "<span id="pore-pDensity">pDensity</span>"
            孔隙流体密度列表

            

        !!! api "<span id="pore-pPressure">pPressure</span>"
            孔隙流体压力列表

            

        !!! api "<span id="pore-pK">pK</span>"
            fluid_k of each pore

            

        !!! api "<span id="pore-pC">pC</span>"
            fluid_c of each pore

            

        !!! api "<span id="pore-dT">dT</span>"
            流体计算时间步

            

        !!! api "<span id="pore-totalT">totalT</span>"
            当前计算时刻

            

        !!! api "<span id="pore-isCouple">isCouple</span>"
            是否耦合固体，isCouple=0流体不对颗粒产生力作用，isCouple=1，流体对颗粒产生力作用，涉及孔隙的重新剖分及数据传递

            

        !!! api "<span id="pore-pThickness">pThickness</span>"
            孔隙厚度（沿Y方向）

            

        !!! api "<span id="pore-isGPU">isGPU</span>"
            是否启用GPU计算

            

    ???+ api "<span id="pore-methods">Methods</span>"
        !!! api "<span id="pore-addSolutePara(obj,para)">addSolutePara(obj,para)</span>"
            添加溶质运移问题的求解参数，如温度，溶质浓度等，并初始化属性值(记录于p.SET中)

            obj: pore对象; para: 求解参数结构体，记录于p.solutePara中

            

            见GeoThermalBox示例

        !!! api "<span id="pore-balance(obj,varargin)">balance(obj,varargin)</span>"
            流体迭代计算

            varargin：可变输入参数（0-3个），详见下方

            

            

        !!! api "<span id="pore-pId=getBallConnectedPore(obj,bId)">pId=getBallConnectedPore(obj,bId)</span>"
            根据颗粒Id得到邻居孔隙Id

            bId：颗粒Id

            pId: 孔隙Id

            

        !!! api "<span id="pore-setFlowPath(obj)">setFlowPath(obj)</span>"
            设置孔喉宽度(cDiameter)及渗径长度(cPathLength)

            

            

            

        !!! api "<span id="pore-setInitialPores(obj)">setInitialPores(obj)</span>"
            搜索孔隙并初始化孔隙参数

            

            conFilter，与platen连通的过滤器

            见GeoThermalBox示例

        !!! api "<span id="pore-setPressure(obj,varargin)">setPressure(obj,varargin)</span>"
            设置孔隙流体流体压力，并更新相关参数

            varargin: 无输入或与p.pPressure等大数组

            

            

        !!! api "<span id="pore-show(obj,varargin)">show(obj,varargin)</span>"
            后处理绘图函数，详见下方

            

            

            

        !!! api "<span id="pore-setNewPore(obj)">setNewPore(obj)</span>"
            更新孔隙拓扑结构

            

            

            

        !!! api "<span id="pore-setPlaten(obj,type)">setPlaten(obj,type)</span>"
            设置platen单元状态

            type:取值‘fix'或’unfix', 是否锁定platen单元坐标

            

            见GeoThermalBox示例

        !!! api "<span id="pore-pId=setBallPressure(obj,bId,pressure)">pId=setBallPressure(obj,bId,pressure)</span>"
            部分更新颗粒邻居孔隙流体压力，并更新相应参数(密度，质量等）；常用于设置压力边界条件

            bId：颗粒Id; pressure: 压力数组，大小与bId相同

            pId: bId对应颗粒邻居孔隙Id

            见GeoThermalBox示例

        !!! api "<span id="pore-setDensity(obj,varargin)">setDensity(obj,varargin)</span>"
            设置部分孔隙流体密度，并更新质量等相应参数，类似setPressure

            类似setPressure

            

            

        !!! api "<span id="pore-obj=pore(d)">obj=pore(d)</span>"
            初始化孔隙类

            d: build对象

            obj：pore对象

            见GeoThermalBox示例

        !!! api "<span id="pore-setMass(obj,varargin)">setMass(obj,varargin)</span>"
            设置孔隙流体质量，并更新相关参数，可用于设置流量边界条件，类似setPressure

            

            

            

        !!! api "<span id="pore-setNewNBall(obj)">setNewNBall(obj)</span>"
            d.mo.nBall更新时，重新搜索孔隙

            

            

            

        !!! api "<span id="pore-balanceConvection(obj,varargin)">balanceConvection(obj,varargin)</span>"
            对流计算（由于渗流(速度)引起的热对流，机械扩散等过程）

            varargin：无输入时，计算所有求解参数(记录于p.solutePara)

            

            

        !!! api "<span id="pore-balanceConvection0(obj,paraI)">balanceConvection0(obj,paraI)</span>"
            对流计算基础函数

            paraI：求解参数结构体

            

            

        !!! api "<span id="pore-balanceDiffusion0(obj,paraI)">balanceDiffusion0(obj,paraI)</span>"
            扩散计算（由于温度梯度，浓度梯度引起的热传导，分子扩散等过程）

            paraI：同上

            

            

        !!! api "<span id="pore-balanceFluid(obj)">balanceFluid(obj)</span>"
            渗流计算

            

            

            

        !!! api "<span id="pore-ball2Fluid(obj)">ball2Fluid(obj)</span>"
            根据固体颗粒堆积计算孔隙流体面积,密度,压力等

            

            

            

        !!! api "<span id="pore-density2Mass(obj)">density2Mass(obj)</span>"
            通过孔隙流体密度更新质量

            

            

            

        !!! api "<span id="pore-density2Pressure(obj)">density2Pressure(obj)</span>"
            通过孔隙流体密度更新压力

            

            

            

        !!! api "<span id="pore-dispNote(obj,note)">dispNote(obj,note)</span>"
            消息输出

            note: 消息字符串

            

            

        !!! api "<span id="pore-fluid2Ball(p)">fluid2Ball(p)</span>"
            计算流体对固体作用力，更新d.mo.mPX, d.mo.mPZ

            

            

            

        !!! api "<span id="pore-gpuStatus=setGPU(obj,type0)">gpuStatus=setGPU(obj,type0)</span>"
            同build类

            

            

            

        !!! api "<span id="pore-mass2Density(obj)">mass2Density(obj)</span>"
            通过孔隙流体质量更新密度

            

            

            

        !!! api "<span id="pore-nConnectFilter2New=getNConnectFilter2(obj,nConnectFilter1)">nConnectFilter2New=getNConnectFilter2(obj,nConnectFilter1)</span>"
            用于更新nConnectFilter2，避免孤立颗粒(团)引起计算出错

            

            

            

        !!! api "<span id="pore-obj1=setNearbyPore(obj)">obj1=setNearbyPore(obj)</span>"
            重新搜索孔隙拓扑结构，用于数据传递

            

            obj：pore对象

            

        !!! api "<span id="pore-pArea0=getPoreArea(p)">pArea0=getPoreArea(p)</span>"
            计算孔隙面积

            

            

            

        !!! api "<span id="pore-pDensityNew=transferData(objOld,objNew)">pDensityNew=transferData(objOld,objNew)</span>"
            基于新老孔隙拓扑结构更新孔隙流体密度(以满足质量守恒)，进而更新流体压力

            

            

            

        !!! api "<span id="pore-pId=setBallPara(obj,type,bId,value)">pId=setBallPara(obj,type,bId,value)</span>"
            部分更新颗粒邻居孔隙求解参数 记录于p.SET中

            type: 参数名; bId: 颗粒Id, value: 颗粒属性值

            

            见GeoThermalBox示例

        !!! api "<span id="pore-recordStatus(obj)">recordStatus(obj)</span>"
            *待开发

            

            

            

        !!! api "<span id="pore-setWaterdR(obj)">setWaterdR(obj)</span>"
            基于p.aWaterdR设置孔喉的水力半径，用于计算cDiameterAdd

            

            

            

        !!! api "<span id="pore-showData(obj,vName)">showData(obj,vName)</span>"
            绘图基函数，一般不直接使用

            vName: 属性名，绘图内容

            

            

