FROM bitnami/wordpress
LABEL maintainer "Bitnami <containers@bitnami.com>"

CMD wp option update blogdescription "Some random blog description"