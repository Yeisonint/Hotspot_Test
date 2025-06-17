FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y hostapd iw gettext && \
    mkdir -p /var/run/hostapd && \
    apt-get clean

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]