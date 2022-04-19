FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu18.04
RUN apt-get update && apt-get install -y python3-opencv python3-dev git wget sudo

RUN ln -sv /usr/bin/python3 /usr/bin/python

ARG USER_ID=1000

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER appuser

WORKDIR /home/appuser

ENV PATH="/home/appuser/.local/bin:${PATH}"

RUN wget https://bootstrap.pypa.io/get-pip.py && 	python3 get-pip.py --user && 	rm get-pip.py

RUN pip install --user tensorboard cmake   # cmake from apt-get is too old

RUN pip install --user torch==1.10 torchvision==0.11.1 -f https://download.pytorch.org/whl/cu111/torch_stable.html

ENV FORCE_CUDA="1"

ARG TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"

ENV TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST}"


ENV FVCORE_CACHE="/tmp"

RUN pip install basicsr -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install facexlib -i https://pypi.tuna.tsinghua.edu.cn/simple

COPY . .

RUN pip install --no-cache-dir \
    -r requirements.txt  -i https://pypi.tuna.tsinghua.edu.cn/simple

WORKDIR /home/appuser

EXPOSE 5000