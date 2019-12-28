FROM ubuntu:18.04
WORKDIR /updater
RUN apt-get update \
 && apt-get install -y curl cron awscli \
 && rm -rf /var/lib/apt/lists/*
RUN mkdir map-repo/ dats/
COPY sync.sh /updater
COPY entrypoint.sh /updater
COPY crontab /etc/cron.d/
RUN chmod 0644 /etc/cron.d/crontab \
  && crontab /etc/cron.d/crontab
CMD ["./entrypoint.sh"]
