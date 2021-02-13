FROM bitnami/wordpress
LABEL maintainer "Bitnami <containers@bitnami.com>"
USER root
RUN wp option update blogdescription "Some random blog description" --allow-root ;exit 0