<<<<<<< HEAD
**Special Feature for This Caffe Repository**

- Clone from the official caffe, will continuely be up-to-date by the official caffe code
- Faster rcnn joint train, test and evaluate
- Action recognition (Two Stream CNN)

## Faster RCNN

### Disclaimer
The official Faster R-CNN code (written in MATLAB) is [available](https://github.com/ShaoqingRen/faster_rcnn) here. If your goal is to reproduce the results in our NIPS 2015 paper, please use the [official](https://github.com/ShaoqingRen/faster_rcnn) code.

This repository contains a C++ reimplementation of the Python code([py-faster-rcnn](https://github.com/rbgirshick/py-faster-rcnn)). This C++ implementation is built on the offcial [caffe](https://github.com/BVLC/caffe), I will continue to update this code for improvement and up-to-date by offcial caffe.

All following steps, you should do these in the `$CAFFE_ROOT` path.

### Demo
Using `sh example/FRCNN/demo_frcnn.sh`, the will process five pictures in the `examples/FRCNN/images`, and put results into `examples/FRCNN/results`.

Note: You should prepare the trained caffemodel into `models/FRCNN`, such as `ZF_faster_rcnn_final.caffemodel` for ZF model.

### Prepare for training and evaluation
The list of training data is `examples/FRCNN/dataset/voc2007.trainval`.

The list of testing data is `examples/FRCNN/dataset/voc2007.trainval`.

Create symlinks for the PASCAL VOC dataset `ln -s $YOUR_VOCdevkit_Path $CAFFE_ROOT/VOCdevkit`.

As shown in VGG example `models/FRCNN/vgg16/train_val.proto`, the original pictures should appear at `$CAFFE_ROOT/VOCdevkit/VOC2007/JPEGImages/`. (Check window\_data\_param in FrcnnRoiData)

If you want to train Faster R-CNN on your own dataset, you may prepare custom dataset list.
The format is as below
```
# image-id
image-name
number of boxes
label x1 y1 x2 y2 difficulty
...
```

### Training
`sh examples/FRCNN/zf/train_frcnn.sh` will start training process of voc2007 data using ZF model.

If you use the provided training script, please make sure:
- VOCdevkit is within $CAFFE\_ROOT and VOC2007 in within VOCdevkit
- ZF pretrain model should be put into models/FRCNN/ as ZF.v2.caffemodel

`examples/FRCNN/convert_model.py` transform the parameters of `bbox_pred` layer by mean and stds values,
because the regression value is normalized during training and we should recover it to obtain the final model.

### Evaluation
`sh examples/FRCNN/zf/test_frcnn.sh` the will evaluate the performance of voc2007 test data using the trained ZF model.

- First Step of This Shell : Test all voc-2007-test images and output results in a text file.
- Second Step of This Shell : Compare the results with the ground truth file and calculate the mAP.

### Detail

Shells and prototxts for different models are listed in the `examples/FRCNN` and `models/FRCNN`

More details in the code:
- `include/api/FRCNN` and `src/api/FRCNN` for demo and test api
- `include/caffe/FRCNN` and `src/caffe/FRCNN` contains all codes related to Faster R-CNN

### Commands, Rebase From Caffe Master

**For synchronous with official caffe**

- git remote add caffe https://github.com/BVLC/caffe.git
- git fetch caffe
- git checkout master
- git rebase caffe/master

**Rebase the dev branch**
- git checkout dev
- git rebase master 
- git push -f origin dev

## QA
- CUB not found, when compile for GPU version, `frcnn_proposal_layer.cu` requires a head file `<cub/cub.cuh>`. CUB is library contained in the official Cuda Toolkit, usually can be found in ` /usr/local/cuda/include/thrust/system/cuda/detail/`. You should add this path in your `Makefile.config` (try `locate ''cub.cuh''` to find cub on your system)
- When Get `error: RPC failed; result=22, HTTP code = 0`, use `git config http.postBuffer 524288000`, increases git buffer to 500mb

## Two-Stream Convolutional Networks for Action Recognition in Video

See codes `src/caffe/ACTION_REC` and `include/caffe/ACTION_REC`

=======
# Windows Caffe

**This is an experimental, communtity based branch led by Guillaume Dumont (@willyd). It is a work-in-progress.**

This branch of Caffe ports the framework to Windows.

[![Travis Build Status](https://api.travis-ci.org/BVLC/caffe.svg?branch=windows)](https://travis-ci.org/BVLC/caffe) Travis (Linux build)

[![Windows Build status](https://ci.appveyor.com/api/projects/status/6xpwyq0y9ffdj9pb/branch/windows?svg=true)](https://ci.appveyor.com/project/willyd/caffe-4pvka/branch/windows) AppVeyor (Windows build)

## Windows Setup
**Requirements**:
 - Visual Studio 2013 or 2015
 - CMake 3.4+
 - Python 2.7 Anaconda x64 (or Miniconda)
 - CUDA 7.5 or 8.0 (optional) (use CUDA 8 if using Visual Studio 2015)
 - cuDNN v5 (optional)

you may also like to try the [ninja](https://ninja-build.org/) cmake generator as the build times can be much lower on multi-core machines. ninja can be installed easily with the `conda` package manager by adding the conda-forge channel with:
```cmd
> conda config --add channels conda-forge
> conda install ninja --yes
```
When working with ninja you don't have the Visual Studio solutions as ninja is more akin to make. An alternative is to use [Visual Studio Code](https://code.visualstudio.com) with the CMake extensions and C++ extensions.

### Install the caffe dependencies

The easiest and recommended way of installing the required depedencies is by downloading the pre-built libraries using the `%CAFFE_ROOT%\scripts\download_prebuilt_dependencies.py` file. Depending on your compiler one of the following commands should download and extract the prebuilt dependencies to your current working directory:

```cmd
:: Install Visual Studio 2013 dependencies
> python scripts\download_prebuilt_dependencies.py --msvc_version=v120
:: Or install Visual Studio 2015 dependencies
> python scripts\download_prebuilt_dependencies.py --msvc_version=v140
```

This will create a folder called `libraries` containing all the required dependencies. Alternatively you can build them yourself by following the instructions in the [caffe-builder](https://github.com/willyd/caffe-builder) [README](https://github.com/willyd/caffe-builder/blob/master/README.md). For the remaining of these instructions we will assume that the libraries folder is in a folder defined by the `%CAFFE_DEPENDENCIES%` environment variable.

### Build caffe

If you are using the Ninja generator you need to setup the MSVC compiler using:
```
> call "%VS120COMNTOOLS%..\..\VC\vcvarsall.bat" amd64
```
then from the caffe source folder you need to configure the cmake build
```
> set CMAKE_GENERATOR=Ninja
> set CMAKE_CONFIGURATION=Release
> mkdir build
> cd build
> cmake -G%CMAKE_GENERATOR% -DBLAS=Open -DCMAKE_BUILD_TYPE=%CMAKE_CONFIGURATION% -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=<install_path> -C %CAFFE_DEPENDENCIES%\caffe-builder-config.cmake  ..\
> cmake --build . --config %CMAKE_CONFIGURATION%
> cmake --build . --config %CMAKE_CONFIGURATION% --target install
```
In the above command `CMAKE_GENERATOR` can be either `Ninja`, `"Visual Studio 12 2013 Win64"` or `"Visual Studio 14 2015 Win64"` and `CMAKE_CONFIGURATION` can be `Release` or `Debug`. Please note however that Visual Studio will not parallelize the build of the CUDA files which results in much longer build times.

In case one of the steps in the above procedure is not working please refer to the appveyor build scripts in `%CAFFE_ROOT%\scripts\appveyor` to see the most up to date build procedure.

### Use cuDNN

To use cuDNN you need to define the CUDNN_ROOT cache variable to point to where you unpacked the cuDNN files. For example, the build command above would become:

```
> set CMAKE_GENERATOR=Ninja
> set CMAKE_CONFIGURATION=Release
> mkdir build
> cd build
> cmake -G%CMAKE_GENERATOR% -DBLAS=Open -DCMAKE_BUILD_TYPE=%CMAKE_CONFIGURATION% -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=<install_path> -DCUDNNROOT=<path_to_cudnn> -C %CAFFE_DEPENDENCIES%\caffe-builder-config.cmake  ..\
> cmake --build . --config %CMAKE_CONFIGURATION%
> cmake
```
Make sure to use forward slashes (`/`) in the path. You will need to add the folder containing the cuDNN DLL to your PATH.

### Building only for CPU

If CUDA is not installed Caffe will default to a CPU_ONLY build. If you have CUDA installed but want a CPU only build you may use the CMake option `-DCPU_ONLY=1`.

### Using the Python interface

The recommended Python distribution is Anaconda or Miniconda. To successfully build the python interface you need to install the following packages:
```
conda install --yes numpy scipy matplotlib scikit-image pip six
```
also you will need a protobuf python package that is compatible with pre-built dependencies. This package can be installed this way:
```
conda config --add channels willyd
conda install --yes protobuf==3.1.0.vc12
```
If Python is installed the default is to build the python interface and python layers. If you wish to disable the python layers or the python build use the CMake options `-DBUILD_python_layer=0` and `-DBUILD_python=0` respectively. In order to use the python interface you need to either add the `%CAFFE_ROOT%\python` folder to your python path of copy the `%CAFFE_ROOT%\python\caffe` folder to your `site_packages` folder. Also, you need to edit your `PATH` or copy the required DLLs next to the `caffe.pyd` file. Only Python 2.7 x64 has been tested on Windows.

### Using the MATLAB interface

TODO

### Building a shared library

CMake can be used to build a shared library instead of the default static library. To do so follow the above procedure and use `-DBUILD_SHARED_LIBS=ON`. Please note however, that some tests (more specifically the solver related tests) will fail since both the test exectuable and caffe library do not share static objects contained in the protobuf library.

### Running the tests or the caffe exectuable

To run the tests or any caffe exectuable you will have to update your `PATH` to include the directories where the depedencies dlls are located:
```
:: Prepend to avoid conflicts with other libraries with same name
:: For VS 2013
> set PATH=%CAFFE_DEPENDENCIES%\bin;%CAFFE_DEPENDENCIES%\lib;%CAFFE_DEPENDENCIES%\x64\vc12\bin;%PATH%
:: For VS 2015
> set PATH=%CAFFE_DEPENDENCIES%\bin;%CAFFE_DEPENDENCIES%\lib;%CAFFE_DEPENDENCIES%\x64\vc14\bin;%PATH%
```
or you can use the prependpath.bat included with the prebuilt dependencies. Then the tests can be run from the build folder:
```
cmake --build . --target runtest --config %CMAKE_CONFIGURATION%
```

### TODOs
- Python 3.5: Create protobuf packages for 3.5. Rebuild dependencies especially boost python with 3.5.

## Previous Visual Studio based build

The previous windows build based on Visual Studio project files is now deprecated. However, it is still available in the `windows` folder. Please see the [README.md](windows/README.md) in there for details.

## Known issues

- The `GPUTimer` related test cases always fail on Windows. This seems to be a difference between UNIX and Windows.
- Shared library (DLL) build will have failing tests.

## Further Details

Refer to the BVLC/caffe master branch README for all other details such as license, citation, and so on.
>>>>>>> make branch README for Windows port
