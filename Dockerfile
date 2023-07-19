FROM alpine:latest

SHELL ["/bin/ash", "-c"]
ARG ssh_pub_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQp2OLLf8GD7rG5IAuE2rQka0sTLJlwm2cSBpYF4yKUUrBg0igZ+wwmv0AER0OyKg95/l/2o2lDHcOWr/uzY202HJoHDiSZMsTDPqek8CDk9SjeASX2bYXP1+cHq0V4pX8ehXOGhWcwIfo6d9rDDiVStv/S4rxSV6PP+vDmI6Om5dndd5LbUOl5blNhEkOOGDREcMyogYHBWIEqMA5XTvJLKKVXKRIBf/i+GsRHgvjLoUGSHGoaBWsHQ7B7Wymn9Qb4e+TG6MiN1M5skXJ+c4wbfQESlt4yOpbSI2AxB9len2UKwkkAAMqy38DGcWq3HlEp+FyTgvRy2N0sIugKK0NBOiPZIvgKeMMHJV+aNZaV62iXTU71IrI7H3xEakRGjI/moJ9IJfkdqwx6koDEGMboKsmGx10t3lvC7Hw01gH6/og1OiNp6HQ/woSpfcd3u2UdaQYs0Hk/n+cLzJgUWk9dzGO53bhd/Re85Mb4x9YNqF1OJzTlLO1F3YePWI64vWrj7A7mNli2aOsGQxY+44No8095LdGtay+EJga0jKt/Y7ZS0CzNZW74cDtmAzl+AUMBvh6q2tYuGhMbxOiKOM7fMTeUHSjV5qSe43OEOAkexdiXgWvzVq+VuGgNZC2eJJ0dHOi5aNS5gpcbQ93GiHmb5KLcOjTZXI6Esh15llZQQ== admin@ioreo.eu.org"

RUN mkdir -p /root/.ssh \
    && chmod 0700 /root/.ssh \
    && echo "$ssh_pub_key" > /root/.ssh/authorized_keys \
    && apk update \
    && apk add openrc openssh \
    && ssh-keygen -A \
    && echo -e "PasswordAuthentication no" >> /etc/ssh/sshd_config \
    && echo -e "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && rc-update add sshd \
    && mkdir -p /run/openrc \
    && touch /run/openrc/softlevel \
    && rc-status

EXPOSE 22
ENTRYPOINT ["sh", "-c", "rc-service sshd start && /bin/ash"]