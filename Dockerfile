FROM python:3.11.8

RUN apt update -y \
 && apt install -y tree \
 && pip install dvc

RUN git config --global user.name me \
 && git config --global user.email me@me.com \
 && git config --global init.defaultBranch main

WORKDIR src
COPY dvc-test.sh ./

ENTRYPOINT ["./dvc-test.sh"]
