FROM nginx:latest AS build 
COPY ./html /html
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

FROM nginx:latest
COPY --from=build /html /usr/share/nginx/html
COPY --from=build /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf


