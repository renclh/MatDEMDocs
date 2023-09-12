# mfs

!!! api "class <span id="mfs-mfs">mfs</span>"
    ???+ api "<span id="mfs-props">Properties</span>"
    ???+ api "<span id="mfs-methods">Methods</span>"
        !!! api "<span id="mfs-transferPara(d1,d2,gNames,paras)">transferPara(d1,d2,gNames,paras)</span>"
            将指定组的属性由d1转到d2

            d1,d2为build对象；gNames组名元胞矩阵；paras：参数元胞矩阵

            无

            见user_ClumpParticle2：mfs.transferPara(d,B.d,{'botPlaten','topPlaten','lefPlaten','rigPlaten'},{'aX','aZ'});

        !!! api "<span id="mfs-[gId1,gId2]=splitGroup(d,gName,type,value)">[gId1,gId2]=splitGroup(d,gName,type,value)</span>"
            将组将属性大小分成两部分，并返回两部分的id

            d对象；gName组名；type:d.mo中的属性字符串；value切分的值，大等于此值的返回到gId1中

            gId返回的两部id

            

        !!! api "<span id="mfs-allDisc=grain2Clump2D(grainObj,expandRate,Rrate)">allDisc=grain2Clump2D(grainObj,expandRate,Rrate)</span>"
            将大颗粒转化为clump

            grainObj颗粒的结构体，expandRate：令minR为最小颗粒半径，当半径大于minR*expandRate且小于minR*expandRate^3/2时，转为七单元clump，当半径大于minR*expandRate^3/2时，采用discObj=mfs.denseModel0(Rrate,@mfs.makeDiscV,grainR,ballR1);生成圆盘clump

            所有颗粒单元的结构体，包含groupId，以便进一步导入生成clump

            见user_ClumpParticle2

        !!! api "<span id="mfs-porosity=getPorosity(B,zLimit)">porosity=getPorosity(B,zLimit)</span>"
            计算z方向小于zLimit的孔隙率（利用get2DPorosity或get3DPorosity

            B对象，zLimit：Z方向的上限

            

            

        !!! api "<span id="mfs-porosity=get3DPorosity(d,x1,x2,y1,y2,z1,z2)">porosity=get3DPorosity(d,x1,x2,y1,y2,z1,z2)</span>"
            计算三维sample一定区域内的孔隙率

            d对象；x1,x2,y1,y2,z1,z2计算孔隙率的区域

            

            

        !!! api "<span id="mfs-porosity=get2DPorosity(d,x1,x2,z1,z2)">porosity=get2DPorosity(d,x1,x2,z1,z2)</span>"
            计算二维sample一定区域内的孔隙率，当d.SET.ballArea存在时，使用其计算颗粒面积，反之，则用sample

            d对象；x1,x2,z1,z2计算孔隙率的区域

            

            

        !!! api "<span id="mfs-porosity=getBoxPorosity(B,topRate)">porosity=getBoxPorosity(B,topRate)</span>"
            获得模型箱下方一定比例区域的孔隙率

            B对象；topRate比例，为1时，则计算整个模拟箱

            

            

        !!! api "<span id="mfs-[data,B]=testSpeed(num,balanceCommand,isSingle)">[data,B]=testSpeed(num,balanceCommand,isSingle)</span>"
            用于测试程序的速度

            num:模型在三个方向上的单元个数；balanceCommand平衡命令；isSingle是否单精度

            data测试结果，B对象

            见user_BoxTestSpeed

        !!! api "<span id="mfs-porosity=get2DPorosity(d,x1,x2,z1,z2)">porosity=get2DPorosity(d,x1,x2,z1,z2)</span>"
            计算二维模型的孔隙率

            d对象；其它为坐标

            孔隙率

            

        !!! api "<span id="mfs-porosity=get3DPorosity(d,x1,x2,y1,y2,z1,z2)">porosity=get3DPorosity(d,x1,x2,y1,y2,z1,z2)</span>"
            计算三维模型的孔隙率

            d对象；其它为坐标

            孔隙率

            

        !!! api "<span id="mfs-porosity=getPorosity(B,zLimit)">porosity=getPorosity(B,zLimit)</span>"
            计算Box孔隙率（从底部0到zLimit间）

            B对象; zLimit:计算Box孔隙率的高度

            孔隙率

            BoxCompaction

        !!! api "<span id="mfs-frame=getObjFrame(obj)">frame=getObjFrame(obj)</span>"
            获取结构体在六个方向的边界，以及宽长高

            模型结构体，包括信息：X, Y, Z, R

            结构体frame,包括信息：left, right, front back, bottom, top, width, length, height

            

        !!! api "<span id="mfs-sFilter=applyRegionFilter(regionFilter,sX,sY)">sFilter=applyRegionFilter(regionFilter,sX,sY)</span>"
            应用mfs.image2RegionFilter生成的矩阵来过滤单元，得到单元过滤矩阵

            regionFilter:布尔矩阵; sX, sY:单元x, y坐标

            单元过滤器

            见user_Box3DSlope2

        !!! api "<span id="mfs-regionFilter=image2RegionFilter(fileName,imH,imW)">regionFilter=image2RegionFilter(fileName,imH,imW)</span>"
            根据图片生成imH*imW的布尔矩阵，图中白色为true

            fileName: 图片文件名字符串（包含路径）; imH, imW: 生成的矩阵的高和宽

            区块布尔矩阵

            见user_Box3DSlope3

        !!! api "<span id="mfs-bondFilter=setBondByPolygon(d,PX,PY,PZ,type)">bondFilter=setBondByPolygon(d,PX,PY,PZ,type)</span>"
            利用多顶点定义的多边形面来切割或胶结模型

            d:build对象;pX,pY,pZ,空间多边形的顶点坐标，如[1;2;3],[4;5;6],[7;8;8]；type:可为'break'(断开连接），'glue'（胶结连接），'no'不改变d中的连接状态，仅返回bondFilter

            对应于nBall的连接矩阵，值为1代表三角面有通过连接

            见user_Box3DJointStress

        !!! api "<span id="mfs-bondFilter=setBondByTriangle(d,pX,pY,pZ,type)">bondFilter=setBondByTriangle(d,pX,pY,pZ,type)</span>"
            用三个顶点定义的三角面来切割或胶结模型

            d:build对象;pX,pY,pZ,空间三角面三个顶点坐标，如[1;2;3;4],[4;5;6;7],[7;8;9;10]；type:可为'break'(断开连接），'glue'（胶结连接），'no'不改变d中的连接状态，仅返回bondFilter

            对应于nBall的连接矩阵，值为2代表三角面有通过连接

            见user_Box3DJointStress，type为'glue'时需再运行d.mo.zeroBalance();

        !!! api "<span id="mfs-[obj1,obj2]=divideObj(obj,pX,pY,pZ)">[obj1,obj2]=divideObj(obj,pX,pY,pZ)</span>"
            用三个顶点定义的三角面来切分结构体，生成两个结构体

            obj:初始结构体模型;pX,pY,pZ:三角形坐标数组（列方向数组）

            切割出的两个新结构体

            

        !!! api "<span id="mfs-ObjOut=rotateCopy(obj,dAngle,num,varargin)">ObjOut=rotateCopy(obj,dAngle,num,varargin)</span>"
            结构体以原点为中心在XY平面上旋转复制

            obj:初始结构体模型;dAngle:旋转角度;num:次数;varargin:0或1 个输入参数，字符串，可取'XY','YZ','XZ'，无输入参数时在'XY'平面旋转

            包括X,Y,Z,R信息的结构体

            见user_BoxShear

        !!! api "<span id="mfs-ringObj=makeRing2(innerR,outerR,ballR0,Rrate)">ringObj=makeRing2(innerR,outerR,ballR0,Rrate)</span>"
            用等大的单元制作环形

            innerR:环内径;outerR:环外径;ballR:单元半径;Rrate:单元间距和直径比

            包括X,Y,Z,R信息的结构体

            见user_BoxShear

        !!! api "<span id="mfs-edge=getObjEdge(type,obj1)">edge=getObjEdge(type,obj1)</span>"
            获取结构体模型在某一方向的边界

            type:字符串，可取‘left’,‘right‘,’front‘,’back‘,’bottom‘,’top‘;obj1:结构体

            边界的坐标值

            见user_BoxShear

        !!! api "<span id="mfs-obj1=align2Value(type,obj1,value)">obj1=align2Value(type,obj1,value)</span>"
            将结构体模型的对齐到某一位置

            type:字符串，可取‘left’,‘right‘,’front‘,’back‘,’bottom‘,’top‘;obj1:结构体;value:坐标值

            包括X,Y,Z,R信息的结构体

            见user_BoxShear

        !!! api "<span id="mfs-varargout=alignObj(type,varargin)">varargout=alignObj(type,varargin)</span>"
            将多个结构体模型沿某一侧对齐

            type:字符串，可取‘left’,‘right‘,’front‘,’back‘,’bottom‘,’top‘;varargin:多个结构体

            按顺序返回多个结构体

            [obj1,obj2]=mfs.alignObj('left',obj1,obj2);

        !!! api "<span id="mfs-ringObj=makeRing(innerR,layerNum,minBallR,Rrate)">ringObj=makeRing(innerR,layerNum,minBallR,Rrate)</span>"
            生成一个二维的环，用于做隧道

            innerR:环内径;layerNum:环径向单元个数;minBallR:最小单元半径;Rrate:单元间距和直径比

            包括X,Y,Z,R信息的结构体

            user_TunnelNew

        !!! api "<span id="mfs-mixGroupElement(d,gName,randPositionSeed)">mixGroupElement(d,gName,randPositionSeed)</span>"
            将指定组的单元随机互换位置，从而得到新的堆积

            d:build对象;gName:组名字符串;randPosition:随机种子数字

            无

            user_BoxUniaxialTest

        !!! api "<span id="mfs-note=balanceForce(d, Amax, num)">note=balanceForce(d, Amax, num)</span>"
            平衡模型直至最大加速度小于Amax，或平衡达到num次循环

            d:build对象;Amax:最大加速度;num:平衡循环次数，平衡次数为100*num

            关于平衡计算的信息字符串

            

        !!! api "<span id="mfs-obj1=combineObj(varargin)">obj1=combineObj(varargin)</span>"
            将多个结构体合并一个

            varargin:用于合并的多个结构体

            合并得到的结构体

            

        !!! api "<span id="mfs-obj=cutBoxObj(sampleObj, width, length, height)">obj=cutBoxObj(sampleObj, width, length, height)</span>"
            从样品对象中切取特定长宽高的块体，原点为中心

            sampleObj:样品结构体; width,length,height:切取的长宽高

            包括X,Y,Z,R信息的结构体

            

        !!! api "<span id="mfs-obj=cutSphereObj(sampleObj, radius)">obj=cutSphereObj(sampleObj, radius)</span>"
            从样品对象中切取特定半径的球，原点为中心

            sampleObj:样品结构体; radius:切取的球半径

            包括X,Y,Z,R信息的结构体

            

        !!! api "<span id="mfs-obj=denseModel(Rrate, F, varargin)">obj=denseModel(Rrate, F, varargin)</span>"
            将结构体对象加密重叠

            Rrate:单元间距和直径比，生成结构体的函数F，F的输入参数

            包括X,Y,Z,R信息的结构体

            user_BoxSlope2

        !!! api "<span id="mfs-obj=expandAlong(obj, dir, dDis, num)">obj=expandAlong(obj, dir, dDis, num)</span>"
            沿正负方向复制扩展结构体中单元，基于expandAlongMax

            obj:结构体; dir:方向: dDis:间距; num:次数

            扩展得到的结构体

            

        !!! api "<span id="mfs-obj=expandAlongMax(obj, dir, dDis, num)">obj=expandAlongMax(obj, dir, dDis, num)</span>"
            沿正值方向复制扩展结构体中单元

            obj:结构体; dir:方向: dDis:间距; num:次数

            扩展得到的结构体

            

        !!! api "<span id="mfs-obj=filterObj(obj, f)">obj=filterObj(obj, f)</span>"
            利用过滤器选择结构体中单元生成新的结构体

            obj:单元结构体; f:过滤器布尔矩阵（值为1则选中）

            过滤后的结构体

            

        !!! api "<span id="mfs-stressSteps=getBoxUniaxialStressSteps(B)">stressSteps=getBoxUniaxialStressSteps(B)</span>"
            根据B中的材料属性计算力学测试的应力步

            B:Box对象

            包括弹性、抗拉和抗压试验应力步的结构体

            user_BoxMatTraining

        !!! api "<span id="mfs-filter=getColumnFilter(X, Y, Z, dipD, dipA, radius, height)">filter=getColumnFilter(X, Y, Z, dipD, dipA, radius, height)</span>"
            切出柱形的单元过滤器

            X,Y,Z:坐标; dipD:倾向; dipA:倾角; radius:圆柱半径; height:圆柱高度

            过滤器布尔矩阵

            

        !!! api "<span id="mfs-objCenter=getObjCenter(obj)">objCenter=getObjCenter(obj)</span>"
            获取对象的中心

            obj:模型结构体，包括信息：X, Y, Z, R

            包括中心x,y,z信息的结构体

            

        !!! api "<span id="mfs-weakFilter=getWeakLayerFilter(X, Y, Z, dipD, dipA, strongT, weakT)">weakFilter=getWeakLayerFilter(X, Y, Z, dipD, dipA, strongT, weakT)</span>"
            建立强弱互层单元过滤器

            X,Y,Z:单元坐标; dipD:倾向; dipA:倾角; strongT:强层厚; weakT:弱层厚

            弱层的过滤器矩阵

            

        !!! api "<span id="mfs-SET=getBoxSample(grainR,sampleW,sampleL,hRate)">SET=getBoxSample(grainR,sampleW,sampleL,hRate)</span>"
            根据半径数组得到Box模型所需的参数

            grainR:半径数组；sampleW,sampleL模型宽和长，hRate高度比率（比1略大），hRate为1时，则返回的模型参数中sampleH为这些颗粒刚好需要的容器高度，当这个值增大时，则容器高度正比增加

            Box模型设置结构体

            user_HighSizeRatio.m

        !!! api "<span id="mfs-randD=getGradationDiameter(G,varargin)">randD=getGradationDiameter(G,varargin)</span>"
            根据粒径级配得到单元粒径数组

            G:级配数据；varargin:一个参数时为体积，两个参数时，第一个参数为体积，第二个参数为级配曲线的类型，其决定在一个粒径范围内颗粒曲线的变化，通常在-1到3之间，其较小时级配曲线下凸，较大时上凸。取-1时（默认），则每个粒径对应的颗粒数一致，细单元较少；取3时，则每个粒径对应的颗粒总体积一致，细单元较多。

            粒径数组

            user_HighSizeRatio.m

        !!! api "<span id="mfs-obj=intervalObj(objOne, dx, dy, dz, num)">obj=intervalObj(objOne, dx, dy, dz, num)</span>"
            沿dx,dy,dz的间隔重复生成num个的objOne

            objOne:单个结构体; dx,dy,dz间隔; num:生成个数

            包括X,Y,Z,R信息的结构体

            

        !!! api "<span id="mfs-obj=make3DalongPath(obj2D,X,Y,Z,dDis,dAngle)">obj=make3DalongPath(obj2D,X,Y,Z,dDis,dAngle)</span>"
            将二维物体沿着路径XYZ伸成三维（路径要精细）

            obj2D:二维物体结构体；X,Y,Z：路径的坐标；dDis：复制移动距离；dAngle：复制旋转角度

            包括X,Y,Z,R信息的结构体

            见示例user_Cable，源代码见fun/make3DalongPath.m

        !!! api "<span id="mfs-obj3D=make3Dfrom2D(obj2D, height, ballR)">obj3D=make3Dfrom2D(obj2D, height, ballR)</span>"
            将二维的物体拉伸成三维，如将circle拉成tube

            obj2D:二维物体结构体；height:拉成三维体的高；ballR:单元半径

            包括X,Y,Z,R信息的结构体

            

        !!! api "<span id="mfs-obj=makeBox(boxW, boxL, boxH, ballR)">obj=makeBox(boxW, boxL, boxH, ballR)</span>"
            做一个块体结构体

            宽，长，高，单元半径

            包括X,Y,Z,R信息的结构体

            user_BoxSlope3

        !!! api "<span id="mfs-obj=makeCircle(circleR, ballR)">obj=makeCircle(circleR, ballR)</span>"
            做圆圈的结构体

            circleR:圆的半径；ballR:单元半径

            包括X,Y,Z,R信息的结构体

            

        !!! api "<span id="mfs-obj=makeColumn(columnR, columnHeight, ballR)">obj=makeColumn(columnR, columnHeight, ballR)</span>"
            做一个柱体结构体

            columnR:圆柱半径; columnHeight:圆柱高度; ballR:单元半径

            包括X,Y,Z,R信息的结构体

            

        !!! api "<span id="mfs-obj=makeDisc(discR, ballR)">obj=makeDisc(discR, ballR)</span>"
            做一个二维圆结构体

            discR:圆盘的半径；ballR:单元半径

            包括X,Y,Z,R信息的结构体

            

        !!! api "<span id="mfs-obj=makeHob(hobR, hobT, cutRate, ballR, Rrate)">obj=makeHob(hobR, hobT, cutRate, ballR, Rrate)</span>"
            生成一个滚刀结构体

            hobR:滚刀半径; hobT:厚度; cutRate:刀口倾斜度（越大越尖）; ballR:单元半径; Rrate:单元间距和直径比

            包括X,Y,Z,R信息的结构体

            hob=mfs.makeHob(hobR,hobT,cutRate,ballR,Rrate);

        !!! api "<span id="mfs-obj=makeLine(dir, length, ballR)">obj=makeLine(dir, length, ballR)</span>"
            沿X,Y,Z某一方向生成一条线

            dir:方向，可取字符串'X','Y','Z'; length:长度; ballR:单元半径

            包括X,Y,Z,R信息的结构体

            mfs.makeLine('X',1,0.05);

        !!! api "<span id="mfs-obj=makeLShape(width, height, ballR)">obj=makeLShape(width, height, ballR)</span>"
            生成一个L形的条（用于做网）

            width:宽; length: 长; ballR:单元半径

            包括X,Y,Z,R信息的结构体

            

        !!! api "<span id="mfs-obj=makeNet(width, height, cellW, cellH, ballR)">obj=makeNet(width, height, cellW, cellH, ballR)</span>"
            根据网的长宽，网眼的长宽和单元半径生成网

            width:宽; height: 高; cellW:网眼宽; cellH:网眼高; ballR:单元半径

            包括X,Y,Z,R信息的结构体

            a=mfs.makeNet(100,100,10,10,1);fs.showObj(a);

        !!! api "<span id="mfs-obj=makeRect(width, length, ballR)">obj=makeRect(width, length, ballR)</span>"
            做一个平面长方形结构体

            width:宽; length: 长; ballR: 单元半径

            包括X,Y,Z,R信息的结构体

            

        !!! api "<span id="mfs-obj=makeTube(tubeR, tubeHeight, ballR)">obj=makeTube(tubeR, tubeHeight, ballR)</span>"
            做管子结构体，四边形堆积

            tubeR:管子半径; tubeHeight:长; ballR:单元半径

            包括X,Y,Z,R信息的结构体

            

        !!! api "<span id="mfs-obj=makeTube2(tubeR,tubeHeight,ballR)">obj=makeTube2(tubeR,tubeHeight,ballR)</span>"
            做管子结构体，六边形堆积

            tubeR:管子半径; tubeHeight:长; ballR:单元半径

            包括X,Y,Z,R信息的结构体

            

        !!! api "<span id="mfs-Cu=makeUniaxialCuTest(B, stressSteps)">Cu=makeUniaxialCuTest(B, stressSteps)</span>"
            根据stressSteps进行B的单轴压缩试验

            B: Obj_Box对象; stressSteps:应力步

            单轴抗压强度Cu信息

            user_BoxMatTraining

        !!! api "<span id="mfs-Ev=makeUniaxialEvTest(B, stressSteps)">Ev=makeUniaxialEvTest(B, stressSteps)</span>"
            根据stressSteps进行B的弹性模量试验

            B:f；stressSteps:单元半径

            弹性模量Ev信息

            user_BoxMatTraining

        !!! api "<span id="mfs-B=makeUniaxialTest(B, varargin)">B=makeUniaxialTest(B, varargin)</span>"
            自动进行单轴力学测试，压缩，抗伸和Ev测试，计算密度，user_BoxMatTraining

            B:Obj_Box对象; varargin:0或1个输入参数，为1时可取'Cu','Tu','Ev',并进行相关测试，为0时进行以上三种测试，参考user_BoxMatTraining

            Obj_Box对象

            user_BoxMatTraining

        !!! api "<span id="mfs-B=makeUniaxialTestModel0(width, length, height, ballR, distriRate, randSeed)">B=makeUniaxialTestModel0(width, length, height, ballR, distriRate, randSeed)</span>"
            单轴测试初始建模

            width,length,height:模型宽长高;ballR:半径;distriRate:单元半径分散系数;randSeed:随机种子

            Obj_Box对象

            user_BoxMatTraining

        !!! api "<span id="mfs-B=makeUniaxialTestModel1(B)">B=makeUniaxialTestModel1(B)</span>"
            对makeUniaxialTestModel0生成的模型进行重力堆积

            B:Obj_Box对象

            Obj_Box对象

            user_BoxMatTraining

        !!! api "<span id="mfs-B=makeUniaxialTestModel2(B,matFile,varargin)">B=makeUniaxialTestModel2(B,matFile,varargin)</span>"
            对makeUniaxialTestModel1生成的模型进行赋材料

            B:Obj_Box对象; matFile: 模型材料（可为文件名或material对象）;varargin:可输入材料的rate参数，来定义material宏观参数系数（见material.rate)

            Obj_Box对象

            user_BoxMatTraining

        !!! api "<span id="mfs-B=makeUniaxialTuTest(B, stressSteps)">B=makeUniaxialTuTest(B, stressSteps)</span>"
            根据stressSteps进行B的单轴拉伸试验

            B: Obj_Box对象; stressSteps:应力步

            Obj_Box对象

            user_BoxMatTraining

        !!! api "<span id="mfs-obj=move(obj, varargin)">obj=move(obj, varargin)</span>"
            移动结构体

            obj:结构体;varargin:1个输入参数时为坐标数组P[x,y,z]，3个参数为x,y,z坐标

            包括X,Y,Z,R信息的结构体

            user_BoxShear

        !!! api "<span id="mfs-obj=moveObj2Origin(obj)">obj=moveObj2Origin(obj)</span>"
            将对象的中心移到原点

            obj:样品结构体，包括X,Y,Z,R信息

            包括X,Y,Z,R信息的结构体

            mfs.moveObj2Origin(a);

        !!! api "<span id="mfs-d=Obj2Build(obj, varargin)">d=Obj2Build(obj, varargin)</span>"
            将一个Obj结构体转化为build对象

            obj:样品结构体; varargin:可选参数，定义build中的mNum

            build对象

            

        !!! api "<span id="mfs-reduceGravity(d, index)">reduceGravity(d, index)</span>"
            逐步减少模型中的单元重力，每次除以10，再平衡200次，最后标准平衡一次

            d: build对象; index:除以10的次数

            无

            见示例第一步

        !!! api "<span id="mfs-obj=rotate(obj, type, angle)">obj=rotate(obj, type, angle)</span>"
            将结构体沿特定方向转到一定角度

            结构体，方向（'XY','YZ','XZ'），角度

            包括X,Y,Z,R信息的结构体

            在二维模型中，旋转后再运行d.mo.aY(:)=0，防止浮点误差出错

        !!! api "<span id="mfs-show(obj)">show(obj)</span>"
            显示结构体，结构体中包含X,Y,Z,R,gId信息，根据gId显示颜色

            obj:结构体

            无

            

        !!! api "<span id="mfs-sorting(D, divNum)">sorting(D, divNum)</span>"
            获得单元直径分布，并画图

            D:单元直径数组; divNum:分割数

            包含分选系数等的结构体

            

        !!! api "<span id="mfs-obj=createSurfaceNet(x,y,z,ballR,Rrate,varargin)">obj=createSurfaceNet(x,y,z,ballR,Rrate,varargin)</span>"
            %x,y,z: DEM scattered data.
            %ballR: the uniform radius of elements.
            %Rrate: the ratio of the distance between two elements to their diameter.
            %varargin: 1 parameter, the uniform width of the margins to be clipped;
            %          2 parameters, the widths of the margins to be clipped, left and right, top and bottom, respectively;
            %          4 parameters, the widths of the margins to be clipped, left, right, top, bottom, respectively.

            

            

            user_createSurfaceNet

        !!! api "<span id="mfs-0以下为程序内部函数，通常不直接使用">0以下为程序内部函数，通常不直接使用</span>"
            

            

            

            

        !!! api "<span id="mfs-boxCut(obj, box)">boxCut(obj, box)</span>"
            *

            

            

            

        !!! api "<span id="mfs-calculateParaRate(matFile, para1)">calculateParaRate(matFile, para1)</span>"
            计算输入和实测力学参数的比值，用在UnaxialTest中*

            

            

            

        !!! api "<span id="mfs-changeRadiusDistribution(d, randSeed)">changeRadiusDistribution(d, randSeed)</span>"
            暂时不可用

            

            

            

        !!! api "<span id="mfs-clearObj(obj)">clearObj(obj)</span>"
            清理结构体，将所有参数设为空［］

            

            

            

        !!! api "<span id="mfs-connectFilter=groupConnectFilter(nBall,G1_gId,G2_gId)">connectFilter=groupConnectFilter(nBall,G1_gId,G2_gId)</span>"
            %get the connection filter bewteen two group

            

            

            

        !!! api "<span id="mfs-connectFilter=groupOuterConnectFilter(nBall,G1_gId)">connectFilter=groupOuterConnectFilter(nBall,G1_gId)</span>"
            

            

            

            

        !!! api "<span id="mfs-convertDir(dirIn)">convertDir(dirIn)</span>"
            *

            

            

            

        !!! api "<span id="mfs-crossProduct(AX, AY, AZ, BX, BY, BZ)">crossProduct(AX, AY, AZ, BX, BY, BZ)</span>"
            叉乘运算

            

            

            

        !!! api "<span id="mfs-data2D(XYZ, Y0, R0)">data2D(XYZ, Y0, R0)</span>"
            *

            

            

            

        !!! api "<span id="mfs-defineBoundary(varargin)">defineBoundary(varargin)</span>"
            *to be deleted in future

            

            

            

        !!! api "<span id="mfs-getBoxBoundary(type, boundaryRrate, BexpandRate, w, l, h, ballR)">getBoxBoundary(type, boundaryRrate, BexpandRate, w, l, h, ballR)</span>"
            *

            

            

            

        !!! api "<span id="mfs-getBoxFrame(X, Y, Z, R)">getBoxFrame(X, Y, Z, R)</span>"
            *

            

            

            

        !!! api "<span id="mfs-getJointCutFilter(x1, z1, x2, z2, nXI, nZI, nXJ, nZJ, nBall)">getJointCutFilter(x1, z1, x2, z2, nXI, nZI, nXJ, nZJ, nBall)</span>"
            %using cross product to determine the vector side*

            

            

            

        !!! api "<span id="mfs-group2MatId(aMatId, gId, gIdList, mIdList)">group2MatId(aMatId, gId, gIdList, mIdList)</span>"
            *

            

            

            

        !!! api "<span id="mfs-isExist(cellObj, name)">isExist(cellObj, name)</span>"
            *

            

            

            

        !!! api "<span id="mfs-moveMeshGrid(S, moveDis)">moveMeshGrid(S, moveDis)</span>"
            将meshgrid沿着Z方向移动一定距离

            包含mesh的XYZ信息

            

            见3DSlope示例

        !!! api "<span id="mfs-obj=rotate2Path(obj, P1, P2)">obj=rotate2Path(obj, P1, P2)</span>"
            沿着路径旋转*

            

            包括X,Y,Z,R信息的结构体

            

        !!! api "<span id="mfs-rotateIJ(I, J, angle)">rotateIJ(I, J, angle)</span>"
            *

            

            

            

        !!! api "<span id="mfs-setBlockClump(X, Y, Z, limit)">setBlockClump(X, Y, Z, limit)</span>"
            *

            

            

            

        !!! api "<span id="mfs-shrink(X0, Y0, Z0, rate)">shrink(X0, Y0, Z0, rate)</span>"
            将坐标向物体中心收缩

            

            

            

        !!! api "<span id="mfs-XYZ2Plunge(P)">XYZ2Plunge(P)</span>"
            *

            

            

            

        !!! api "<span id="mfs-[connectFilter1,connectFilter2]=groupConnectFilter0(nBall,G1_gId,G2_gId)">[connectFilter1,connectFilter2]=groupConnectFilter0(nBall,G1_gId,G2_gId)</span>"
            获得G1_gId和G2_gId单元间的邻居过滤器

            

            %connectFilter1: connection filter in first group rows，  %connectFilter2: connection filter in second group rows

            

        !!! api "<span id="mfs-[connectFilter1,connectFilter2]=groupOuterConnectFilter0(nBall,G1_gId)">[connectFilter1,connectFilter2]=groupOuterConnectFilter0(nBall,G1_gId)</span>"
            %get the connection filter a group with all other elements

            

            

            

        !!! api "<span id="mfs-GForce=getWallGroupForce(d,G1_gId,G2_gId)">GForce=getWallGroupForce(d,G1_gId,G2_gId)</span>"
            用于支持d.getGroupForce函数

            d对象；组Id

            

            

        !!! api "<span id="mfs-GForce=getModelGroupForce(d,G1_gId,G2_gId)">GForce=getModelGroupForce(d,G1_gId,G2_gId)</span>"
            用于支持d.getGroupForce函数

            d对象；组Id

            

            

