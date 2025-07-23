# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: angerard <angerard@student.s19.be>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/23 12:18:37 by angerard          #+#    #+#              #
#    Updated: 2025/07/23 17:29:07 by angerard         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list \
    && sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list \
    && apt-get update -y \
    && apt-get install -y mariadb-server

COPY ./tools/maria-server.conf /etc/mysql/mariadb.conf.d/
COPY ./tools/init.sh /

VOLUME /secrets

CMD ["/init.sh"]
