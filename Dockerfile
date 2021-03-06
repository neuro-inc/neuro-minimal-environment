FROM python:3.7.11-alpine3.13

ENV LANG C.UTF-8
ENV PYTHONUNBUFFERED 1

ARG CLOUD_SDK_VERSION=347.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION

ENV PATH /google-cloud-sdk/bin:$PATH

WORKDIR /

RUN apk add --no-cache make curl git rsync unrar zip unzip vim wget htop openssh-client ca-certificates bash

# Install Google Cloud SDK
RUN wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud --version

# Install rclone
RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    rm rclone-current-linux-amd64.zip && \
    cp rclone-*-linux-amd64/rclone /usr/bin/ && \
    rm -rf rclone-*-linux-amd64 && \
    chmod 755 /usr/bin/rclone

# Install neuro CLI tools
RUN pip3 install --no-cache-dir -U pip \
    && MULTIDICT_NO_EXTENSIONS=1 YARL_NO_EXTENSIONS=1 \
           pip3 install --no-cache-dir -U neuro-cli==21.7.9 neuro-flow==21.7.9 neuro-extras==21.7.2 awscli==1.19.109

RUN mkdir -p /root/.ssh
COPY files/ssh/known_hosts /root/.ssh/known_hosts 

VOLUME ["/root/.config"]
