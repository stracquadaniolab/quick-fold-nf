FROM pytorch/pytorch:1.12.1-cuda11.3-cudnn8-devel

RUN apt-get update \
    && apt-get install --yes rename procps curl git \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN conda install pyg -c pyg -c conda-forge \
    && conda install pip

RUN pip install fair-esm[esmfold] \
    pip install 'dllogger @ git+https://github.com/NVIDIA/dllogger.git'\
    pip install 'openfold @ git+https://github.com/aqlaboratory/openfold.git@4b41059694619831a7db195b7e0988fc4ff3a307' \
    pip install biotite
#