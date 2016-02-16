FROM debian:jessie
MAINTAINER Jimmy Xiao <xjm1285@gmail.com>

RUN echo "deb http://mirrors.ustc.edu.cn/debian jessie main contrib non-free" > /etc/apt/sources.list && \
    echo "deb-src http://mirrors.ustc.edu.cn/debian jessie main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/debian jessie-proposed-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.ustc.edu.cn/debian jessie-proposed-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.ustc.edu.cn/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 && \
    echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list && \
    export DEBIAN_FRONTEND='noninteractive' && apt-get update -y -qq && \
    apt-get install -y nginx ca-certificates gettext-base zip unzip && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

RUN sed -i -e"s/worker_processes  1/worker_processes 5/" /etc/nginx/nginx.conf && \
  sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf && \
  sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
