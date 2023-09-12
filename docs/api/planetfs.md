# planetfs

!!! api "class <span id="planetfs-planetfs">planetfs</span>"
    ???+ api "<span id="planetfs-props">Properties</span>"
    ???+ api "<span id="planetfs-methods">Methods</span>"
        !!! api "<span id="planetfs-resetmGXYZ(d)">resetmGXYZ(d)</span>"
            由于引力是累积的，每次计算时，需要重置单元体力（引力）为0

            d:build对象；

            无

            user_Asteroid

        !!! api "<span id="planetfs-setGroupInnerGravitation(d, gName, isGPU)">setGroupInnerGravitation(d, gName, isGPU)</span>"
            设置组内单元相互之间的万有引力，并将力累加到mGX，mGY，mGZ上

            d:build对象；

            无

            user_Asteroid

        !!! api "<span id="planetfs-setModelGravitation(d, isGPU)">setModelGravitation(d, isGPU)</span>"
            严格计算所有活动单元之间的万有引力，并将力累加到mGX，mGY，mGZ上

            d:build对象；isGPU是否用GPU计算

            无

            user_Asteroid

        !!! api "<span id="planetfs-limitElementInSphere(d, sphereR)">limitElementInSphere(d, sphereR)</span>"
            当活动单元位置在距原点sphereR距离外时，对其施加阻尼力，并将其固定在sphereR之外

            d:build对象；

            无

            user_Asteroid

        !!! api "<span id="planetfs-limitElementInFrame(d)">limitElementInFrame(d)</span>"
            根据d.mo.frame的值，当单元在frame定义的区域外时，施加临界阻尼

            d:build对象；

            无

            user_Asteroid

        !!! api "<span id="planetfs-getEscapeSpeed(d, gName)">getEscapeSpeed(d, gName)</span>"
            获取组（球体）的表面逃逸速度（其卫星速度要小于这个值）

            d:build对象；

            无

            user_Asteroid

        !!! api "<span id="planetfs-setZeroMomentum(d)">setZeroMomentum(d)</span>"
            建立新的参考系，使得模型在各个方向上的动量均为0，以保证模型不会整体运动

            d:build对象；

            [dVx,dVy,dVz]：新参考系的速度分量

            user_Asteroid

        !!! api "<span id="planetfs-getModelMomentum(d)">getModelMomentum(d)</span>"
            获得模型当前的动量，用在setZeroMomentum中

            d:build对象；

            [modelMoX,modelMoY,modelMoZ]：模型在X，Y，Z方向上的动量

            user_Asteroid

        !!! api "<span id="planetfs-setGroupOuterGravitation(d, gName)">setGroupOuterGravitation(d, gName)</span>"
            设置组对组外单元的引力，当只有一个输入参数时，gName默认为全部组

            d:build对象；gName：组名字符串或多个组的cell array

            

            user_Asteroid

        !!! api "<span id="planetfs-getModelGroup(d)">getModelGroup(d)</span>"
            获得当前模型中的组名的cell array

            d:build对象；

            modelG：组名的cell array

            user_Asteroid

        !!! api "<span id="planetfs-getGroupCenter(d)">getGroupCenter(d)</span>"
            获得当前模型中所有组的中心坐标，并返回

            d:build对象；

            groupCenter：组中心坐标结构体

            user_Asteroid

