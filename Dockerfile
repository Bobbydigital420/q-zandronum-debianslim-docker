# ==========================================
# STAGE 1: Fast Cross-Compilation (Native Speed)
# ==========================================
FROM --platform=$BUILDPLATFORM debian:stable-slim AS box64-builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git cmake build-essential python3 ca-certificates \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/ptitSeb/box64.git /box64 \
    && mkdir /box64/build

WORKDIR /box64/build
RUN cmake .. \
    -DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
    -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc -DCMAKE_CXX_COMPILER=aarch64-linux-gnu-g++ \
    -DARM64_DYNAREC=ON -DCMAKE_BUILD_TYPE=Release \
    && make -j$(nproc) && make install DESTDIR=/tmp/box64-install

# ==========================================
# STAGE 2: Base Runtime (Common Setup)
# ==========================================
FROM debian:stable-slim AS base-runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
    libsdl1.2-compat-shim wget ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash zandronum
ADD zandronum.ini /home/zandronum/.config/zandronum/

RUN mkdir -p /home/zandronum/qzandronum \
    && wget -qO- https://github.com/IgeNiaI/Q-Zandronum/releases/download/1.4.22/Q-Zandronum_1.4.22_Linux_amd64.tar.gz | tar -xzf - -C /home/zandronum/qzandronum \
    && chown -R zandronum:zandronum /home/zandronum

USER zandronum
WORKDIR /home/zandronum
ENV EXTRA_ARGS=""

# ==========================================
# STAGE 3a: Final AMD64 Block
# ==========================================
FROM base-runtime AS final-amd64
ENTRYPOINT ["sh", "-c", "exec /home/zandronum/qzandronum/q-zandronum-server $EXTRA_ARGS \"$@\"", "--"]

# ==========================================
# STAGE 3b: Final ARM64 Block
# ==========================================
FROM base-runtime AS final-arm64
COPY --from=box64-builder /tmp/box64-install /
ENTRYPOINT ["sh", "-c", "exec box64 /home/zandronum/qzandronum/q-zandronum-server $EXTRA_ARGS \"$@\"", "--"]

# ==========================================
# STAGE 4: Automated Router
# ==========================================
FROM final-$TARGETARCH
