
from ubuntu

RUN apt-get update  -y
RUN apt-get install -y vim
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y git
RUN apt-get install -y git

RUN wget https://releases.hashicorp.com/terraform/1.6.5/terraform_1.6.5_linux_amd64.zip
RUN unzip terraform_1.6.5_linux_amd64.zip
RUN mv terraform /usr/local/bin/
RUN rm terraform_1.6.5_linux_amd64.zip

RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
RUN unzip awscli-exe-linux-x86_64.zip
RUN ./aws/install
RUN rm ./awscli-exe-linux-x86_64.zip

RUN wget https://github.com/derailed/k9s/releases/download/v0.28.0/k9s_Linux_amd64.tar.gz
RUN tar -xvf k9s_Linux_amd64.tar.gz
RUN mv k9s /usr/local/bin/

RUN wget https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl
RUN chmod 777 kubectl
RUN mv kubectl /usr/local/bin/

RUN mkdir -p /opt/apps/EKSClass
RUN mkdir -p /opt/apps/EKSClass/terraform

RUN wget https://github.com/tsl0922/ttyd/releases/download/1.7.4/ttyd.x86_64
RUN mv ttyd.x86_64 ttyd
RUN chmod 777 ttyd
RUN mv ttyd /bin/ttyd

WORKDIR /opt/apps/EKSClass

COPY bashrc /etc/bash.bashrc
COPY auto* /root
COPY terraform .

RUN rm -rf terraform 
# Expose port for WebTTY
EXPOSE 7681

ENTRYPOINT ["/bin/ttyd", "--writable"]
CMD ["/bin/bash"]



