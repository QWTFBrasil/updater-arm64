FROM ubuntu:18.04
WORKDIR /updater
RUN apt-get update \
 && apt-get install -y \
    awscli \
    cron \
    curl \
 && rm -rf /var/lib/apt/lists/*
COPY file_placeholders/ /updater/
COPY entrypoint.sh /updater
COPY sync.sh /updater
COPY crontab /etc/cron.d/
RUN chmod 0644 /etc/cron.d/crontab \
  && crontab /etc/cron.d/crontab
CMD ["./entrypoint.sh"]
