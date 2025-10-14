# simple node/nginx sample or use nginx image directly
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
