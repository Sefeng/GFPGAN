FROM pytorch/pytorch

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

COPY requirements.txt .
RUN python -m pip install --no-cache-dir --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple \
    pip \
    setuptools \
    wheel

RUN pip install basicsr -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install facexlib -i https://pypi.tuna.tsinghua.edu.cn/simple


RUN python -m pip install --no-cache-dir \
    -r requirements.txt  -i https://pypi.tuna.tsinghua.edu.cn/simple
COPY . .

EXPOSE 5000