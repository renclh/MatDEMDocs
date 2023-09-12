# f

!!! api "class <span id="f-f">f</span>"
    ???+ api "<span id="f-props">Properties</span>"
    ???+ api "<span id="f-methods">Methods</span>"
        !!! api "<span id="f-imported=importLicenseFile(fileName)">imported=importLicenseFile(fileName)</span>"
            导入软件许可证

            fileName:许可证的文件名

            imported:是否已导入

            f.importLicenseFile('XMLdata/licenseDefault.mat');

        !!! api "<span id="f-align2center(form)">align2center(form)</span>"
            将窗口正中对齐

            无

            

            

        !!! api "<span id="f-clearApp()">clearApp()</span>"
            清除当前App记录

            无

            

            见user_Apps

        !!! api "<span id="f-clearFunction()">clearFunction()</span>"
            清除当前全部函数记录

            无

            

            见user_Functions

        !!! api "<span id="f-define(funFileName)">define(funFileName)</span>"
            定义一个函数

            文件名

            

            见user_Functions

        !!! api "<span id="f-getFunctionList()">getFunctionList()</span>"
            获取当前函数列表

            无

            

            见user_Functions

        !!! api "<span id="f-getGlobalData(name)">getGlobalData(name)</span>"
            获取已设置的全局变量

            全局变量名

            

            见user_Functions

        !!! api "<span id="f-getHandles()">getHandles()</span>"
            获得窗口的控件列表

            无

            控件列表结构 体

            f.getHandles(); 见user_setFontSize

        !!! api "<span id="f-run(funFileName, varargin)">run(funFileName, varargin)</span>"
            运行自定义函数

            函数名和参数

            

            见user_Functions

        !!! api "<span id="f-runWinApp(exportedFileName, varargin)">runWinApp(exportedFileName, varargin)</span>"
            运行自定义App

            exportedFileName: App文件名；varargin: 是否包含默认菜单，true or false

            WinApp类对象

            见user_Apps

        !!! api "<span id="f-save(fileName, data, varargin)">save(fileName, data, varargin)</span>"
            保存矩阵数据到记事本文件(.txt)或excel文件(.xls)

            fileName:文件名；data:矩阵数据；varargin:可选参数，不输入时默认保存为记事本文件，输入字符串'excel'时，保存为excel文件

            

            

        !!! api "<span id="f-setGlobalData(name, value)">setGlobalData(name, value)</span>"
            设置全局变量

            name: 全局变量名；value: 变量值

            

            见user_Functions

        !!! api "<span id="f-0以下为程序内部函数，通常不直接使用">0以下为程序内部函数，通常不直接使用</span>"
            

            

            

            

        !!! api "<span id="f-ChangeOutputFocus(OutputFocus)">ChangeOutputFocus(OutputFocus)</span>"
            

            

            

            

        !!! api "<span id="f-ChangePlottingArea(PlottingArea)">ChangePlottingArea(PlottingArea)</span>"
            

            

            

            

        !!! api "<span id="f-ChangePlottingAreaParent(PlottingAreaParent)">ChangePlottingAreaParent(PlottingAreaParent)</span>"
            

            

            

            

        !!! api "<span id="f-clearAll()">clearAll()</span>"
            *将删除

            

            

            

        !!! api "<span id="f-clearCommands(MatDEMcommands)">clearCommands(MatDEMcommands)</span>"
            

            

            

            

        !!! api "<span id="f-commandsChar2Cell(MatDEMcommandsChar)">commandsChar2Cell(MatDEMcommandsChar)</span>"
            

            

            

            

        !!! api "<span id="f-commandsChar2Cell0(MatDEMcommandsChar)">commandsChar2Cell0(MatDEMcommandsChar)</span>"
            

            

            

            

        !!! api "<span id="f-getFileName(funFileName)">getFileName(funFileName)</span>"
            

            

            

            

        !!! api "<span id="f-getFunHeadName(funHead)">getFunHeadName(funHead)</span>"
            

            

            

            

        !!! api "<span id="f-getOneCommand(MatDEMi, MatDEMcommands, addNeedEndNum)">getOneCommand(MatDEMi, MatDEMcommands, addNeedEndNum)</span>"
            

            

            

            

        !!! api "<span id="f-isCommandHaveEnd(commandOne)">isCommandHaveEnd(commandOne)</span>"
            

            

            

            

        !!! api "<span id="f-isCommandNeedEnd(commandOne)">isCommandNeedEnd(commandOne)</span>"
            

            

            

            

        !!! api "<span id="f-readClassFun(lines)">readClassFun(lines)</span>"
            

            

            

            

        !!! api "<span id="f-readFile(fileName)">readFile(fileName)</span>"
            

            

            

            

        !!! api "<span id="f-readFile0(fileName)">readFile0(fileName)</span>"
            

            

            

            

        !!! api "<span id="f-removeComment(commandStr)">removeComment(commandStr)</span>"
            

            

            

            

        !!! api "<span id="f-removeComments(lines)">removeComments(lines)</span>"
            

            

            

            

        !!! api "<span id="f-removeEmptyLine(lines)">removeEmptyLine(lines)</span>"
            

            

            

            

        !!! api "<span id="f-runFile(fileName, MatDEMpara)">runFile(fileName, MatDEMpara)</span>"
            

            

            

            

        !!! api "<span id="f-runFileCommandCells(MatDEMcommands, MatDEMParaName, MatDEMsave)">runFileCommandCells(MatDEMcommands, MatDEMParaName, MatDEMsave)</span>"
            *将删除

            

            

            

        !!! api "<span id="f-runFunctionCommandCells(MatDEMcommands, MatDEMpara)">runFunctionCommandCells(MatDEMcommands, MatDEMpara)</span>"
            *将删除

            

            

            

        !!! api "<span id="f-runUserCode(codeStr)">runUserCode(codeStr)</span>"
            *将删除

            

            

            

