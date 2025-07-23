# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: angerard <angerard@student.s19.be>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/23 12:19:39 by angerard          #+#    #+#              #
#    Updated: 2025/07/23 17:29:20 by angerard         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list \
    && sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list \
    && apt update -y \
    && apt install -y nginx openssl

COPY ./tools/init.sh /

VOLUME /secrets

CMD ["/init.sh"]
