#FROM quay.io/willbenton/s2i-minimal-notebook:3.6
FROM docker.io/centos/python-36-centos7
#FROM minimal-notebook:latest
# Switch user to root so we have install privileges 

USER root

ADD . /opt/app-root

WORKDIR /opt/app-root

ENV PYTHON_VERSION=3.6 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

ENV NAME=python3 \
    VERSION=0 \
    RELEASE=1 \
    ARCH=x86_64

USER root

# Add lables to builder for OpenShift

LABEL io.k8s.description="Cookie-Cutter s2i builder for Jupyter." \
      io.k8s.display-name="Jupyter (S2i)" \
      io.openshift.expose-services="8080:http" \
      io.openshift.s2i.scripts-url="image:///opt/app-root/.s2i/"

# Copy s2i builder scripts for installing Python packeges and copying notebooks and files

ADD https://github.com/sophwats/jupyter-notebooks/archive/master.zip jupyter-notebooks.zip
RUN unzip jupyter-notebooks.zip
RUN rm jupyter-notebooks.zip

COPY .s2i /opt/app-root/.s2i

# Revert user 

USER 1000

# Command to start up our Jupyter notebook server

CMD [ "/opt/app-root/.s2i/run" ]
