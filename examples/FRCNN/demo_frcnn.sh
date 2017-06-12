#!/usr/bin/env sh
# This script test four voc images using faster rcnn end-to-end trained model (ZF-Model)
# determine whether $1 is empty
if [ ! -n "$1" ] ;then
    echo "no parameter, default is 0"
    gpu="--gpu 0"
elif ["-no-gpu" == "$1"] ;then
    echo "don't use gpu"
    gpu=""
else
    echo "use $1-th gpu"
    gpu="--gpu $1"
fi

source models/FRCNN/fetch_imagenet_models.sh

BUILD=build/examples/FRCNN/demo_frcnn_api.bin

$BUILD $gpu \
       --model models/FRCNN/vgg16/test.proto \
       --weights models/FRCNN/faster_rcnn_models/VGG16_faster_rcnn_final.caffemodel \
       --default_c examples/FRCNN/config/voc_config.json \
       --image_dir examples/FRCNN/images/  \
       --out_dir examples/FRCNN/results/
