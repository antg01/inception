# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: angerard <angerard@student.s19.be>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/23 12:21:48 by angerard          #+#    #+#              #
#    Updated: 2025/07/23 12:29:34 by angerard         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN apt update -y

RUN apt install -y php-fpm php-mysql curl

COPY ./tools/script.sh /
COPY ./tools/wp-config.php /

VOLUME /secrets

CMD ["/script.sh"]

