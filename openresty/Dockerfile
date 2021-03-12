FROM openresty

ARG RESTY_USER

RUN set -o xtrace && \
    DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get upgrade --assume-yes && \
    apt-get dist-upgrade --assume-yes && \
    apt-get install --assume-yes libcap2-bin && \
    setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx-vanilla && \
    apt-get purge --assume-yes libcap2-bin && \
    apt-get autoremove --assume-yes && \
    apt-get autoclean && \
    apt-get clean && \
    rm --force --recursive /var/lib/apt/lists/* && \
    useradd ${RESTY_USER} --home-dir /nonexistent --shell /usr/sbin/nologin && \
    [ `id --user ${RESTY_USER}` -eq 1000 ] && \
    [ `id --group ${RESTY_USER}` -eq 1000 ] && \
    mkdir --parents \
    /var/cache/nginx/client_temp \
    /var/cache/nginx/fastcgi_temp \
    /var/cache/nginx/proxy_temp \
    /var/cache/nginx/scgi_temp \
    /var/cache/nginx/uwsgi_temp && \
    ln --symbolic --force /etc/nginx/bin/openresty /usr/sbin/nginx && \
    chown ${RESTY_USER}:0 /usr/sbin/nginx
