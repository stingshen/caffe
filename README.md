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

**This is an experimental, Microsoft-led branch by Pavle Josipovic (@pavlejosipovic). It is a work-in-progress.**

This branch of Caffe ports the framework to Windows.

[![Travis Build Status](https://api.travis-ci.org/BVLC/caffe.svg?branch=windows)](https://travis-ci.org/BVLC/caffe) Travis (Linux build)

[![Build status](https://ci.appveyor.com/api/projects/status/128eg95svel2a2xs?svg=true)]
(https://ci.appveyor.com/project/pavlejosipovic/caffe-v45qi) AppVeyor (Windows build)

## Windows Setup
**Requirements**: Visual Studio 2013

### Pre-Build Steps
Copy `.\windows\CommonSettings.props.example` to `.\windows\CommonSettings.props`

By defaults Windows build requires `CUDA` and `cuDNN` libraries.
Both can be disabled by adjusting build variables in `.\windows\CommonSettings.props`.
Python support is disabled by default, but can be enabled via `.\windows\CommonSettings.props` as well.
3rd party dependencies required by Caffe are automatically resolved via NuGet.

### CUDA
Download `CUDA Toolkit 7.5` [from nVidia website](https://developer.nvidia.com/cuda-toolkit).
If you don't have CUDA installed, you can experiment with CPU_ONLY build.
In `.\windows\CommonSettings.props` set `CpuOnlyBuild` to `true` and set `UseCuDNN` to `false`.

### cuDNN
Download `cuDNN v3` or `cuDNN v4` [from nVidia website](https://developer.nvidia.com/cudnn).
Unpack downloaded zip to %CUDA_PATH% (environment variable set by CUDA installer).
Alternatively, you can unpack zip to any location and set `CuDnnPath` to point to this location in `.\windows\CommonSettings.props`.
`CuDnnPath` defined in `.\windows\CommonSettings.props`.
Also, you can disable cuDNN by setting `UseCuDNN` to `false` in the property file.

### Python
To build Caffe Python wrapper set `PythonSupport` to `true` in `.\windows\CommonSettings.props`.
Download Miniconda 2.7 64-bit Windows installer [from Miniconda website] (http://conda.pydata.org/miniconda.html).
Install for all users and add Python to PATH (through installer).

Run the following commands from elevated command prompt:

```
conda install --yes numpy scipy matplotlib scikit-image pip
pip install protobuf
```

#### Remark
After you have built solution with Python support, in order to use it you have to either:  
* set `PythonPath` environment variable to point to `<caffe_root>\Build\x64\Release\pycaffe`, or
* copy folder `<caffe_root>\Build\x64\Release\pycaffe\caffe` under `<python_root>\lib\site-packages`.

### Matlab
To build Caffe Matlab wrapper set `MatlabSupport` to `true` and `MatlabDir` to the root of your Matlab installation in `.\windows\CommonSettings.props`.

#### Remark
After you have built solution with Matlab support, in order to use it you have to:
* add the generated `matcaffe` folder to Matlab search path, and
* add `<caffe_root>\Build\x64\Release` to your system path.

### Build
Now, you should be able to build `.\windows\Caffe.sln`

## Further Details

Refer to the BVLC/caffe master branch README for all other details such as license, citation, and so on.
>>>>>>> make branch README for Windows port
