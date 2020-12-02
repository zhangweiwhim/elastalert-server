FROM python:3.8-alpine3.12 as py-ea
ARG ELASTALERT_VERSION=v0.2.4
ENV ELASTALERT_VERSION=${ELASTALERT_VERSION}
ARG ELASTALERT_URL=https://github.com/Yelp/elastalert/archive/$ELASTALERT_VERSION.zip
ENV ELASTALERT_URL=${ELASTALERT_URL}
ENV ELASTALERT_HOME /opt/elastalert

WORKDIR /opt

RUN apk add --update --no-cache ca-certificates openssl-dev openssl python3-dev python3 libffi-dev gcc musl-dev wget && \
    wget -O elastalert.zip "${ELASTALERT_URL}" && \
    unzip elastalert.zip && \
    rm elastalert.zip && \
    mv e* "${ELASTALERT_HOME}"

WORKDIR "${ELASTALERT_HOME}"

RUN python3 setup.py install

FROM node:alpine
LABEL maintainer="John Susek <john@johnsolo.net>"
ENV TZ Etc/UTC

RUN apk add --update --no-cache curl tzdata python3 ca-certificates openssl-dev openssl python3-dev gcc musl-dev make libffi-dev libmagic

COPY --from=py-ea /usr/lib/python3.8/site-packages /usr/lib/python3.8/site-packages
COPY --from=py-ea /opt/elastalert /opt/elastalert
# COPY --from=py-ea /usr/bin/elastalert* /usr/bin/

WORKDIR /opt/elastalert-server
COPY . /opt/elastalert-server

RUN npm install --production --quiet
COPY config/elastalert.yaml /opt/elastalert/config.yaml
COPY config/config.json config/config.json
COPY rule_templates/ /opt/elastalert/rule_templates
COPY elastalert_modules/ /opt/elastalert/elastalert_modules
# Fix until https://github.com/Yelp/elastalert/pull/2783 and https://github.com/Yelp/elastalert/pull/2640 and https://github.com/Yelp/elastalert/pull/2934 is merged
COPY patches/loaders.py /opt/elastalert/elastalert/loaders.py
# Fix until https://github.com/Yelp/elastalert/pull/2640 is merged
COPY patches/zabbix.py /opt/elastalert/elastalert/zabbix.py
# Fix until https://github.com/Yelp/elastalert/pull/2793 is merged
COPY patches/alerts.py /opt/elastalert/elastalert/alerts.py

# Add default rules directory
# Set permission as unpriviledged user (1000:1000), compatible with Kubernetes
RUN mkdir -p /opt/elastalert/rules/ /opt/elastalert/server_data/tests/ \
    && chown -R root:root /opt

RUN pip3 install --upgrade pip

USER root

EXPOSE 3030

WORKDIR /opt/elastalert

# Sync requirements.txt and setup.py & update py-zabbix #2818 (https://github.com/Yelp/elastalert/pull/2818)
# Pin elasticsearch to 7.0.0 in requirements.txt #2684 (https://github.com/Yelp/elastalert/pull/2684)
# version 0.2.1 broken for python 3.7 (jira) #2437 (https://github.com/Yelp/elastalert/issues/2437)
RUN sed -i 's/jira>=1.0.10,<1.0.15/jira>=2.0.0/g' requirements.txt && \
    sed -i 's/elasticsearch>=7.0.0/elasticsearch==7.0.0/g' requirements.txt && \
    sed -i 's/py-zabbix==1.1.3/py-zabbix>=1.1.3/g' requirements.txt && \
    sed -i 's/requests>=2.0.0/requests>=2.10.0/g' requirements.txt && \
    sed -i 's/twilio==6.0.0/twilio>=6.0.0,<6.1/g' requirements.txt && \
    pip3 install -r requirements.txt --user

WORKDIR /opt/elastalert-server

ENTRYPOINT ["npm", "start"]
