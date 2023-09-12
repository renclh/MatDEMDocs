# 软件结构

## 目录结构

???+ note "目录结构"
    **系统文件夹不可删除**
    
    **data**
    : 系统文件夹, 用于存储模拟文件, 可定期清理其中文件

    **data/step**
    : 系统文件夹, 存储模拟中间文件, 可定期清理其中文件

    **app**
    : 自定义的app文件夹, 用于存储app的源文件, 可增加和删除自定义的app

    __examples****__
    : 自定义的示例文件夹, 用于放置MatDEM的示例, 可增加和删除示例

    **fun**
    : 自定义的函数文件夹, 存储函数和Matlab辅助文件, 可增加和删除自定义的函数

    **gif**
    : 系统文件夹, 存储动画, `fs.makeGif`生成的动画将保存于此

    **Mats**
    : 系统文件夹, 存储材料, 可删除或增加新的材料

    **Resources**
    : 系统文件夹（重要）, 存储系统文件, 不可修改，否则程序无法运行

    **slope**
    : 自定义的滑坡建模文件夹, 存储部分高程数据, 可增加和删除文件

    **TempModel**
    : 系统文件夹, 存储计算的中间文件, 可定期清理其中文件

    **XMLdata**
    : 系统文件夹（重要）, 记录程序基本设置, 不可修改，否则程序无法运行
    

## 程序结构与基础函数

=== "代码层次结构"

    | 层次 | 相关代码 |
    | ----- | ----- |
    | 用户二次开发（顶层） | 二次开发代码 |
    | MatDEM建模器 | obj_Box, obj_3Axial, material, Tool_Cut |
    | MatDEM求解和控制 | build, model, modelStatus |
    | MatDEM函数集 | mfs, fs, bfs等 |
    | matlab函数（底层） | 矩阵计算 |

=== "类与函数集及其功能"

    | 类与函数集 | 功能 |
    | ----- | ----- |
    | user_*** | 二次开发脚本 |
    | UI_*** | 用户界面脚本 |
    | obj_Box |	模型箱建模器 |
    | obj_3Axial |	试验室建模器（__将被废弃__）|
    | Tool_Cut	| 模型切割器 |
    | build	| 模拟和数据控制 |
    | model	| 求解器 |
    | modelStatus | 模拟过程记录 |
    | material | 材料 |
    | mfs | 建模函数 |
    | fs | 基本函数 |

### 系统基本函数

`MatDEMfile(FileName)`
: 运行`FileName`指定的脚本  
例: `#!matlab MatDEMfile('user_3AxialNew1.m');`

`f.run(FunctionName, parameter, …)`
: 定义函数并运行（Matlab标准函数）  
Function:函数名，parameter参数  
k1=f.run('examples/funtest.m',1,2,3)  
见示例user_Function2Object.m

f.define(FunStr)
: 重定义一个函数

fs.disp(note)
: 在下方提示框中显示note字符串内容  
a=1+1;fs.disp(['a is ' num2str(a)]);

`gpuDevice(gpuIndex)`
: 当有多个GPU时，选择所使用的GPU


### 自定义函数和辅助文件夹

MatDEM可运行标准的Matlab函数。通常可利用自定义函数来建模，在fun文件夹里提供了若干自定义函数示例，包括（1）建立各类的组件对象，如以下以make开头的函数，这些函数返回包含XYZR信息的结构体；（2）制作过滤器，用以过滤出特定的单元，并切割和定义模型。在fun文件夹中给出了几个自定义建模函数示例（如下方）。利用这些函数，可以自定义各类的基本组件对象，并通过切割和拼合构建复杂的几何模型。参见user_Function2Object.m，user_modelExample.m
fun文件夹中提供了Matlab辅助文件（*.p）。当在Matlab中进入此文件夹，并打开MatDEM保存的.mat，可直接在Matlab中查看和修改数据，并且可调用mfs中所有函数，请查看运行fun文件夹中的RunInMatlab.m。

