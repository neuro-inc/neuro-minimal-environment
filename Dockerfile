FROM woahbase/alpine-python3:x86_64

ENV LANG C.UTF-8
ENV PYTHONUNBUFFERED 1

ARG CLOUD_SDK_VERSION=347.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION

ENV PATH /google-cloud-sdk/bin:$PATH

WORKDIR /

RUN apk add --no-cache make curl git rsync rclone unrar zip unzip vim wget htop ssh 
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud --version

RUN pip3 install --no-cache-dir -U pip \
    && MULTIDICT_NO_EXTENSIONS=1 YARL_NO_EXTENSIONS=1 \
           pip3 install --no-cache-dir -U neuro-cli neuro-flow neuro-extras awscli

VOLUME ["/root/.config"]


