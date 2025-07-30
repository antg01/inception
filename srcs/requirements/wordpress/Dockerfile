# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: angerard <angerard@student.s19.be>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/23 12:21:48 by angerard          #+#    #+#              #
#    Updated: 2025/07/23 17:38:41 by angerard         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list \
    && sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list \
    && apt update -y \
    && apt install -y php-fpm php-mysql curl netcat ca-certificates \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./tools/init.sh /
COPY ./tools/wp-config.php /

RUN chmod +x /init.sh

VOLUME /secrets

CMD ["/init.sh"]
