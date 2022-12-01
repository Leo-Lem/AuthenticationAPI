FROM swift
WORKDIR /app
COPY . .

#RUN apt-get update

RUN swift package clean
RUN swift build -c release

RUN mkdir /app/bin
RUN mv `swift build --show-bin-path -c release` /app/bin

EXPOSE 8080
ENTRYPOINT ./bin/release/AuthenticationAPI serve --env local --hostname 0.0.0.0
