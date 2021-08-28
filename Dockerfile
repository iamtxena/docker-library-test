FROM frolvlad/alpine-glibc:alpine-3.14 as alpine-miniconda

# Leave these args here to better use the Docker build cache
ARG CONDA_VERSION=py39_4.10.3
ARG SHA256SUM=1ea2f885b4dbc3098662845560bc64271eb17085387a70c2ba3f29fff6f8d52f

RUN apk update
RUN apk add bash
RUN apk add git

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
RUN conda install scipy numpy matplotlib sympy

RUN pip install --upgrade pip

FROM alpine-miniconda as alpine-miniconda-qibo

ENV PROJECT_DIR /usr/src/code
WORKDIR ${PROJECT_DIR}

ENV PATH /bin:/sbin:/usr/bin:$PATH
ENV PATH /opt/conda/bin:$PATH
RUN conda init

RUN cd /usr/src && \
  git clone https://github.com/qilimanjaro-tech/qibo.git && \
  cd qibo && \
  git checkout qilimanjaro-backend && \
  pip install .

ARG GITHUB_USER
ARG GITHUB_TOKEN
RUN cd /usr/src && \
  git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/qilimanjaro-tech/qili-qibo-backend.git && \
  cd qili-qibo-backend && \
  git checkout QIBO30-qqs-connection && \
  pip install .

FROM alpine-miniconda-qibo

ADD requirements.txt .
RUN pip install -r requirements.txt
COPY src src

ENV USER=docker
ENV GROUP=docker
ENV UID=12345
ENV GID=23456

RUN addgroup \
  -g "$GID" "$GROUP"

RUN adduser \
  --disabled-password \
  --gecos "" \
  --home "$(pwd)" \
  --ingroup "$USER" \
  --no-create-home \
  --uid "$UID" \
  "$USER"

RUN chown docker:docker ${PROJECT_DIR}
USER docker

CMD ["flask","run"]