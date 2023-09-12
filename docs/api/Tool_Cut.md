# Tool_Cut

!!! api "class <span id="Tool_Cut-Tool_Cut">Tool_Cut</span>"
    ???+ api "<span id="Tool_Cut-props">Properties</span>"
        !!! api "<span id="Tool_Cut-d">d</span>"
            build对象，即d

            

        !!! api "<span id="Tool_Cut-layerNum">layerNum</span>"
            用于切割的层面数

            

        !!! api "<span id="Tool_Cut-TriangleX">TriangleX</span>"
            三角面的X坐标，为n*3矩阵，单行上为一个三角形

            

        !!! api "<span id="Tool_Cut-TriangleY">TriangleY</span>"
            三角面的Y坐标，为n*3矩阵，单行上为一个三角形

            

        !!! api "<span id="Tool_Cut-TriangleZ">TriangleZ</span>"
            三角面的Z坐标，为n*3矩阵，单行上为一个三角形

            

        !!! api "<span id="Tool_Cut-SurfTri;">SurfTri;</span>"
            

            

        !!! api "<span id="Tool_Cut-Surf">Surf</span>"
            层面数据

            

    ???+ api "<span id="Tool_Cut-methods">Methods</span>"
        !!! api "<span id="Tool_Cut-Tool_Cut(d)">Tool_Cut(d)</span>"
            初始化对象

            build对象，即d

            见user_BoxModel示例

        !!! api "<span id="Tool_Cut-showSurf(varargin)">showSurf(varargin)</span>"
            显示层面

            无输入时：显示所有层面；一个输入时（矩阵）：显示指定的层面

            见user_BoxModel示例

        !!! api "<span id="Tool_Cut-setLayer(gNameCells, surfIds)">setLayer(gNameCells, surfIds)</span>"
            用层面来切割指定组

            gNameCells组名，surfIds层面的编号

            见user_BoxModel示例

        !!! api "<span id="Tool_Cut-delSurf(surfIds)">delSurf(surfIds)</span>"
            删除层面

            surfIds层面的编号

            见user_BoxModel示例

        !!! api "<span id="Tool_Cut-addSurf(para)">addSurf(para)</span>"
            根据离散点的坐标生成层面（三角网格），见Matlab命令scatteredInterpolant

            支持两种数据输入，1：输入包括XYZ信息的结构体；2：输入XYZ信息的矩阵[X,Y,Z]，或者[X,Y,Z,X,Y,Z...]，可为二维或三维数据。如为二维数据，需在XZ平面上。

            见user_BoxModel示例

        !!! api "<span id="Tool_Cut-setTriangle(PX,PY,PZ)">setTriangle(PX,PY,PZ)</span>"
            将PX,PY,PZ赋到对象的TriangleX,TriangleY,TriangleZ

            坐标矩阵

            见user_Box3DJointStress示例

        !!! api "<span id="Tool_Cut-bondFilter=setBondByTriangle(type)">bondFilter=setBondByTriangle(type)</span>"
            利用TriangeX,Y,Z记录的三角形来切割或胶结连接

            type:'break','glue','none'

            见user_Box3DJointStress示例

        !!! api "<span id="Tool_Cut-showTriangle()">showTriangle()</span>"
            显示TriangleX,Y,Z中的三角形

            无

            见user_Box3DJointStress示例

        !!! api "<span id="Tool_Cut-getTriangle(Id)">getTriangle(Id)</span>"
            将SurfTri中的三角面转到TriangleX,TriangleY,TriangleZ中

            Id:SurfTri的Id

            见user_Box3DJointStress示例

        !!! api "<span id="Tool_Cut-getSurfTri(Id,rate)">getSurfTri(Id,rate)</span>"
            根据Surf中离散点生成三角面并记录在SurfTri中

            Id:Surf的Id;rate:原始数据压缩比率，大等于1，如原始数据点太多，比率可以取大值，如2，则仅有1/2的数据会用来生成三角面

            见user_Box3DJointStress示例

        !!! api "<span id="Tool_Cut-showSurfTri(Id)">showSurfTri(Id)</span>"
            显示SurfTri中的三角面

            Id:SurfTri的Id

            见user_Box3DJointStress示例

