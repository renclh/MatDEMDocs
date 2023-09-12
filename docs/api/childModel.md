# childModel

!!! api "class <span id="childModel-childModel">childModel</span>"
    ???+ api "<span id="childModel-props">Properties</span>"
        !!! api "<span id="childModel-childId">childId</span>"
            子模型的编号

            

        !!! api "<span id="childModel-SET">SET</span>"
            模拟设置信息，可记录二次开发新的数据

            

        !!! api "<span id="childModel-TAG">TAG</span>"
            模拟信息记录，用于记录和输出信息

            

        !!! api "<span id="childModel-FnCommand">FnCommand</span>"
            正向力的定义，默认为线弹性接触。采用备注中的代码，可以定义hertz接触模型，具体原理可见《地质与岩土工程矩阵离散元分析》

            

        !!! api "<span id="childModel-parent_aId">parent_aId</span>"
            子模型单元对应的编号

            

        !!! api "<span id="childModel-mId_A">mId_A</span>"
            

            

        !!! api "<span id="childModel-isGPU">isGPU</span>"
            是否启用GPU

            

        !!! api "<span id="childModel-mNum">mNum</span>"
            子模型活动单元数

            

        !!! api "<span id="childModel-parent_mId">parent_mId</span>"
            子模型活动单元对应的编号

            

        !!! api "<span id="childModel-nBall">nBall</span>"
            以下与model类相同

            

        !!! api "<span id="childModel-bFilter">bFilter</span>"
            

            

        !!! api "<span id="childModel-cFilter">cFilter</span>"
            

            

        !!! api "<span id="childModel-tFilter">tFilter</span>"
            

            

        !!! api "<span id="childModel-nBondRate">nBondRate</span>"
            

            

        !!! api "<span id="childModel-isBondRate">isBondRate</span>"
            

            

        !!! api "<span id="childModel-nKNe">nKNe</span>"
            

            

        !!! api "<span id="childModel-nKSe">nKSe</span>"
            

            

        !!! api "<span id="childModel-nFnX">nFnX</span>"
            

            

        !!! api "<span id="childModel-nFnY">nFnY</span>"
            

            

        !!! api "<span id="childModel-nFnZ">nFnZ</span>"
            

            

        !!! api "<span id="childModel-nFsX">nFsX</span>"
            

            

        !!! api "<span id="childModel-nFsY">nFsY</span>"
            

            

        !!! api "<span id="childModel-nFsZ">nFsZ</span>"
            

            

        !!! api "<span id="childModel-nClump">nClump</span>"
            

            

        !!! api "<span id="childModel-parentMo">parentMo</span>"
            model对象

            

    ???+ api "<span id="childModel-methods">Methods</span>"
        !!! api "<span id="childModel-applyMoId(moChild, aMoId)">applyMoId(moChild, aMoId)</span>"
            

            

            

            

        !!! api "<span id="childModel-addElement(moChild, aList)">addElement(moChild, aList)</span>"
            以下与model类相同

            

            

            

        !!! api "<span id="childModel-delElement(moChild, aRList, aRFilter, aMoId)">delElement(moChild, aRList, aRFilter, aMoId)</span>"
            

            

            

            

        !!! api "<span id="childModel-setModel(obj)">setModel(obj)</span>"
            

            

            

            

        !!! api "<span id="childModel-zeroBalance(obj)">zeroBalance(obj)</span>"
            

            

            

            

        !!! api "<span id="childModel-testSpeed(obj, varargin)">testSpeed(obj, varargin)</span>"
            

            

            

            

        !!! api "<span id="childModel-setGPU(obj, type0)">setGPU(obj, type0)</span>"
            

            

            

            

        !!! api "<span id="childModel-setShear(obj, type)">setShear(obj, type)</span>"
            

            

            

            

        !!! api "<span id="childModel-setKNKS(obj)">setKNKS(obj)</span>"
            

            

            

            

        !!! api "<span id="childModel-show(obj)">show(obj)</span>"
            

            

            

            

        !!! api "<span id="childModel-childModel(d)">childModel(d)</span>"
            

            

            

            

        !!! api "<span id="childModel-removeGroupForce(moChild)">removeGroupForce(moChild)</span>"
            

            

            

            

        !!! api "<span id="childModel-balance(moChild)">balance(moChild)</span>"
            

            

            

            

