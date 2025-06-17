FROM freeradius/freeradius-server:latest

RUN apt-get update && \
    apt-get install -y gettext && \
    apt-get clean

COPY entrypoint.sh /entrypoint.sh
COPY clients.conf.template /etc/freeradius/clients.conf.template
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["freeradius", "-X"]
