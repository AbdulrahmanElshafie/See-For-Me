FROM ubuntu:latest
LABEL authors="sabdo"

ENTRYPOINT ["top", "-b"]