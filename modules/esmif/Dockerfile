## base container
FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-devel

RUN apt-get update \
    && apt-get install --yes rename procps curl git \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install torch_geometric
RUN pip install pyg_lib torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-2.1.0+cu121.html
RUN pip install biotite
RUN pip install git+https://github.com/facebookresearch/esm.git