FROM empatica/jnlp-slave-with-docker:3.14-1

USER root

RUN apt-get update && \
    apt-get -y install python python-pip groff && \
    rm -rf /var/lib/apt/lists/*

ENV TERRAFORM_HOME /opt/terraform
ENV TERRAFORM_VERSION 0.11.8
ENV TERRAFORM_DOWNLOAD_SHA256=84ccfb8e13b5fce63051294f787885b76a1fedef6bdbecf51c5e586c9e20c9b7

RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip && \
    echo "${TERRAFORM_DOWNLOAD_SHA256} terraform.zip" | sha256sum --check - && \
    mkdir -p "${TERRAFORM_HOME}/bin" && \
    unzip terraform.zip && \
    rm terraform.zip && \
    mv terraform "${TERRAFORM_HOME}/bin" && \
    ln -s "${TERRAFORM_HOME}/bin/terraform" /usr/bin/terraform

USER jenkins

RUN pip install --upgrade awscli s3cmd python-magic docker-compose && \
    mkdir -p /home/jenkins/.terraform && \
    mkdir -p /home/jenkins/.aws

# ENV PATH ${PATH}:${HOME}/.local/bin

VOLUME "/home/jenkins/.terraform"
VOLUME "/home/jenkins/.aws"

USER root

RUN ln -s "${HOME}/.local/bin/aws" /usr/bin/aws && \
    ln -s "${HOME}/.local/bin/docker-compose" /usr/bin/docker-compose
