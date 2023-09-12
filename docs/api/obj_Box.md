# obj_Box

!!! api "class <span id="obj_Box-obj_Box">obj_Box</span>"
    ???+ api "<span id="obj_Box-props">Properties</span>"
        !!! api "<span id="obj_Box-lang=‘en'">lang=‘en'</span>"
            软件语言

            

        !!! api "<span id="obj_Box-randomSeed=1">randomSeed=1</span>"
            随机种子

            用于确定初始的模型随机模态

        !!! api "<span id="obj_Box-distriRate=0.25">distriRate=0.25</span>"
            颗粒直径分散系数，最大直径与最小直径比值为(1+rate)^2

            

        !!! api "<span id="obj_Box-GPUstatus">GPUstatus</span>"
            初始的GPU计算设置，'off','on','auto','fixed'(锁定为CPU计算)

            见model函数

        !!! api "<span id="obj_Box-isUI">isUI</span>"
            在UI中显示消息，取1

            

        !!! api "<span id="obj_Box-edit_output">edit_output</span>"
            消息框的地址

            

        !!! api "<span id="obj_Box-uniformGRate=0">uniformGRate=0</span>"
            取1或0，确定重力沉积时是否采用统一的重力加速度g；当其为1时，颗粒采用正常重力堆积；当其为0时，上方的颗粒会受到较大的重力加速度，从而加快整体颗粒体系的堆积；默认值为0，能较快过完成堆积，值为1时，堆积时间可能增加到2，3倍

            

        !!! api "<span id="obj_Box-resetStatusBeforeDrop">resetStatusBeforeDrop</span>"
            在随机运动之后，重力堆积前重置记录，即运行d.status.

            

        !!! api "<span id="obj_Box-Surf">Surf</span>"
            用于切分模型的面，参考user_BoxModel示例

            

        !!! api "<span id="obj_Box-name">name</span>"
            模型名

            

        !!! api "<span id="obj_Box-type='topPlaten';">type='topPlaten';</span>"
            模型类型，确定是否使用6个压力板，见Box.platenStatus。运行B.setType()时，根据type来确定B.platenStatus

            可为'none',botPlaten','topPlaten','GeneralSlope','TriaxialCompression'

        !!! api "<span id="obj_Box-isClump">isClump</span>"
            定义模型颗粒是否为clump颗粒

            

        !!! api "<span id="obj_Box-d">d</span>"
            模型build对象

            

        !!! api "<span id="obj_Box-g=-9.8">g=-9.8</span>"
            重力加速度

            

        !!! api "<span id="obj_Box-TAG">TAG</span>"
            模型信息

            

        !!! api "<span id="obj_Box-SET">SET</span>"
            模型设置

            

        !!! api "<span id="obj_Box-is2D=0">is2D=0</span>"
            模型是否为二维模型

            

        !!! api "<span id="obj_Box-GROUP">GROUP</span>"
            模型中的组，将自动转至生成的build对象中，即B.d

            

        !!! api "<span id="obj_Box-Mo">Mo</span>"
            模型单元结构体，包括压力板

            

        !!! api "<span id="obj_Box-Bo">Bo</span>"
            边界单元结构体

            

        !!! api "<span id="obj_Box-Mats">Mats</span>"
            材料cell数组

            

        !!! api "<span id="obj_Box-ballR">ballR</span>"
            单元平均半径

            

        !!! api "<span id="obj_Box-modelH_rate=1">modelH_rate=1</span>"
            模型边界的增高比率（由于沉积的高度会比边界高度低）

            

        !!! api "<span id="obj_Box-X">X</span>"
            单元的X坐标数组

            

        !!! api "<span id="obj_Box-Y">Y</span>"
            单元的Y坐标数组

            

        !!! api "<span id="obj_Box-Z">Z</span>"
            单元的Z坐标数组

            

        !!! api "<span id="obj_Box-R">R</span>"
            单元的半径数组

            

        !!! api "<span id="obj_Box-isShear">isShear</span>"
            是否有剪力

            

        !!! api "<span id="obj_Box-isShearAfter=1;">isShearAfter=1;</span>"
            运行完B.gravitySediment后是否打开剪力，默认为1

            

        !!! api "<span id="obj_Box-isSample">isSample</span>"
            初始时是否生成样品单元，当为0时只生成边界和底压力板

            

        !!! api "<span id="obj_Box-sampleW">sampleW</span>"
            模型箱子内部的宽

            

        !!! api "<span id="obj_Box-sampleL">sampleL</span>"
            模型箱子内部的长

            

        !!! api "<span id="obj_Box-sampleH">sampleH</span>"
            模型箱子内部的高

            

        !!! api "<span id="obj_Box-sample">sample</span>"
            样品单元结构体，不包括压力板

            

        !!! api "<span id="obj_Box-boundaryRrate=0.8">boundaryRrate=0.8</span>"
            边界相邻单元间距离与单元直径的比值

            

        !!! api "<span id="obj_Box-platenStatus=[0,0,0,0,0,1];">platenStatus=[0,0,0,0,0,1];</span>"
            压力板状态，6个值对应[左，右，前，后，下，上]

            当值为1时，产生相应的压力板

        !!! api "<span id="obj_Box-lefPlaten">lefPlaten</span>"
            左压力板的结构体，包含XYZR信息

            

        !!! api "<span id="obj_Box-rigPlaten">rigPlaten</span>"
            右压力板的结构体，包含XYZR信息

            

        !!! api "<span id="obj_Box-froPlaten">froPlaten</span>"
            前压力板的结构体，包含XYZR信息

            

        !!! api "<span id="obj_Box-bacPlaten">bacPlaten</span>"
            后压力板的结构体，包含XYZR信息

            

        !!! api "<span id="obj_Box-botPlaten">botPlaten</span>"
            底压力板的结构体，包含XYZR信息

            

        !!! api "<span id="obj_Box-topPlaten">topPlaten</span>"
            顶压力板的结构体，包含XYZR信息

            

        !!! api "<span id="obj_Box-lefB">lefB</span>"
            左边界的结构体，包含XYZR信息

            

        !!! api "<span id="obj_Box-rigB">rigB</span>"
            右边界的结构体，包含XYZR信息

            

        !!! api "<span id="obj_Box-froB">froB</span>"
            前边界的结构体，包含XYZR信息

            

        !!! api "<span id="obj_Box-bacB">bacB</span>"
            后边界的结构体，包含XYZR信息

            

        !!! api "<span id="obj_Box-botB">botB</span>"
            底边界的结构体，包含XYZR信息

            

        !!! api "<span id="obj_Box-topB">topB</span>"
            顶边界的结构体，包含XYZR信息

            

        !!! api "<span id="obj_Box-groupId">groupId</span>"
            组编号，6个边界编号由-1至-6，6个压力板编号由1至6

            

        !!! api "<span id="obj_Box-aMatId">aMatId</span>"
            材料编号

            

        !!! api "<span id="obj_Box-compactNum=0;">compactNum=0;</span>"
            建好堆积模型后的压实次数

            

        !!! api "<span id="obj_Box-sFilter=0;">sFilter=0;</span>"
            Box的showFilter，不常用

            

        !!! api "<span id="obj_Box-PexpandRate=1;">PexpandRate=1;</span>"
            压力板的延伸单元数

            

        !!! api "<span id="obj_Box-BexpandRate=2;">BexpandRate=2;</span>"
            边界的延伸单元数

            

        !!! api "<span id="obj_Box-fixPlaten=1;">fixPlaten=1;</span>"
            是否锁定platen的自由度，使platen只在平面法向上运动

            

        !!! api "<span id="obj_Box-saveFileLevel=1;">saveFileLevel=1;</span>"
            保存文件的层级，在UniaxialTest中用

            0不保存文件，1保存主要文件，2保存所有文件

    ???+ api "<span id="obj_Box-methods">Methods</span>"
        !!! api "<span id="obj_Box-setVisStatus(newType,baseBallR)">setVisStatus(newType,baseBallR)</span>"
            设置阻尼与单元直径的关系，默认情况下为'inWater'，即单元类似在水中下落，单元自由下降所受阻力与单元半径平方成正比，大颗粒下降较快；当设置为‘sameSpeed'时，则阻力与单元半径三次方成正比

            

            

            

        !!! api "<span id="obj_Box-calculateBlockDensity()">calculateBlockDensity()</span>"
            计算模型样品的密度（样品向内1.5倍半径取块算密度）

            无

            密度值

            用于自动训练中 

        !!! api "<span id="obj_Box-compactSample(compactNum,varargin)">compactSample(compactNum,varargin)</span>"
            利用上压力板来压实样品

            compactNum:压实次数;varargin:当输入1个参数时，设定夯实压力，当无输入时，夯实力取所有模型单元重力的两倍

            无

            示例的第一个文件

        !!! api "<span id="obj_Box-convert2D(ballR)">convert2D(ballR)</span>"
            将单元的属性从三维变成二维，相当于一个平面上的单元都变成同一厚度

            ballR:二维的厚度的一半

            无

            

        !!! api "<span id="obj_Box-cutGroup(gNames, surfId1, surfId2)">cutGroup(gNames, surfId1, surfId2)</span>"
            用两个层面切割组

            gNames:被切割的组名; surfId1:层面的编号; surfId2:层面的编号

            无

            参考mxSlope

        !!! api "<span id="obj_Box-gravitySediment(varargin)">gravitySediment(varargin)</span>"
            让单元随机运动，并在重力作用下堆积

            varargin:可变输入参数，当输入一个参数rate时，确定沉积的时间比率，当无输入参数时rate默认为1；当输入参数是"auto"时，是3.0版新功能，因为不同的堆积参数，其沉积所需要的时间不一样，当参数为“auto”时自动设定沉积时间，保证颗粒完成堆积。当输入参数为两个时，第二个参数为isCement，默认为0，即堆积时不粘结颗粒，当其为1时，堆积过程中颗粒接触即产生粘结力（如湿土颗粒），堆积体孔隙率会较大

            无

            示例的第一个文件

        !!! api "<span id="obj_Box-load(varargin)">load(varargin)</span>"
            将save命令保存的文件，重加载到B中

            当有1输入参数时，加载文件名后加['Step-' num3str(Step)]

            无

            B.load(1);

        !!! api "<span id="obj_Box-removeInterPlatenBoundaryForce()">removeInterPlatenBoundaryForce()</span>"
            消除压力板和相垂直的边界之间的作用力

            无

            无

            用于系统建立三轴应力

        !!! api "<span id="obj_Box-removeInterPlatenForce()">removeInterPlatenForce()</span>"
            消除各压力板间的作用力

            无

            无

            用于系统建立三轴应力

        !!! api "<span id="obj_Box-save(varargin)">save(varargin)</span>"
            将B文件保存为['TempModel/' B.name '-R' num2str(B.ballR) '-distri' num2str(B.distriRate)  'aNum' num2str(B.d.aNum) '.mat'];

            当有1输入参数时，保存文件名后加['Step-' num2str(Step)]

            无

            B.save(1);

        !!! api "<span id="obj_Box-setGPU( varargin)">setGPU( varargin)</span>"
            设置GPU计算模式

            varargin:和model.setGPU同样输入参数，当无输入参数时，用B.gpuStatus自动作为输入参数

            无

            B.setGPU();

        !!! api "<span id="obj_Box-setPlatenFixId()">setPlatenFixId()</span>"
            设置每个Platen边缘单元的自由度，使其只能在压力板法向方向上运动，防止试样不平时压力板从侧面滑落

            无

            无

            参考BoxLayer例子

        !!! api "<span id="obj_Box-setPlatenStress(varargin)">setPlatenStress(varargin)</span>"
            通过对platen设置体力来产生边界应力（负为压力，正为拉力），体力作用在正方向上的压力板，即右、后、上压力板，用d.show('mGZ')命令查看体力作用

            输入参数可为2-4个，具体见下方说明

            无

            见user_3DJointStress示例

        !!! api "<span id="obj_Box-setType()">setType()</span>"
            根据模型类型（B.type）设置platenStatus

            

            无

            示例的第一个文件

        !!! api "<span id="obj_Box-setUIoutput(varargin)">setUIoutput(varargin)</span>"
            设置消息的窗口显示，需在加载新文件后，运行这个命令

            varargin:无输入参数时，自动查找窗口中的消息框，当输入消息框句柄时，使用输入的消息框显示消息

            无

            B.setUIoutput()

        !!! api "<span id="obj_Box-以下为程序内部函数，通常不直接使用">以下为程序内部函数，通常不直接使用</span>"
            

            

            

            

        !!! api "<span id="obj_Box-addLoading()">addLoading()</span>"
            *

            

            

            

        !!! api "<span id="obj_Box-addMat(varargin)">addMat(varargin)</span>"
            

            

            

            

        !!! api "<span id="obj_Box-addSurf(para)">addSurf(para)</span>"
            增加层面，与Tool_cut中函数相同。未来可能取消

            层面的数字高程，为结构体S.X,S.Y,S.Z

            无

            

        !!! api "<span id="obj_Box-breakPlatenConnection()">breakPlatenConnection()</span>"
            未开发*

            

            

            

        !!! api "<span id="obj_Box-buildInitialModel()">buildInitialModel()</span>"
            

            

            

            

        !!! api "<span id="obj_Box-buildModel()">buildModel()</span>"
            开始建模*

            

            

            

        !!! api "<span id="obj_Box-clearBoundary()">clearBoundary()</span>"
            

            

            

            

        !!! api "<span id="obj_Box-clearPlaten()">clearPlaten()</span>"
            

            

            

            

        !!! api "<span id="obj_Box-createBall(distriRate)">createBall(distriRate)</span>"
            

            

            

            

        !!! api "<span id="obj_Box-createBoundary(varargin)">createBoundary(varargin)</span>"
            

            

            

            

        !!! api "<span id="obj_Box-createClump(randRate)">createClump(randRate)</span>"
            

            

            

            

        !!! api "<span id="obj_Box-createPlaten(varargin)">createPlaten(varargin)</span>"
            

            

            

            

        !!! api "<span id="obj_Box-createSample()">createSample()</span>"
            

            

            

            

        !!! api "<span id="obj_Box-delSurf(surfIds)">delSurf(surfIds)</span>"
            删除指定层面，与Tool_cut中函数相同。未来可能取消

            surfIds为指定的层面的编号矩阵

            无

            

        !!! api "<span id="obj_Box-dispNote(note)">dispNote(note)</span>"
            显示消息*

            

            

            

        !!! api "<span id="obj_Box-exportModel()">exportModel()</span>"
            导出模型*

            

            

            

        !!! api "<span id="obj_Box-finishModel()">finishModel()</span>"
            完成模型建立*

            

            

            

        !!! api "<span id="obj_Box-importModel(d)">importModel(d)</span>"
            导入模型*

            

            

            

        !!! api "<span id="obj_Box-setGroupPosition(gName)">setGroupPosition(gName)</span>"
            设置组的位置，在importModel中使用*

            

            

            

        !!! api "<span id="obj_Box-setSoftMat()">setSoftMat()</span>"
            设置较软的单元*

            

            

            

        !!! api "<span id="obj_Box-setTuTest()">setTuTest()</span>"
            设置抗拉强度试验*

            

            

            

        !!! api "<span id="obj_Box-setTuTestStress(stress)">setTuTestStress(stress)</span>"
            设置抗拉强度试验应力*

            

            

            

        !!! api "<span id="obj_Box-show()">show()</span>"
            显示模型

            

            

            

        !!! api "<span id="obj_Box-nan">nan</span>"
            

            

            

            

        !!! api "<span id="obj_Box-nan">nan</span>"
            

            

            

            

        !!! api "<span id="obj_Box-setPlatenStress(varargin)函数说明">setPlatenStress(varargin)函数说明</span>"
            

            

            

            

        !!! api "<span id="obj_Box-输入为两个时，为setPlatenStress(stressType,value)">输入为两个时，为setPlatenStress(stressType,value)</span>"
            根据应力设定值等，使用fs.platenStress2Gravity来确定platen上的体力，用于单轴压缩和弹性模量测试模拟 

            stressType:可取'StressXX','StressYY','StressZZ'. stressValue:为应力值，单位为Pa

            

            下图1

        !!! api "<span id="obj_Box-输入为三个时，为setPlatenStress(stressType,stressValue,border)">输入为三个时，为setPlatenStress(stressType,stressValue,border)</span>"
            根据应力设定值和范围，使用fs.setPlatenStress(d,stressType,stressValue,border);在压力板上施加体力(应力）

            stressType:可取'StressXX','StressYY','StressZZ'. stressValue:为应力值，单位为Pa. border:压力板的应力施加范围

            

            下图2

        !!! api "<span id="obj_Box-输入为四个时，为setPlatenStress(StressXX,StressYY,StressZZ,border)">输入为四个时，为setPlatenStress(StressXX,StressYY,StressZZ,border)</span>"
            根据应力设定值和范围，使用fs.setPlatenStress(d,stressType,stressValue,border);在压力板上施加体力(应力）

            StressXX,StressYY,StressZZ:X,Y,Z方向上的应力值 ；border:压力板的应力施加范围

            

            下图2

        !!! api "<span id="obj_Box-nan">nan</span>"
            

            

            

            

        !!! api "<span id="obj_Box-关于border：在做单轴压缩试验时，由于上压力板设为与试样等大，设定应力方向和大小即可。而对于真三轴试验，考虑到压力板通常要比试样尺寸大，体力不能作用在压力板上的每个单元。以topPlaten为例，通过使用fs.setPlatenStress命令，可查找样品单元中离platen一定距离内的单元，并以这些单元的XY范围来确定platen上需要施加应力的单元。在三轴试验中，当试样变形时，需要不断运行这个命令以正确施加应力。">关于border：在做单轴压缩试验时，由于上压力板设为与试样等大，设定应力方向和大小即可。而对于真三轴试验，考虑到压力板通常要比试样尺寸大，体力不能作用在压力板上的每个单元。以topPlaten为例，通过使用fs.setPlatenStress命令，可查找样品单元中离platen一定距离内的单元，并以这些单元的XY范围来确定platen上需要施加应力的单元。在三轴试验中，当试样变形时，需要不断运行这个命令以正确施加应力。</span>"
            

            

            

            

        !!! api "<span id="obj_Box-注意：在做三轴试验时，考虑试样在某一维度上可能发生膨胀（如施加拉力），为防止颗粒漏出，需要将压力板和边界设大一些，即设定B.BexpandRate和B.PexpandRate，参见user_3DJointStress1。图2为B.BexpandRate=B.sampleW*0.1/B.ballR;B.PexpandRate=B.sampleW*0.1/B.ballR;，将边界和板向外增加10%。为防止压力板“滑落”，对锁定压力板的四向边界单元，使其仅能在压力板法向上运动，图3红色为X方向自由度锁定">注意：在做三轴试验时，考虑试样在某一维度上可能发生膨胀（如施加拉力），为防止颗粒漏出，需要将压力板和边界设大一些，即设定B.BexpandRate和B.PexpandRate，参见user_3DJointStress1。图2为B.BexpandRate=B.sampleW*0.1/B.ballR;B.PexpandRate=B.sampleW*0.1/B.ballR;，将边界和板向外增加10%。为防止压力板“滑落”，对锁定压力板的四向边界单元，使其仅能在压力板法向上运动，图3红色为X方向自由度锁定</span>"
            

            

            

            

        !!! api "<span id="obj_Box-nan">nan</span>"
            

            

            

            

        !!! api "<span id="obj_Box-图1">图1</span>"
            图2

            图3

            

            

