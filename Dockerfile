FROM --platform=linux/arm64 public.ecr.aws/lambda/python:3.8-arm64

RUN yum update -y && \
  yum install -y libglib2.0-0 wget git make pkgconfig gcc gcc-c++ pixman-devel git make autoconf automake libtool zlib nasm file libpng-dev libwebp libjpeg-turbo libjpeg-turbo-devel cairo-devel pango-devel giflib giflib-devel

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget -O ~/miniconda.sh -q --progress=bar:force https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh && \
  /bin/bash ~/miniconda.sh -b -p $CONDA_DIR && \
  rm ~/miniconda.sh
ENV PATH=$CONDA_DIR/bin:$PATH

RUN cd / && git clone https://github.com/CompVis/stable-diffusion.git sd \
  && cd sd/ && git fetch origin pull/56/head:cpuonly && git checkout cpuonly

WORKDIR /sd

ENV USE_OPENMP 1
ENV OMP_NUM_THREADS 1

# RUN conda update -n base -c conda-forge conda
RUN pip uninstall torch torchvision -y
COPY environment.yaml /sd/environment.yaml
RUN conda env create --file environment.yaml

COPY custom/ /sd/custom

ENTRYPOINT ["/bin/bash", "-l", "-c"]