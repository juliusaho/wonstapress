FROM bitnami/wordpress
LABEL maintainer "Bitnami <containers@bitnami.com>"

USER 0
RUN rm -rf /opt/bitnami/wordpress/wp-content
COPY ./wp-content /opt/bitnami/wordpress/wp-content
ADD openssh.sh /
RUN chmod +x ./openssh.sh
USER root
