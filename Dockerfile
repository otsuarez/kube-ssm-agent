FROM amazonlinux:2

ARG AWS_IAM_AUTHENTICATOR_VERSION=0.4.0
ARG UNAME=Linux

RUN yum update -y && \
    yum install -y systemd curl tar sudo && \
    yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

# RUN mkdir work && cd work && \
#     curl -L https://dl.k8s.io/v1.11.5/kubernetes-client-linux-amd64.tar.gz -o temp.tgz && \
#     tar zxvf temp.tgz && \
#     mv kubernetes/client/bin/kubectl /usr/bin/kubectl && \
#     cd .. && \
#     rm -rf work
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

RUN curl -L https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${AWS_IAM_AUTHENTICATOR_VERSION}/aws-iam-authenticator_${AWS_IAM_AUTHENTICATOR_VERSION}_linux_amd64 -o /usr/bin/aws-iam-authenticator && \
    chmod +x /usr/bin/aws-iam-authenticator

#Failed to get D-Bus connection: Operation not permitted
#RUN systemctl status amazon-ssm-agent

WORKDIR /opt/amazon/ssm/
CMD ["amazon-ssm-agent", "start"]
