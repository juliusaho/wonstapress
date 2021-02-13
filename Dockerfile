FROM bitnami/wordpress
LABEL maintainer "Bitnami <containers@bitnami.com>"

USER 0
COPY config-wordpress.sh /config-wordpress.sh
ENTRYPOINT ["/config-wordpress.sh"]
USER 1001