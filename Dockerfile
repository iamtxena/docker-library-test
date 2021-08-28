FROM frolvlad/alpine-glibc:alpine-3.14

# Installing Conda
# Leave these args here to better use the Docker build cache
ARG CONDA_VERSION=py39_4.10.3
ARG SHA256SUM=1ea2f885b4dbc3098662845560bc64271eb17085387a70c2ba3f29fff6f8d52f

# hadolint ignore=DL3018
RUN apk add -q --no-cache bash procps && \
  wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O miniconda.sh && \
  echo "${SHA256SUM}  miniconda.sh" > miniconda.sha256 && \
  if ! sha256sum -cs miniconda.sha256; then exit 1; fi && \
  mkdir -p /opt && \
  sh miniconda.sh -b -p /opt/conda && \
  rm miniconda.sh miniconda.sha256 && \
  ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
  echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
  echo "conda activate base" >> ~/.bashrc && \
  find /opt/conda/ -follow -type f -name '*.a' -delete && \
  find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
  /opt/conda/bin/conda clean -afy

ENV PATH /bin:/sbin:/usr/bin:$PATH
ENV PATH /opt/conda/bin:$PATH
RUN conda init
RUN conda install scipy numpy matplotlib

RUN apk add bash
RUN pip install --upgrade pip
RUN pip install qibo

RUN apk update
RUN apk add bash

# RUN apk add --no-cache --virtual .build-deps \
#   gcc musl-dev linux-headers \
#   build-base python3-dev

# RUN apk add bash
# RUN pip install --upgrade pip
# COPY requirements.txt requirements.txt
# RUN pip install --no-cache-dir \
#   -r requirements.txt
# # Delete build dependencies
# RUN apk del .build-deps

ENV PROJECT_DIR /usr/src/code
WORKDIR ${PROJECT_DIR}

COPY ./qibo_test.py .

# ENV USER=docker
# ENV GROUP=docker
# ENV UID=12345
# ENV GID=23456

# RUN addgroup \
#   -g "$GID" "$GROUP"

# RUN adduser \
#   --disabled-password \
#   --gecos "" \
#   --home "$(pwd)" \
#   --ingroup "$USER" \
#   --no-create-home \
#   --uid "$UID" \
#   "$USER"

# RUN chown docker:docker ${PROJECT_DIR}
# USER docker

CMD ["python", "qibo_test.py"]