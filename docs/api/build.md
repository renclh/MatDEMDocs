# build

!!! api "class <span id="build-build">build</span>"
    ???+ api "<span id="build-props">Properties</span>"
        !!! api "<span id="build-name">name</span>"
            模型名称

            字符串

        !!! api "<span id="build-TAG">TAG</span>"
            模拟信息记录，用于记录和输出信息

            TAG是一个结构体，可利用其存储各类输出数据

        !!! api "<span id="build-SET">SET</span>"
            模拟设置信息，可记录二次开发新的数据

            SET是一个结构体，可利用其存储各类二次开发数据

        !!! api "<span id="build-PAR">PAR</span>"
            用于平行计算的参数

            平行计算未启用

        !!! api "<span id="build-GROUP">GROUP</span>"
            组信息，详见下方说明

            记录了定义的各个组，组名不能以group开头

        !!! api "<span id="build-Loads">Loads</span>"
            荷载信息

            未启用，未来可能去除

        !!! api "<span id="build-isPar">isPar</span>"
            是否并行计算

            功能未启用

        !!! api "<span id="build-is2D">is2D</span>"
            是否为二维模型

            默认为0，进行三维计算

        !!! api "<span id="build-data">data</span>"
            结果数据集

            部分后处理命令的数据集，如位移场、应力场（见右说明）

        !!! api "<span id="build-mo">mo</span>"
            计算模块

            

        !!! api "<span id="build-po">po</span>"
            孔隙对象，用于孔隙渗流和流固耦合计算

            见PoreFlood等示例

        !!! api "<span id="build-status">status</span>"
            模型状态

            

        !!! api "<span id="build-Mats">Mats</span>"
            材料元胞数组（cell array）

            材料的元胞数组，d.Mats{1}为第一个材料

        !!! api "<span id="build-vRate">vRate</span>"
            粘滞阻尼系数

            临界阻尼所要乘以的系数，见文字教程中阻尼的说明

        !!! api "<span id="build-g">g</span>"
            重力系数

            默认为-9.8

        !!! api "<span id="build-module">module</span>"
            此模拟的建模器，如obj_Box

            未启用，未来可能去除

        !!! api "<span id="build-isUI">isUI</span>"
            是否在窗口程序中运行，取0时，show命令将在新窗口画图

            默认为1

        !!! api "<span id="build-edit_output">edit_output</span>"
            提示信息对象

            系统参数，勿修改

        !!! api "<span id="build-aNum*">aNum*</span>"
            模型单元和固定墙单元个数和（见下方具体说明）

            

        !!! api "<span id="build-mNum*">mNum*</span>"
            模型单元个数（见下方具体说明）

            

        !!! api "<span id="build-aMatId">aMatId</span>"
            单元的材料编号

            

        !!! api "<span id="build-aX">aX</span>"
            模型单元的X轴坐标

            

        !!! api "<span id="build-aY">aY</span>"
            模型单元的Y轴坐标

            

        !!! api "<span id="build-aZ">aZ</span>"
            模型单元的Z轴坐标

            

        !!! api "<span id="build-aR">aR</span>"
            模型单元的半径

            

        !!! api "<span id="build-aKN">aKN</span>"
            单元正向劲度系数

            

        !!! api "<span id="build-aKS">aKS</span>"
            单元切向劲度系数

            

        !!! api "<span id="build-aBF">aBF</span>"
            单元断裂力

            

        !!! api "<span id="build-aFS0">aFS0</span>"
            单元初始抗剪强度

            

        !!! api "<span id="build-aMUp">aMUp</span>"
            单元摩擦系数

            

        !!! api "<span id="build-isFluidVis">isFluidVis</span>"
            作用在单元上是否为流体的阻尼设定，运行groupMat2Model或applyMaterial后，这一参数产生效果，这一设定增加于2.60版

            以落体为例，当设为流体阻尼时（1），单元的阻尼力与单元面积成正比，那么大的颗粒的下沉速度较快；当设为固体阻尼时（0），阻尼力与单元体积成正比，大颗粒和小颗粒的下沉速度一致，类似于用一个大颗粒代表相应的小颗粒时，总阻尼也是与体积成正比

        !!! api "<span id="build-mVis">mVis</span>"
            单元粘滞阻尼系数

            

        !!! api "<span id="build-mM">mM</span>"
            单元质量

            

        !!! api "<span id="build-period">period</span>"
            一个单元固定在墙上时的简谐振动周期

            

        !!! api "<span id="build-dbXYZ">dbXYZ</span>"
            单元在newStep函数中的边界位移

            

        !!! api "<span id="build-bIndex">bIndex</span>"
            边界单元信息，功能被取代，未来将取消

            

        !!! api "<span id="build-saveHour">saveHour</span>"
            保存数据文件间隔时间

            

        !!! api "<span id="build-step">step</span>"
            当前模拟步，用于迭代计算，见示例

            

        !!! api "<span id="build-totalStep">totalStep</span>"
            总模拟步

            

        !!! api "<span id="build-isNote">isNote</span>"
            是否显示模拟提示

            0，1

        !!! api "<span id="build-note">note</span>"
            提示内容

            

        !!! api "<span id="build-figureNumber">figureNumber</span>"
            绘图的窗口号，可指定在某一窗口绘图

            见Roller3，PoreFlood3等示例

        !!! api "<span id="build-Rrate">Rrate</span>"
            显示单元的半径系数

            取0.5可看在内部颗粒，默认为1

        !!! api "<span id="build-showB">showB</span>"
            显示边界方式

            可为0，1，2，3，具体见后处理

        !!! api "<span id="build-showBallLimit">showBallLimit</span>"
            大于此值时，单元显示为点

            默认为一千万

    ???+ api "<span id="build-methods">Methods</span>"
        !!! api "<span id="build-addTimeProp(gName, type, Ts, Vs)">addTimeProp(gName, type, Ts, Vs)</span>"
            设置指定组的属性随时间的变化，可用于产生振动。设置信息记录于d.mo.SET.PROP

            gName:组名；type:属性名；Ts:时间；Vs：时间对应的值

            无

            见user_LineModel

        !!! api "<span id="build-removeTimeProp(gName, type)">removeTimeProp(gName, type)</span>"
            删除指定组的属性随时间的变化

            gName:组名；type:属性名；

            无

            见user_LineModel

        !!! api "<span id="build-addRecordProp(gName, type)">addRecordProp(gName, type)</span>"
            设置要在运行d.recordStatus时，记录指定组的属性平均值，设置信息记录于d.status.SET.PROP。仅限于记录d.mo中的单元属性，其它属性可使用d.status.recordCommand来设置和使用，具体见LineModel示例

            gName:组名；type:属性名；

            无

            见user_LineModel

        !!! api "<span id="build-removeRecordProp(gName, type)">removeRecordProp(gName, type)</span>"
            删除指定组的属性记录

            gName:组名；type:属性名；

            无

            见user_LineModel

        !!! api "<span id="build-addElement(matId, addObj, varargin)">addElement(matId, addObj, varargin)</span>"
            利用结构体（.X,.Y,.Z,.R信息）增加单元，增加单元后会自动运行d.setStandarddT将时间步设为标准值

            材料号，结构体或多个结构体的cell数组，第三个参数可选，为单元类型，取"model"（活动单元）,"wall"（固定单元)，默认为"model"

            

            [sphere1Id,sphere2Id,boxId]=d.addElement(1,{sphereObj,sphereObj2,boxObj});

        !!! api "<span id="build-addFixId(direction, gId)">addFixId(direction, gId)</span>"
            增加要锁定自由度的单元（锁定坐标）

            锁定的方向（'X','Y','Z'，其三个方向的组合)；gId:单元编号数组

            此维度上新锁定编号newFixId

            d.addFixId('X',2);锁定第二个单元的x坐标，d.addFixId('XYZ',2);锁定第二个单元的xyz坐标

        !!! api "<span id="build-addGroup(gName,gId,varargin)">addGroup(gName,gId,varargin)</span>"
            在当前模型中定义一个新组，d.addGroup(gName,gId,matId);

            gName:组名；gId:单元编号数组; matId：材料号。可为2或3个输入参数，当输入参数为2个时，材料号默认为1，可采用d.setGroupMat来修改组的材料

            无

            d.addGroup(gName,gId);

        !!! api "<span id="build-addMaterial(newMat)">addMaterial(newMat)</span>"
            增加一个新材料到d.Mats中

            newMat:材料对象

            无

            

        !!! api "<span id="build-balance(varargin)">balance(varargin)</span>"
            最重要的平衡迭代函数，见下方说明

            多个输入参数

            无

            

        !!! api "<span id="build-balanceBondedModel(varargin)">balanceBondedModel(varargin)</span>"
            赋材料后，自动胶结和平衡模型，有单元间摩擦力。原始松散无粘结的堆积体将被粘结

            输入参数为标准平衡次数，为空时则取1

            无

            参考BoxModel等示例的第二步

        !!! api "<span id="build-balanceBondedModel0(varargin)">balanceBondedModel0(varargin)</span>"
            赋材料后，自动胶结和平衡模型，无单元间摩擦力。原始松散无粘结的堆积体将被粘结

            输入参数为标准平衡次数，为空时则取1

            无

            参考BoxModel等示例的第二步

        !!! api "<span id="build-balanceForce(Amax, num)">balanceForce(Amax, num)</span>"
            平衡模型中的力

            Amax:目标最大加速度，num:平衡步次

            无

            

        !!! api "<span id="build-breakGroup(varargin)">breakGroup(varargin)</span>"
            断开指定组内连接或两个组间的连接

            无输入参数时，d.breakGroup()，断开所有单元的连接；一个输入参数时，d.breakGroup('group1')则断开这个组的组内连接，如输入的是元胞矩阵，d.breakGroup({'group1','group2'})，则断开这些组的组内连接；如输入二个参数时，d.breakGroup('group1','group2')断开这两个组之间的连接

            nBreakFilter

            d.breakGroup('sample');

        !!! api "<span id="build-breakGroupOuter(varargin)">breakGroupOuter(varargin)</span>"
            断开指定组向外的连接

            无输入组名时，断开所有组外连接；输入一个组名时，断开这个组的组外连接；

            nBreakFilter

            

        !!! api "<span id="build-calculateData()">calculateData()</span>"
            计算得到非独立性数据，在加载数据后使用

            无

            无

            

        !!! api "<span id="build-clearData(varargin)">clearData(varargin)</span>"
            清理非独立性的数据，使保存的数据文件较小

            level，通常取1，取2时会将GROUP信息清除

            无

            

        !!! api "<span id="build-connectGroup(varargin)">connectGroup(varargin)</span>"
            胶结指定组内连接或两个组间连接

            无输入参数时，d.connectGroup()，胶结所有连接；一个输入参数时，d.connectGroup('group')，胶结这个组的组内连接；二个输入参数时，d.connectGroup('group1','group2')胶结两个组之间的连接

            nConnectFilter

            d.connectGroup('sample');

        !!! api "<span id="build-connectGroupOuter(gName)">connectGroupOuter(gName)</span>"
            胶结指定组向外的连接

            gName组名（d.GROUP中的组名）

            nConnectFilter

            

        !!! api "<span id="build-defineModelElement(gName)">defineModelElement(gName)</span>"
            将指定组的单元重定义为普通模型单元（可活动）

            gName组名（d.GROUP中的组名）

            无

            见Box_3DSlope示例

        !!! api "<span id="build-defineWallElement(gName)">defineWallElement(gName)</span>"
            将指定组的单元重定义为墙单元（固定）

            gName组名（d.GROUP中的组名）

            无

            见Box_3DSlope示例

        !!! api "<span id="build-delElement(delId)">delElement(delId)</span>"
            删除指定的单元（2.5版本后取消d.mo.isShear自动设为1，保持原来isShear）。注意：这个函数计算较复杂，仅在建模时使用，在迭代计算时，建议使用killElement来消除单元的作用

            delId (double array):要删除单元的编号数组

            无

            

        !!! api "<span id="build-deleteConnection(type)">deleteConnection(type)</span>"
            删除胶结

            type:类型，可取'boundary'

            无

            d.deleteConnection('boundary');%delete the connection of boundary

        !!! api "<span id="build-delGroup(gNames)">delGroup(gNames)</span>"
            删除指定的名称的组（不会删除单元）

            gNames (cell array):

            无

            

        !!! api "<span id="build-dispNote(note)">dispNote(note)</span>"
            在主窗口中显示提示信息

            note:提示信息字符串

            无

            

        !!! api "<span id="build-findNearestId(x,y,z)">findNearestId(x,y,z)</span>"
            找出离指定点最近的单元编号

            x,y,z单元的坐标

            单元编号

            

        !!! api "<span id="build-getGroupForce(gName,gName2)">getGroupForce(gName,gName2)</span>"
            1个输入时，获得组受其它单元的总力；2个输入时，获得组受另一个组的总力

            gName：需要计算受力的组名；gName2（可选），

            GForce：组gName的受力结构体

            

        !!! api "<span id="build-getGroupId(gName)">getGroupId(gName)</span>"
            获取给定组的单元编号

            gName (String):组名

            无

            

        !!! api "<span id="build-getMatIdByName(matName)">getMatIdByName(matName)</span>"
            根据材料名获取该材料的Id

            matName (String):材料名

            matId (double)：材料Id

            

        !!! api "<span id="build-group2Obj(gNames)">group2Obj(gNames)</span>"
            将组的坐标信息转化为Obj结构体

            组名（可用cell矩阵输入多个组，如gNames={'sample','topPlaten'};

            

            见SlopeNet示例

        !!! api "<span id="build-groupMat2Model(varargin)">groupMat2Model(varargin)</span>"
            将给定组的材料设置到模型中

            gNames (cell array):

            无

            

        !!! api "<span id="build-killElement(killedId)">killElement(killedId)</span>"
            将指定单元“杀死“：锁定单元坐标，将其刚度和半径设为极小值 

            killedId：单元的编号数组

            无

            见user_BoxCrash2Drill

        !!! api "<span id="build-makeModelByGroups(gNames)">makeModelByGroups(gNames)</span>"
            利用给定的组建立新模型

            gNames (cell array):

            提示，0：1：完成新模型；2：不可删除全部单元；

            

        !!! api "<span id="build-minusGroup(gNames1, gNames2, varargin)">minusGroup(gNames1, gNames2, varargin)</span>"
            组相减，gNames1中的组减去gNames2中的组

            组1（可为cell矩阵），组2，组2膨胀率。注意miniusGroup后通常需要运行balanceBondedModel或gravitySediment使新加的物体和原有的单元紧密贴合

            无

            参见pile示例

        !!! api "<span id="build-moveBoundary(type, dx, dy, dz)">moveBoundary(type, dx, dy, dz)</span>"
            移动边界（使用moveGroup命令）

            type:类型，可取‘left’'right''front''back''bottom''top'

            无

            

        !!! api "<span id="build-moveGroup(gName, dX, dY, dZ, varargin)">moveGroup(gName, dX, dY, dZ, varargin)</span>"
            移动组的单元

            [组名，x位移，y位移，z位移，可选参数]，可选参数为'mo'时，将只移动d.mo，而d不移动（通常用于模拟时），无可选参数时，将移动d和d.mo（通常用于前处理建模时）

            

            

        !!! api "<span id="build-protectGroup(gName,type)">protectGroup(gName,type)</span>"
            将组声明为保护，即记录于d.GROUP.groupProtect

            gName组名；type可取'on'或'off'，打开或关闭保护

            无

            见Box_3DSlope示例

        !!! api "<span id="build-recordStatus()">recordStatus()</span>"
            记录当前状态于d.status中

            无

            无

            

        !!! api "<span id="build-removeFixId(direction, Id)">removeFixId(direction, Id)</span>"
            删除单元的自由度锁定

            删除锁定的方向（'X','Y','Z')，

            无

            涉及d.mo中的参数FixXId;FixYId;FixZId;

        !!! api "<span id="build-removeGroupForce(G1_gId, G2_gId)">removeGroupForce(G1_gId, G2_gId)</span>"
            忽略两个组间的所有作用力，数据被保存在d.mo.SET.groupPair中，当其中的G1_gId或G2_gId为空时，会在下一次运行setNearbyBall时被自动删除

            G1, G2可以为组名(String)或组Id数组

            无

            

        !!! api "<span id="build-removePrestress(rate,gName)">removePrestress(rate,gName)</span>"
            将单元的抗拉力临时减小，断开胶结，消除单元间的张力（预应力）

            rate:张力变化比率；gName:消除预应力的组名。可输入0到2个参数，rate默认值为0，无gName输入时，则对全部单元消除预应力

            无

            1.92版增加

        !!! api "<span id="build-resetStatus()">resetStatus()</span>"
            重设d.status整个对象，包括数据和曲线

            无

            无

            示例中有较多应用

        !!! api "<span id="build-rotateGroup(gName, type, angle, varargin)">rotateGroup(gName, type, angle, varargin)</span>"
            旋转指定组的单元

            [组名，旋转的平面（取'XY','YZ','XZ'），旋转角度，可选参数]，可选参数为空时，计算组的中心，并以中心旋转。可选参数为x,y,z时，则按x,y,z为中心旋转

            

            

        !!! api "<span id="build-setClump(varargin)">setClump(varargin)</span>"
            设置组为clump，并清除组内力

            输入要做成clump的组名，当输入为空时，则将所有组编号小于-10的单元转成clump（用于处理B.isClump=1）。也可直接输入要做clump的单元编号数组

            无

            

        !!! api "<span id="build-setGroupId()">setGroupId()</span>"
            根据不同组对d.GROUP.groupId设置单元组编号，后续用d.show('groupId')来显示不同组。由于一个单元可能属于多个组，有时需要手动操作d.data.groupId数组

            无

            无

            

        !!! api "<span id="build-setGroupMat(gName, matName)">setGroupMat(gName, matName)</span>"
            声明组的材料，后面使用groupMat2Model命令应用材料

            gName (String):组名，记录于d.GROUP中；matName (String):材料名，记录于d.Mats中

            无

            

        !!! api "<span id="build-setGroupOuterBondRate(gName,bondRate)">setGroupOuterBondRate(gName,bondRate)</span>"
            设置组向外连接强度的残余率，用于设置节理

            类似connectGroupOuter，

            无

            

        !!! api "<span id="build-setModelStiffness(stiffnessRate)">setModelStiffness(stiffnessRate)</span>"
            改变d.mo中的单元刚度aKN,aKS并调整相应的d.period和d.mo.dT

            stiffnessRate：刚度变化系数，一般小于1，以增大时间步

            无

            见LineModel

        !!! api "<span id="build-setStandarddT()">setStandarddT()</span>"
            设置标准的时间步，并赋给d.mo.dT，约为最小周期的1/50

            无

            无

            

        !!! api "<span id="build-setStandardVis()">setStandardVis()</span>"
            设置标准的阻尼，并赋给d.mo.mVis，约为临界阻尼除以Z方向单元数

            

            无

            

        !!! api "<span id="build-setUIoutput(varargin)">setUIoutput(varargin)</span>"
            设置窗口信息提示，在load新数据后使用B.setUIoutput()

            

            无

            

        !!! api "<span id="build-show(varargin)">show(varargin)</span>"
            显示结果，见后处理

            见后处理

            

            

        !!! api "<span id="build-showConnection(varargin)">showConnection(varargin)</span>"
            显示单元间胶结，对应于d.show('--')

            见后处理

            

            

        !!! api "<span id="build-showFilter(varargin)">showFilter(varargin)</span>"
            切割显示结果

            见后处理

            

            

        !!! api "<span id="build-showFrame0()">showFrame0()</span>"
            显示模型边框线

            见后处理

            

            

        !!! api "<span id="build-showSorting(varargin)">showSorting(varargin)</span>"
            显示级配

            无输入参数时，显示sample组的级配；输入gName时，显示指定组的级配图

            C: 分选相信息集

            

        !!! api "<span id="build-tic(totalCircle)">tic(totalCircle)</span>"
            记录起始时间

            

            

            见示例第三步

        !!! api "<span id="build-toc()">toc()</span>"
            获得起始时间以来经过的时间

            

            

            见示例第三步

        !!! api "<span id="build-以下为程序内部函数，通常不直接使用">以下为程序内部函数，通常不直接使用</span>"
            

            

            

            

        !!! api "<span id="build-addLoading(newLoad)">addLoading(newLoad)</span>"
            增加荷载*，将取消

            

            无

            

        !!! api "<span id="build-applyLoading(varargin)">applyLoading(varargin)</span>"
            应用荷载*，将取消

            

            无

            

        !!! api "<span id="build-applyMaterial()">applyMaterial()</span>"
            应用全部材料*

            

            

            

        !!! api "<span id="build-deleteMatrix()">deleteMatrix()</span>"
            删除build中所有的矩阵和数组，以减小文件大小

            

            

            

        !!! api "<span id="build-general3Dset()">general3Dset()</span>"
            三维显示

            

            

            

        !!! api "<span id="build-getData(valueName)">getData(valueName)</span>"
            计算后处理所需参数*

            

            

            

        !!! api "<span id="build-getGroupOuterConnectFilter(varPara)">getGroupOuterConnectFilter(varPara)</span>"
            获取组向外的连接

            

            无

            

        !!! api "<span id="build-getJointFilter2D(X1, Z1, X2, Z2)">getJointFilter2D(X1, Z1, X2, Z2)</span>"
            *

            

            

            

        !!! api "<span id="build-getModel()">getModel()</span>"
            把d.mo中的{'aNum','mNum','aX','aY','aZ','aR','aKN','aKS','aBF','aFS0','aMUp','mM','mVis','aMatId'};属性赋给d

            

            

            

        !!! api "<span id="build-getNoEmptyGroupNames()">getNoEmptyGroupNames()</span>"
            获取非空组的名称

            无

            gNames (cell array):组名矩阵

            

        !!! api "<span id="build-getSubModel(modelId)">getSubModel(modelId)</span>"
            用于并行计算*

            

            无

            

        !!! api "<span id="build-getSurfFilter2D(Surf)">getSurfFilter2D(Surf)</span>"
            *

            

            

            

        !!! api "<span id="build-gif(command)">gif(command)</span>"
            制作动画（将取消），用user_makegif

            

            

            

        !!! api "<span id="build-importStandardModel(stdMo)">importStandardModel(stdMo)</span>"
            导入标准的模型，如obj_Box和obj_3AxisTester*

            

            build对象

            

        !!! api "<span id="build-initializeLoading()">initializeLoading()</span>"
            初始化荷载*（将取消）

            无

            无

            

        !!! api "<span id="build-loadOriginalModel(modelId)">loadOriginalModel(modelId)</span>"
            *

            

            

            

        !!! api "<span id="build-newStep()">newStep()</span>"
            移动边界后设定新的一步（将取消）*

            

            

            

        !!! api "<span id="build-pShow(modelId, varargin)">pShow(modelId, varargin)</span>"
            *

            

            

            

        !!! api "<span id="build-readModel(modelId)">readModel(modelId)</span>"
            *

            

            

            

        !!! api "<span id="build-recordCalHour(timeName)">recordCalHour(timeName)</span>"
            保存当前时间和时间名

            

            

            

        !!! api "<span id="build-recordTime(timeName)">recordTime(timeName)</span>"
            记录模拟开始到此时的时间，在obj.mo.TAG.recordTime

            

            

            

        !!! api "<span id="build-resetShearForce()">resetShearForce()</span>"
            将mo模型中的单元切向力全设为0

            

            

            

        !!! api "<span id="build-saveOriginalModel()">saveOriginalModel()</span>"
            *

            

            

            

        !!! api "<span id="build-setBuild()">setBuild()</span>"
            设置build对象*

            

            

            

        !!! api "<span id="build-setClumpOff(varargin)">setClumpOff(varargin)</span>"
            *未开发

            

            

            

        !!! api "<span id="build-setData()">setData()</span>"
            *

            

            

            

        !!! api "<span id="build-setMembraneUnit(Ids)">setMembraneUnit(Ids)</span>"
            设置膜单元，用于常规三轴试验*

            

            无

            

        !!! api "<span id="build-setModel()">setModel()</span>"
            设置mo子对象*

            

            

            

        !!! api "<span id="build-setModelPara()">setModelPara()</span>"
            设置模型参数*

            

            

            

        !!! api "<span id="build-setSubModel(modelId)">setSubModel(modelId)</span>"
            用于并行计算*

            

            

            

        !!! api "<span id="build-setSurfBond(Surf, para)">setSurfBond(Surf, para)</span>"
            *

            

            

            

        !!! api "<span id="build-setSurfBond(Surf,type)">setSurfBond(Surf,type)</span>"
            根据C(Tool_Cut对象）中记录的平面生成裂隙、节理或胶结

            Surf:Tool_Cut中定义的层面；type：可取'glue','break'或者指定强度的残余率

            无

            见示例BoxModel2。d.setSurfBond(C.Surf(1),0.2);将平面1的强度设为20%（生成节理），d.setSurfBond(C.Surf(1),'break')生成裂隙面

        !!! api "<span id="build-showBall(Id)">showBall(Id)</span>"
            显示某个单元及其接触单元

            

            

            见后处理

        !!! api "<span id="build-showBondRate(obj,varargin)%mShowFilter, shown when value is true">showBondRate(obj,varargin)%mShowFilter, shown when value is true</span>"
            

            

            

            

        !!! api "<span id="build-showData(V)">showData(V)</span>"
            show的基函数*

            

            

            

        !!! api "<span id="build-smoothBoundary()">smoothBoundary()</span>"
            平滑边界*（将取消）

            

            

            

        !!! api "<span id="build-testSpeed(varargin)">testSpeed(varargin)</span>"
            运行若干性d.mo.zeroBalance()来测试计算速度，用在d.mo.setGPU('auto')中

            可为空，当有一个输入参数时，为测试迭代次数

            当前计算速度（每秒计算颗粒运动次数）

            speed=d.testSpeed();

        !!! api "<span id="build-visBalance(visRate, num)">visBalance(visRate, num)</span>"
            将取消*

            

            

            

