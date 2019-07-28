FROM debian:buster-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends proftpd proftpd-mod-mysql && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
	sed -i.bak "s/# DefaultRoot/DefaultRoot/" /etc/proftpd/proftpd.conf && \
	echo "Include /etc/proftpd/sql.conf" >> /etc/proftpd/proftpd.conf && \
	echo "RequireValidShell off" >> /etc/proftpd/proftpd.conf && \
	echo "MasqueradeAddress 127.0.0.1" >> /etc/proftpd/proftpd.conf && \
	echo "PassivePorts 60000 60100" >> /etc/proftpd/proftpd.conf && \
	echo "LoadModule mod_sql.c" >> /etc/proftpd/modules.conf && \
	echo "LoadModule mod_sql_mysql.c" >> /etc/proftpd/modules.conf

COPY sql.conf /etc/proftpd/sql.conf

EXPOSE 20 21 60000-60100

COPY entrypoint.sh /usr/local/sbin/entrypoint.sh
ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]

CMD ["proftpd", "--nodaemon"]
