FROM codeboy/ubuntu-test:v1
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
EXPOSE 9000