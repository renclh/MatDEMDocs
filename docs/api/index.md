# API

## 初始建模类

- [`obj_Box`: 初始建模的长方形/体模拟箱，基于所有二次开发均基于此初始建模](obj_Box.md)
- [`Tool_Cut`: 存储层面信息，用于切割模型和/或设置节理和裂隙](Tool_Cut.md)  

## 常用基础类

- [`build`: 模型交互的主要入口。用于修改模型，数据中转，控制迭代过程和显示结果](build.md)
- [`model`: 离散元求解器，包含邻域查找、迭代平衡和GPU设置等](model.md)
- [`childModel`: 子模型求解器，用于宽级配模型分组求解](childModel.md)
- [`modelStatus`: 记录模拟过程中的各类数据，如边界受力、能量转化等](modelStatus.md)
- [`material`: 记录单元材料信息，包括材料宏观力学参数和单元微观力学参数](material.md)
- [`pore`: 二维孔隙密度流求解器，MatDEM流体计算模块](pore.md)  

## 常用函数集

- [`mfs`: 常用几何建模函数集，几何体的创建、组合与切割、移动与对齐等](mfs.md)
- [`fs`: 供调用的内部函数集，包括基本的矩阵变换、参数计算和基本绘图函数等](fs.md)
- [`f`: 用于高级二次开发，设置全局变量、运行自定义函数和自定义APP等](f.md)  

## 杂项

- [`Miscellaneous`: 使用较少的类与函数集，包括`ContactModel, ufs, bfs`等](planetfs.md)

ContactModel
: 接触模型函数集

    离散元接触模型和宏微观分析是离散元研究和应用非常重要的基础，其能从本质上探求岩土材料复杂宏观特性的微细观机理。基于工程尺度数值模拟的考虑，MatDEM一直采用线弹性的粘结模型，并提供Hertz接触模型用于软件与玻璃珠试验对比测试。过去一年，MatDEM团队收到国内外大量自定义接触模型的需求。经过一段时间的设计和研发，MatDEM1.65版提供了自定义接触模型支持。   
    以下命令将normalContact.m函数设定为迭代计算函数，并进行接触力和单元运动计算（约150行）。  
    `d.mo.setBalanceFunction('fun/normalContact.m');`  
    具体请见Box_Crash1示例。

ufs
: 用户界面函数集，包括界面显示，XML处理，提示信息

bfs
: 基本单元生成函数集，生成基本的clump单元，有待加入新的基本单元

pfs
: 孔隙模拟函数集，用于支持pore类

poreStatus
: 孔隙状态类，记录`pore`类的中间过程，二者类似`modelStatus`与`model`的关系

WinAPP类
: 封装窗口应用类  

    `f.runWinApp(path, isMenubar)` 生成自定义窗口APP

    Parameters
    : `path`: app文件路径  
    `isMenubar`: True | False, 是否生成默认菜单栏


## 常用api

`d.balance`
: 
    Syntax
    : 
    - `d.balance()`
    平衡迭代1次
    - `d.balance(balanceNum)`
    平衡迭代balanceNum次
    - `d.balance(balanceNum, balanceTime)`
    平衡迭代balanceNum*balanceTime次，每balanceNum记录一次状态
    - `d.balance('Standard')`
    进行一次的标准平衡迭代，即d.balance(balanceNum,balanceTime);  
    balanceNum记录于d.SET.StandardBalanceNum，默认为50，时间步大概为周期的1/50，50次迭代完成单元一个振动周期。balanceTime=d.SET.packNum，即模型在最长维度上的堆积单元数。使用d.balance('Standard')，可保证当单元的直径变化时，模拟对应的总时间不变，具体见教程。
    - `d.balance('Standard', 0.5)`
    进行0.5次标准平衡迭代
    -  `d.balance('Standard', 0.5, 'off')`
    进行0.5次标准平衡迭代，但不显示迭代过程提示

`d.GROUP`
: 
d.GROUP中记录模型中所有的组信息，主要包括三类： 

1. 边界组，即模型默认产生的六个边界，lefB, rigB, froB, bacB, botB, topB；
2. 普通组，包括系统自动建立的六个压力板，lefPlaten等，以及sample组，其包括压力板和边界范围内的所有活动单元 ，以及用户通过d.addGroup命令自定义的组；
3. 以group开头的组信息，包括groupId：记录组的编号；groupProtect，被保护而不能被删除组和组内单元的组名；groupMat，记录组所要施加的材料。

!!! note
    自定义组名不能以'group'开头。

`d.data`
: 
当程序中运行`d.show('Heat')`等命令时，会在data里查找相应名字的数组，如存在Heat数组，则显示出来。  
可自行添加新的数组，如`d.data.diameter=d.mo.aR*2;d.show('diameter');`则会显示单元的直径图

`B.setPlatenStress`
: 
    Syntax
    : 
    - setPlatenStress(stressType, value)
    - setPlatenStress(stressType, value, border)
    - setPlatenStress(StressXX, StressYY, StressZZ, border)

    Parameters
    : 
    stressType: 'StressXX' | 'StressYY' | 'StressZZ'  
    border: 
    基于border查找离platen一定距离的试样单元，以该部分单元确定加载范围

    !!! note
        在做三轴试验时，考虑试样在某一维度上可能发生膨胀（如施加拉力），为防止颗粒漏出，需要将压力板和边界设大一些，即设定B.BexpandRate和B.PexpandRate，参见user_3DJointStress1。
        图2为B.BexpandRate=B.sampleW*0.1/B.ballR;B.PexpandRate=B.sampleW*0.1/B.ballR;，将边界和板向外增加10%。为防止压力板“滑落”，对锁定压力板的四向边界单元，使其仅能在压力板法向上运动，图3红色为X方向自由度锁定

`d.mo.setGPU`
: 
`'on'  | 'off' | 'auto' | 'fixed' | 'unfixed'`

`p.show`

`p.balance`

`p.solutePara`
: 
    Fields
    : 
    - Id: 1
    - name: 'T'
    - initialValue: 20
    - p.SET.(['p', name])
    - p.SET.(['cK', name])