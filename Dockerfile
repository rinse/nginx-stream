FROM ubuntu:18.04 as builder

RUN  apt update && apt install -y \
        gcc \
        git \
        make \
   && git clone https://github.com/nginx/nginx -b release-1.16.1 \
   && cd nginx \
   && ./auto/configure \
        --prefix=/usr/local/nginx   \
        --without-http_gzip_module  \
        --without-http_rewrite_module \
        --without-http_proxy_module \
        --without-pcre  \
        --with-stream   \
   && make \
   && make install


FROM ubuntu:18.04

COPY --from=builder /usr/local/nginx /usr/local/nginx

RUN  ln -sf /dev/stderr /usr/local/nginx/logs/error.log

ENV PATH=$PATH:/usr/local/nginx/sbin

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
