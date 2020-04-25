FROM ubuntu:18.04
WORKDIR /updater
RUN apt-get update \
 && apt-get install -y \
    cron \
    curl \
    python3 \
    python3-distutils \
 && rm -rf /var/lib/apt/lists/* \
 && curl -O https://bootstrap.pypa.io/get-pip.py \
 && python3 get-pip.py \
 && pip3 install awscli --upgrade \
 && aws configure set default.s3.max_concurrent_requests 1
 && aws configure set default.s3.max_bandwidth 524880
COPY file_placeholders/ /updater/
COPY entrypoint.sh /updater
COPY sync.sh /updater
COPY crontab /etc/cron.d/
RUN chmod 0644 /etc/cron.d/crontab \
  && crontab /etc/cron.d/crontab
CMD ["./entrypoint.sh"]
