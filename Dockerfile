FROM bitnami/wordpress
LABEL maintainer "Bitnami <containers@bitnami.com>"

USER 0
COPY config-wordpress.sh /config-wordpress.sh
RUN bash -c 'echo -e test1'
RUN bash config-wordpress.sh; exit 0
RUN bash -c 'echo -e test2'
USER 1001