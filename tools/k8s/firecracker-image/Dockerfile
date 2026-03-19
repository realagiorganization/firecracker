FROM alpine:3.20

RUN adduser -D -u 10001 fc

COPY firecracker /usr/local/bin/firecracker
COPY jailer /usr/local/bin/jailer
COPY seccompiler-bin /usr/local/bin/seccompiler-bin
COPY rebase-snap /usr/local/bin/rebase-snap
COPY cpu-template-helper /usr/local/bin/cpu-template-helper
COPY snapshot-editor /usr/local/bin/snapshot-editor

USER 10001

ENTRYPOINT ["/usr/local/bin/firecracker"]
