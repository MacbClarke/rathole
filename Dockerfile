FROM rust:alpine AS builder
RUN apk add --no-cache build-base musl-dev openssl-dev openssl-libs-static perl pkgconfig
WORKDIR /home/rust/src
COPY . .
ARG FEATURES
ARG TARGET=x86_64-unknown-linux-musl
ENV OPENSSL_STATIC=1
RUN rustup target add ${TARGET}
RUN cargo build --locked --release --target ${TARGET} --features ${FEATURES:-default}
RUN mkdir -p build-out/
RUN cp target/${TARGET}/release/rathole build-out/



FROM alpine:3.21
WORKDIR /app
COPY --from=builder /home/rust/src/build-out/rathole .
USER 1000:1000
ENTRYPOINT ["./rathole"]
