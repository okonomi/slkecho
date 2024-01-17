FROM alpine:3.19.0

RUN apk add --no-cache ruby
RUN gem install slkecho -v 2.0.1

ENTRYPOINT [ "slkecho" ]
