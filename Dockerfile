FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu18.04
ENV DEBIAN_FRONTEND noninteractive

RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list
RUN sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list

RUN apt-get update && apt-get install -y python3-opencv python3.8 python3-pip git wget sudo

RUN ln -sv /usr/bin/python3.8 /usr/bin/python

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /home/appuser

ENV PATH="/home/appuser/.local/bin:${PATH}"

RUN python -m pip install --upgrade pip

RUN pip install torch==1.10 torchvision==0.11.1 matplotlib -f https://download.pytorch.org/whl/cu111/torch_stable.html

ENV FORCE_CUDA="1"

ARG TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"

ENV TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST}"

ENV FVCORE_CACHE="/tmp"

RUN pip install basicsr -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install facexlib -i https://pypi.tuna.tsinghua.edu.cn/simple

COPY . .

RUN pip install --no-cache-dir \
    -r requirements.txt  -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN wget https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth -P experiments/pretrained_models

WORKDIR /home/appuser

EXPOSE 5000