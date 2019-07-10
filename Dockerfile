FROM ubuntu:18.04
WORKDIR /updater
RUN apt-get update && apt-get install -y \
      curl \
      rsync \
      cron \
      unzip
RUN mkdir qwprogs.dat/ && mkdir qwprogs.dat/production && mkdir qwprogs.dat/staging
RUN curl -L \
  -o qwprogs.dat/production/qwprogs.dat \
  https://github.com/FortressOne/server-qwprogs/releases/latest/download/qwprogs.dat
RUN cp qwprogs.dat/production/qwprogs.dat qwprogs.dat/staging/qwprogs.dat
RUN curl -L \
  -o map-repo.zip \
  https://github.com/FortressOne/map-repo/releases/latest/download/map-repo.zip \
  && unzip map-repo.zip \
  && rm map-repo.zip
COPY sync.sh /updater
COPY crontab /etc/cron.d/
RUN chmod 0644 /etc/cron.d/crontab \
  && crontab /etc/cron.d/crontab
CMD ["cron", "-f"]
