FROM registry.access.redhat.com/ubi8/ubi:8.7

RUN dnf module enable -y nodejs:18 && dnf install -y --setopt=install_weak_deps=False nodejs && dnf clean all

WORKDIR /usr/share/app

COPY ./app .

EXPOSE 3000

ENTRYPOINT ["node", "dist/main"]
