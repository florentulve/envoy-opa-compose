FROM registry.access.redhat.com/ubi8/ubi:8.7

RUN dnf module enable -y nodejs:18 && dnf install -y nodejs && dnf clean all

WORKDIR /usr/share/app

COPY . ./

RUN npm install && npm run build

EXPOSE 3000

ENTRYPOINT ["node", "dist/main"]
