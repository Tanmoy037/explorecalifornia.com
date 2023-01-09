FROM nginx:alpine
LABEL maintainer "Tanmoy Santra" <tanmoysantra67@gmail.com>
COPY ./website /website
COPY ./nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