自定义建模函数示例	Matlab数据结构显示文件	Matlab建模辅助函数
makeDisc.m	build.p	mfs.p（包括全部函数，可直接调用）
makeColumn.m	material.p	fs.p（少量用于mfs的显示函数）
makeHob.m	model.p	
makeRing.m	modelStatus.p	
getColumnFilter.m	Obj_3AxialTester.p	
applyRegionFilter.m	obj_Box.p	
imageRegionFilter.m	Tool_Cut.p	


???+ note "MatDEM专家版"
    MatDEM3.5及以后版本支持在Matlab里编辑和调试代码，以及制作MatDEM窗口软件。（1）安装专家模式。在软件根目录中右击"MatDEM.exe"，选择”以管理员模式运行“打开软件。进入”设置“，安装专家模式。（2）打开Matlab文件夹，进入软件要目录，输入"expert"命令，出现”MatDEM 专家模式已启用“，则可在Matlab里直接运行MatDEM的代码。注意：命令MatDEMfile在Matlab里不支持			
			

## 数据结构

### 单元类型和数据

在程序中的B，d和d.mo等中均会有aNum和mNum参数，其分别代表总单元数和模型活动单元数。在程序数据矩阵中，单元从1开始编号到aNum（矩阵的行方向），其中1到mNum为模型活动单元，mNum+1到aNum-1为模型固定单元（墙单元），aNum为虚单元。在对象参数中，如参数以a开头（如aX，aBF），则其长度为aNum，而部分参数只有活动单元才有，如mVX（速度），则以m开头。			
			
变量	说明	变量	说明
B->Box	obj_Box对象，二次开发的基础模型箱	aNum->number of all elements	所有的单元数
d->data center	build对象，数据处理和控制对象	mNum->number of model element	模型活动单元数
mo->model	模型对象，计算模块		
C->Cut	层面切割对象		
			
### 荷载和边界条件

基于牛顿力学，离散元法在计算机中构建一个物理世界。MatDEM可实现各类荷载和边界的施加。程序中拉力为正，压力为负。			
（1）位移边界：移动boundary来施加位移边界，命令为d.moveBoundary()，见build函数			
（2）应力边界：对platen施加体力（mGX,mGY,mGZ）来实现对样品的压力作用，需要第一步初始化时添加边界，B.type='TriaxialCompression'时包含所有压力板			
（3）振动边界：对boundary施加周期性位移，boundary作用力在platen上即转化为正弦式振动			
（4）荷载作用：各类荷载直接作用在单元上，即通过对d.mo中的参数进行赋值，如d.mo.mGZ(:)=0将重力设为零			


### 接触模型

接触模型在d.mo.FnCommand中定义，如线弹性模型则为：nFN0=obj.nKNe.*nIJXn;。默认为线弹性模型			
线弹性胶结接触：见以下图1 ，以及论文1			
Hertz接触：单元之间接触按球接触力计算，正向力采用Hertz接触，			
屈服破坏接触：单元可被压碎（屈服破坏），通过椭圆的屈服包络面（yeilding cap）来定义这类破坏。d.mo.isFailure=1时启用，目前无示例。见以下图2，以及论文2			
"自定义接触模型：离散元接触模型和宏微观分析是离散元研究和应用非常重要的基础，其能从本质上探求岩土材料复杂宏观特性的微细观机理。基于工程尺度数值模拟的考虑，MatDEM一直采用线弹性的粘结模型，并提供Hertz接触模型用于软件与玻璃珠试验对比测试。过去一年，MatDEM团队收到国内外大量自定义接触模型的需求。经过一段时间的设计和研发，MatDEM1.65版提供了自定义接触模型支持。 
在BoxCrash1示例中，以下命令将normalContact.m函数设定为迭代计算函数，并进行接触力和单元运动计算（约150行）。
d.mo.setBalanceFunction('fun/normalContact.m');
具体请见Box_Crash1示例。MatDEM团队将研发和共享更多的接触模型，同时也欢迎各领域专家学者共同研发。"			
