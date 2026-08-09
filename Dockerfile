FROM debian:stable-slim

# 1. Install system dependencies cleanly
RUN apt update && apt install -y --no-install-recommends \
    libsdl1.2-compat-shim \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. Setup standard user and home directory structures
RUN useradd -ms /bin/bash zandronum
ADD zandronum.ini /home/zandronum/.config/zandronum/

# 3. Single-layer fetch, extract, and immediate purge
RUN mkdir -p /home/zandronum/qzandronum \
    && wget -qO- https://github.com/IgeNiaI/Q-Zandronum/releases/download/1.4.22/Q-Zandronum_1.4.22_Linux_amd64.tar.gz | tar -xzf - -C /home/zandronum/qzandronum \
    && chown -R zandronum:zandronum /home/zandronum

# 4. Switch context down to execution user privileges
USER zandronum
WORKDIR /home/zandronum

# 5. Set up the Environment Variable for Unraid UI
ENV EXTRA_ARGS=""

# 6. Execute via shell string so variables parse cleanly
ENTRYPOINT ["sh", "-c", "exec /home/zandronum/qzandronum/q-zandronum-server $EXTRA_ARGS \"$@\"", "--"]
