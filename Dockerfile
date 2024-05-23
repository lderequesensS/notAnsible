FROM fedora:40
ARG TAGS
RUN adduser --uid 1000 leo --user-group --create-home
RUN usermod -aG wheel leo
RUN echo 'leo:test' | chpasswd
USER leo
WORKDIR /home/leo
COPY . .
CMD ["sh"]
