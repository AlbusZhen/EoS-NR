# 物态方程-中子星-引力波程序指南

这个程序包采用的都是开源的程序，我们将它们组合在一起，建设了这个从核物质的物态方程出发，计算双中子星或中子星-黑洞并合过程的参数，特别是其发出引力波的过程。未来我们希望将核力和多体的程序加入进来，使它变成一个完全的核物质工具包。选定特定的核力和需要计算的核物质后，程序将自动计算物态方程并生成质量半径曲线，而后选择需要计算的中子星质量，便可以自动计算相关的核天体物理学参数，并给出一个可视化的结果。

目前这个程序还只是一个雏形，我们在这个文档中给出了程序包的安装和使用方法。由于服务器不能联网，许多程序包的文件也一并附上——只需要将下载命令替换为
```shell
tar -xzvf $FILE_NAME
```
即可得到文件。如果你想得到最新版本，依然可以用相关命令进行下载。

本文中的操作在Linux系统下测试成功，我们推荐在操作任何文件之前都给予777的最高权限。

同时列出在天河3上我已经load的所有module：

- GCC/7.5.0
- blas/3.7.0-gcc4.8
- fftw/3.3.4-icc16-IMPI5.1(default)
- MPI/mvapich2-2.2/intel2019u5
- git/2.9.5-gcc4.8(default)
- swig/3.0.12-icc16(default)
- gsl/2.3-icc16(default)
- visit/2.12.3(default)
- MKL/16.0.3-icc16(default)
- ruby/2.6.0-gcc4.8(default)
- perl/5.24.1(default)
- lapack/3.8.0-gcc4.9
- ffmpeg/3.2.4-gcc4.8(default)
- Intel_compiler/17.0.4



---
## 软件包中包含的内容

- LORENE
- Einstein ToolKit


---
## 软件包的相关依赖库

上面的软件构成了这个工具包的主体，在安装它们之前我们需要安装许多的依赖库，在天河3F上这些依赖库几乎是完备的，所以有可能你并不需要进行什么操作。

如果没有提到，很多环境变量的设置并不需要在./bashrc中更改，似乎它们只影响程序的编译和链接。

---
### LORENE的安装

LORENE是由三位科学家在法国开发的计算软件包，用于数值相对论和计算天体物理等相关领域的计算。它使用一种名为谱方法的手段进行计算。我们利用它生成天体系统演化的初始状态。

LORENE官方网站：<https://lorene.obspm.fr/>

LORENE的文件需要通过cvs安装，它是一个古老的软件版本控制系统。在Linux终端命令行键入

```shell
cvs -d :pserver:anonymous@octane.obspm.fr:/cvsroot login
```

当显示需要密码时，输入
```shell
anonymous
```

在登陆cvs服务器后，输入
```shell
cvs -z5 -d :pserver:anonymous@octane.obspm.fr:/cvsroot checkout Lorene
```

你所在的工作目录将会把文件下载到一个名为Lorene的文件夹中。

进入目录并设置环境变量：
```shell
cd Lorene
export HOME_LORENE=$PWD
```

根据你的系统选择对应的编译设置；对于天河3上的Linux系统，需要输入
```shell
cd $HOME_LORENE
cp Local_settings_examples/local_settings_linux_gcc-4.4 local_settings
```

这样就可以进行编译
```shell
make
```

并运行测试
```shell
make test
```

如果编译成功，LORENE已经可以正常使用了。

在天河3上，LORENE强依赖的一个绘图软件包没有安装，因此我们需要额外安装pgplot软件包，并在之后的计算中添加其库的路径。如果你的系统上装有pgplot（或是在Ubuntu上可以直接apt install），你就不需要阅读下面的教程。
- pgplot绘图包的安装
这个程序包的安装相对有些复杂。文件需要通过ftp文件传输来获得，输入
```shell
ftp://ftp.astro.caltech.edu/pub/pgplot/pgplot5.2.tar.gz
```
你便能得到一个对应的压缩文件。将压缩文件解压到
```shell
~/$USER_NAME/local/
```
注意不是/usr/local/，因为我们没有管理员权限，只能进行本地安装。进入文件夹，设置安装选项
```shell
cd pgplot
cp drivers.list .
```
通过vim命令修改上述文件的以下部分（展示的部分为修改后）
```shell
 #PSDRIV 1,2,3,4 : EPS figures
 #XWDRIV 1,2 : X-window output
```
也就是说将上面六个选项前面的“!”去掉。进入源码，留存重要文件的副本
```sh
cd src
cp grpckg1.inc grpckg1.inc_backup  
cp pgplot.inc pgplot.inc_backup  
```
现在进入这两个文件中，修改相关的参数为
```sh
vim grpckg1.inc & # Replace " PARAMETER (GRIMAX = 8) " in line 29
                    #    by   " PARAMETER (GRIMAX = 32) "
                    
vim pgplot.inc &  # Replace " PARAMETER (PGMAXD=8) " in line 7
                    #    by   " PARAMETER (PGMAXD=32) "     
```
回到父文件夹，生成编译的必要文件
```sh
cd ../
./makemake ./ linux g77_gcc
```
修改刚刚生成的makefile并编译两次
```sh
vim makefile &   # Replace "FCOMPL=g77"       in line 25 
                 #   by    "FCOMPL=gfortran" 
                 # 
                 # Replace "FFLAGC=-u -Wall -fPIC -O" in line 26
                 #   by    "FFLAGC=-ffixed-form -ffixed-line-length-none -u -Wall -fPIC -O"
make
make cpg
make clean
```
现在你的程序应当安装成功了，运行
```sh
./pgdemo1
```
来测试结果。


在安装完pgplot之后，我们继续重复刚刚失败的LORENE编译测试(make test)操作。进入测试文件夹，修改MakeFile：
```sh
cd $HOME_LORENE/Test
vim MakeFile &   # Replace "$(LIB_PGPLOT)" 
                 #   by    "-L/THL8/home/$USERNAME/local/lib -lpgplot -lcpgplot -lx11" 
```
这样就可以make了。

至此，LORENE的安装全部完成了。

---
### Einstein ToolKit的安装

这个软件是基于Cactus框架的数值相对论计算软件，它的功能十分强大。我们用它来进行天体系统的演化过程和数据。

下载软件的下载器并更改权限：
```sh
curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/ET_2023_05/GetComponents
chmod a+x GetComponents
```
利用下载器下载全部需要的文件
```sh
./GetComponents https://einsteintoolkit.org/gallery/bns/bns.th
```
现在你的文件夹中应该有了一个名为Cactus的文件夹。进入文件夹初始化、并构建simfactory：
```sh
cd Cactus
./simfactory/bin/sim setup-silent
./simfactory/bin/sim build -j2 --thornlist thornlists/bns.th
```
其中“j2”指的是用两个核进行编译，你可以指定更多的核来编译。到这里，如果你没有遇到任何问题，理论上已经安装完成了。

你可以运行一个例子来测试：
```sh
./simfactory/bin/sim create-run helloworld \
    --parfile arrangements/CactusExamples/HelloWorld/par/HelloWorld.par
```
当屏幕上出现
```
INFO (HelloWorld): Hello World!
```
时，你的程序已经安装成功了。

---

## 程序的运行指南

