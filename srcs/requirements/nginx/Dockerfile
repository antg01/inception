# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: angerard <angerard@student.s19.be>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/23 12:19:39 by angerard          #+#    #+#              #
#    Updated: 2025/07/23 12:40:44 by angerard         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN apt -y update \
    && apt install -y nginx openssl

COPY ./tools/init.sh /

VOLUME /secrets

CMD ["/init.sh"]

