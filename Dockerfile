FROM centos:centos7
RUN mkdir /htcondor-es
COPY ./requirements.txt /htcondor-es/requirements.txt
COPY ./examples/config.ini /htcondor-es/config.ini
RUN yum install -y git sudo python36 python36-virtualenv python36-pip && \
ln -fs /usr/bin/python3 /usr/bin/python && \
ln -fs /usr/bin/pip3.6 /usr/bin/pip &&\
pip install -r /htcondor-es/requirements.txt
ENV PYTHONPATH "${PYTHONPATH}:/htcondor-es"
# ENV REQUESTS_CA_BUNDLE "/etc/pki/ca-trust/extracted/openssl/ca-bundle.trust.crt"

# Install latest kubectl for using with crons
RUN curl -k -O -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN mv kubectl /usr/bin
RUN chmod +x /usr/bin/kubectl

# copy spider codebase
COPY . /htcondor-es
WORKDIR /htcondor-es
RUN python setup.py build
RUN python setup.py install
RUN useradd --uid 1414 -ms /bin/bash spider &&\
chown -R spider /htcondor-es
USER spider
