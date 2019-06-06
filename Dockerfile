FROM nginx:latest
ADD ./html /usr/share/nginx/html
ADD ./nginx/default.conf /etc/nginx/conf.d/default.conf

