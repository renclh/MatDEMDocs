# 安装

## 软件配置

**操作系统**
: MatDEM采用Matlab语言编写，因此理论上只要能运行Matlab的操作系统就可运行MatDEM，包括Windows，Linux，Unix以及Mac OS等。目前绝大多数MatDEM用户使用Windows系统，故只编译和维护Windows版的MatDEM，如有需求，今后会增加针对其他系统的版本。

???+ note "Matlab运行环境"

    MatDEM二次开发基于Matlab 语言，需要安装Matlab运行环境（不需要安装Matlab软件），**MatDEM_v1.42及以上版本需安装 R2019a (9.6)版本运行环境**。MatDEM_v2.50及以上版本需安装R2021a (9.10)版本运行环境。Matlab运行环境免费，可至[Matlab官网下载安装](https://cn.mathworks.com/products/compiler/matlab-runtime.html)。

???+ note "MatDEM软件运行"
    MatDEM软件解压后，打开MatDEM，进入“主程序”，在其右侧工作文件夹中双击打开示例代码（右图），通常运行代码1~3步完成数值模拟（如BoxCrash1~3）。最新版本MatDEM下载，请至网站：[http://matdem.com](http://matdem.com/download)。

???+ note "GPU驱动"
    从专业厂家采购的GPU服务器，通常会安装好 Cuda 运行库。如果个人笔记本电脑和台式机出现GPU无法识别和使用的提示，需要到英伟达网站上下载安装最新的[显卡驱动](http://www.nvidia.cn/Download/index.aspx?lang=cn)。如仍存在问题，再安装[cuda驱动](https://developer.nvidia.com/cuda-downloads)即可

## 硬件配置

???+ note "GPU"
    GPU计算需要英伟达（Nvidia）独立显卡，一般笔记本也可以计算，但效率仅提升5倍左右，较好的台式机显卡，能提升十多倍效率。如果需要数十倍的效率提升，则需要英伟达生产的专业Tesla GPU计算卡，如Tesla V100。1G的显存最多能计算约10万个三维单元，**大规模计算需要较大的显存**。

???+ note "CPU"
    GPU计算需要CPU来控制，因此也需要有**较高主频**的CPU。一个GPU通常需要两个CPU核即可，MatDEM计算对CPU核数要求不高。如双路CPU至强E5-2637v4有比较高的性价比，Gold CPU性能通常更高。当然，更高主频与核数的CPU则有更好的计算表现。

???+ note "显卡"
    MatDEM模拟结果的三维显示对显卡有较高的要求（**显存容量要高**）。如果要显示数十万的三维颗粒，需要有较好的专业显卡。

???+ note "内存和硬盘"
    系统内存容量最好是GPU显存容量的2倍以上。如需进行大规模计算，可购买1T或更多的SSD硬盘，搭配8T或更多的机械硬盘。

???+ note "其他"
    如使用普通台式机，建议采购大显存的Nvidia独立显卡和高主频的CPU。通常情况下，高性能游戏主机的配置即可。

