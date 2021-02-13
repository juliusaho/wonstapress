FROM bitnami/wordpress
LABEL maintainer "Bitnami <containers@bitnami.com>"
USER root
COPY config-wordpress.sh /config-wordpress.sh
USER 1001