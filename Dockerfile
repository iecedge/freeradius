FROM ubuntu:16.04

COPY ./VERSION VERSION

RUN if test "$(uname -m)" = "x86_64" ; then SUFFIX="+dfsg-0.1ubuntu0.1"; else SUFFIX="+dfsg-0.1build2"; fi \
    && VERSION=$(cat VERSION) \
    && apt -y update \
    && apt -y install \
        software-properties-common \
        libfreeradius2=${VERSION}${SUFFIX} \
        freeradius=${VERSION}${SUFFIX} \
        freeradius-mysql=${VERSION}${SUFFIX} \
        freeradius-postgresql=${VERSION}${SUFFIX} \
        freeradius-utils=${VERSION}${SUFFIX} \
        mysql-client-core-5.7 \
        curl \
        gettext-base

EXPOSE 1812/udp 1813/udp

ADD templates/default.template default.template
ADD templates/inner-tunnel.template inner-tunnel.template
ADD templates/radiusd.conf.template radiusd.conf.template
ADD templates/proxy.conf.template proxy.conf.template
ADD templates/clients.conf.template clients.conf.template
ADD templates/sql.conf.template sql.conf.template
ADD templates/files.template files.template
ADD docker-entrypoint.sh docker-entrypoint.sh
ADD templates/eap.conf /etc/freeradius/eap.conf
ADD templates/dialup.conf /etc/freeradius/sql/mysql/dialup.conf
ADD templates/schema.sql /etc/freeradius/sql/mysql/schema.sql

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD /usr/sbin/freeradius -X
