FROM pytorch/pytorch

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    python3-opencv \
    && rm -rf /var/lib/apt/lists/*
RUN python -m pip install --upgrade pip
RUN mkdir /app
WORKDIR /app

RUN python -m pip install --no-cache-dir --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple \
    pip \
    setuptools \
    wheel

RUN pip install basicsr -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install facexlib -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install opencv-python -i https://pypi.tuna.tsinghua.edu.cn/simple

COPY . .

RUN python -m pip install --no-cache-dir \
    -r requirements.txt  -i https://pypi.tuna.tsinghua.edu.cn/simple

EXPOSE 5000