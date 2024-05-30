FROM ubuntu:22.04

# Install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends vim curl wget cron nano ca-certificates

# Timezone (no prompt)
ARG TZ "Europe/Vienna"
ENV tz=$TZ
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata
RUN echo "$tz" > /etc/timezone
RUN rm -f /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

WORKDIR /opt

# Copy entrypoint script
COPY entrypoint.sh .
RUN chmod a+x entrypoint.sh

RUN wget https://www.idrivedownloads.com/downloads/linux/download-for-linux/linux-bin/idriveforlinux.bin && \
    chmod a+x idriveforlinux.bin && \
    ./idriveforlinux.bin --install && \
    rm idriveforlinux.bin && \
    mv /opt/IDriveForLinux/idriveIt/ /opt/IDriveForLinux/idriveIt-orig

WORKDIR /opt/IDriveForLinux/bin

COPY .serviceLocation .

RUN ln -s /opt/IDriveForLinux/bin/idrive /etc/idrivecron

RUN mkdir -p /mnt/files && \
    touch /mnt/files/idrivecron && \
    chmod 755 /mnt/files/idrivecron && \
    ln -s /mnt/files/idrivecron /etc/init.d/idrivecron

RUN mkdir -p /mnt/files && \
    touch /mnt/files/idrivecrontab.json && \
    ln -s /mnt/files/idrivecrontab.json /etc/idrivecrontab.json

RUN mkdir -p /mnt/backup

# Run the command on container startup
ENTRYPOINT ["/opt/entrypoint.sh"]
