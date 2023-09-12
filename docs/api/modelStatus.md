# modelStatus

!!! api "class <span id="modelStatus-modelStatus">modelStatus</span>"
    ???+ api "<span id="modelStatus-props">Properties</span>"
        !!! api "<span id="modelStatus-TAG">TAG</span>"
            记录输出信息

            TAG为结构体，可添加任意的子对象

        !!! api "<span id="modelStatus-SET">SET</span>"
            记录设置信息

            SET为结构体，可添加任意的子对象

        !!! api "<span id="modelStatus-PAR">PAR</span>"
            并行计算用*

            

        !!! api "<span id="modelStatus-gravityE0">gravityE0</span>"
            参考重力势能

            使初始化时的重力热能为0

        !!! api "<span id="modelStatus-recordCommand">recordCommand</span>"
            记录命令

            在每次运行d.mo.recordStatus的最后运行

        !!! api "<span id="modelStatus-Ts">Ts</span>"
            时间步记录

            每次运行d.recordStatus();后记录的时间

        !!! api "<span id="modelStatus-gravityEs">gravityEs</span>"
            重力势能记录

            单列矩阵

        !!! api "<span id="modelStatus-kineticEs">kineticEs</span>"
            动能记录

            单列矩阵

        !!! api "<span id="modelStatus-elasticEs">elasticEs</span>"
            弹性应变能记录

            单列矩阵

        !!! api "<span id="modelStatus-totalEs">totalEs</span>"
            总能量记录

            单列矩阵

        !!! api "<span id="modelStatus-heats">heats</span>"
            热量记录

            矩阵[Viscosity Heat, Normal Breaking Heat, Shear Breaking Heat, Slipping Heat, Failure Heat]，其中Failure Heat为单元屈服破坏时产生的热（见Liu et al., 2015，JGR），一般不使用。

        !!! api "<span id="modelStatus-dem">dem</span>"
            build对象

            即d

        !!! api "<span id="modelStatus-model">model</span>"
            model对象

            即d.mo

        !!! api "<span id="modelStatus-bIndex">bIndex</span>"
            边界范围记录（未来将取消）

            

        !!! api "<span id="modelStatus-breakId">breakId</span>"
            裂隙生成信息(当d.mo.isCrack=1时自动记录）

            矩阵中记录[裂隙的两个单元，裂隙生成时间，裂隙类型]，类型0为原生裂隙（建模时生成，在d.show('Crack')显示为绿色），类型1为张裂隙（红色），2为剪裂隙（蓝色）

        !!! api "<span id="modelStatus-leftBFs">leftBFs</span>"
            左边界受力变化

            三列矩阵，分别记录X,Y,Z方向上受力分量

        !!! api "<span id="modelStatus-rightBFs">rightBFs</span>"
            右边界受力变化

            三列矩阵，分别记录X,Y,Z方向上受力分量

        !!! api "<span id="modelStatus-frontBFs">frontBFs</span>"
            前边界受力变化

            三列矩阵，分别记录X,Y,Z方向上受力分量

        !!! api "<span id="modelStatus-backBFs">backBFs</span>"
            后边界受力变化

            三列矩阵，分别记录X,Y,Z方向上受力分量

        !!! api "<span id="modelStatus-bottomBFs">bottomBFs</span>"
            底边界受力变化

            三列矩阵，分别记录X,Y,Z方向上受力分量

        !!! api "<span id="modelStatus-topBFs">topBFs</span>"
            顶边界受力变化

            三列矩阵，分别记录X,Y,Z方向上受力分量

        !!! api "<span id="modelStatus-legendLocation">legendLocation</span>"
            图例显示的位置

            值可为'north','east'等，具体见Matlab 'legend'命令

        !!! api "<span id="modelStatus-workTIds">workTIds</span>"
            外力做功对应的时间步

            外力做功时对应的Ts中的时间Id

        !!! api "<span id="modelStatus-works">works</span>"
            外力所做的功

            对应于workTIds的功

    ???+ api "<span id="modelStatus-methods">Methods</span>"
        !!! api "<span id="modelStatus-show(type)">show(type)</span>"
            显示通过recordCommand命令记录的曲线数据

            曲线参数名，见user_LineModel示例

            d.status.show('SETleftFZ');

            

        !!! api "<span id="modelStatus-dispEnergy()">dispEnergy()</span>"
            文字显示当前各类能量状态

            无

            d.status.dispEnergy();

            

        !!! api "<span id="modelStatus-recordStatus()">recordStatus()</span>"
            记录当前状态在以's'结尾的属性中

            

            

            

        !!! api "<span id="modelStatus-dispNote(note)">dispNote(note)</span>"
            显示信息*

            

            

            

        !!! api "<span id="modelStatus-setRecordFunction(functionName)">setRecordFunction(functionName)</span>"
            设置recordStatus运行时的附加处理函数

            functionName:函数文件名

            d.status.setRecordFunction('fun/recordFun.m');见BoxShear3

            

        !!! api "<span id="modelStatus-modelStatus(dem)">modelStatus(dem)</span>"
            初始化modelStatus对象*（见build.resetStatus)

            

            

            

        !!! api "<span id="modelStatus-setInitialModelWHT()">setInitialModelWHT()</span>"
            记录计算块状模型的初始宽高厚（X,Y,Z）*

            

            

            

        !!! api "<span id="modelStatus-showParticleForce(Id, list)">showParticleForce(Id, list)</span>"
            显示某单元的受力，无用，未来将去除*

            

            

            

        !!! api "<span id="modelStatus-getElasticEnergy()">getElasticEnergy()</span>"
            获取弹性应变能，在recordStatus中用*

            

            

            

        !!! api "<span id="modelStatus-setSystemEnergy()">setSystemEnergy()</span>"
            设置系统能量，在recordStatus中用*

            

            

            

        !!! api "<span id="modelStatus-getBoundaryForce()">getBoundaryForce()</span>"
            获取边界力，在recordStatus中用

            获取所有边界单元（墙单元）的受力

            bFXYZ，记录[bFX,bFY,bFZ]

            

        !!! api "<span id="modelStatus-runRecordCommand()">runRecordCommand()</span>"
            运行recordCommand中的命令一次，通常在运行完resetStatus和定义recordCommand后，运行这个函数，以保证记录数据的长度和其它固有参数一致

            

            user_LineModel

            

        !!! api "<span id="modelStatus-setBoundaryForce()">setBoundaryForce()</span>"
            设置边界力*

            

            

            

        !!! api "<span id="modelStatus-showEnergy()">showEnergy()</span>"
            显示能量曲线，在d.show()中用*

            

            

            

        !!! api "<span id="modelStatus-showHeat()">showHeat()</span>"
            显示热量曲线，在d.show()中用*

            

            

            

        !!! api "<span id="modelStatus-showBoundaryForces()">showBoundaryForces()</span>"
            显示边界受力曲线，在d.show()中用*

            

            

            

        !!! api "<span id="modelStatus-calculateEv()">calculateEv()</span>"
            将取消*

            

            

            

        !!! api "<span id="modelStatus-calculateCu()">calculateCu()</span>"
            将取消*

            

            

            

        !!! api "<span id="modelStatus-calculateTu()">calculateTu()</span>"
            将取消*

            

            

            

        !!! api "<span id="modelStatus-showStrainStress()">showStrainStress()</span>"
            显示应力应变曲线，在d.show()中用*

            

            

            

        !!! api "<span id="modelStatus-showBoundaryStresses()">showBoundaryStresses()</span>"
            显示边界应力曲线，在d.show()中用*

            

            

            

