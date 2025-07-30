# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: angerard <angerard@student.s19.be>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/23 12:18:37 by angerard          #+#    #+#              #
#    Updated: 2025/07/23 17:38:20 by angerard         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM mariadb:10.5

VOLUME /secrets

# Optionnel : script d'init SQL exécuté si la DB est vide
# COPY ./tools/init.sql /docker-entrypoint-initdb.d/init.sql

COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh
ENTRYPOINT ["/init.sh"]
