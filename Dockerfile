FROM nginx:latest
ADD ./html /usr/share/nginx/html
ADD ./status.conf /etc/nginx/conf.d/status.conf
