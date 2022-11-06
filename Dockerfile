FROM ubuntu:22.04

# Install packages
RUN apt-get update && apt-get -y install vim unzip curl libfile-spec-native-perl
RUN apt-get update && apt-get -y install build-essential sqlite3 perl-doc libdbi-perl libdbd-sqlite3-perl
RUN cpan install common::sense
RUN cpan install Linux::Inotify2

# Timezone (no prompt)
ARG TZ "Europe/Vienna"
ENV tz=$TZ
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata
RUN echo "$tz" > /etc/timezone
RUN rm -f /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

WORKDIR /work

# Copy entrypoint script
COPY entrypoint.sh .
RUN chmod a+x entrypoint.sh

RUN curl -O https://www.idrivedownloads.com/downloads/linux/download-for-linux/LinuxScripts/IDriveForLinux.zip && \
    unzip IDriveForLinux.zip && \
    rm IDriveForLinux.zip

WORKDIR /work/IDriveForLinux/scripts

RUN chmod a+x *.pl

RUN ln -s /work/IDriveForLinux/scripts/cron.pl /etc/idrivecron.pl

COPY .serviceLocation .

RUN mkdir -p /mnt/files && \
    touch /mnt/files/idrivecron && \
    chmod 755 /mnt/files/idrivecron && \
    ln -s /mnt/files/idrivecron /etc/init.d/idrivecron

RUN mkdir -p /mnt/files && \
    touch /mnt/files/idrivecrontab.json && \
    ln -s /mnt/files/idrivecrontab.json /etc/idrivecrontab.json

RUN mkdir -p /mnt/backup

# Run the command on container startup
ENTRYPOINT ["/work/entrypoint.sh"]
