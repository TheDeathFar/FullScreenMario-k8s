FROM nginx:1.25.3-alpine

ENV FSM_URL https://github.com/craq2017/FullScreenMario
ENV FSM_DIR /usr/share/nginx/html/fsm

RUN apk update && \
    apk add git

RUN git clone ${FSM_URL} ${FSM_DIR}
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
