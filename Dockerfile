FROM codeboy/ubuntu-test:v1
RUN sh /etc/init.d/nginx.sh
EXPOSE 9000