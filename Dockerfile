ARG FROM=ubuntu:jammy
FROM ${FROM}

ENV URL=""
ENV TOKEN=""

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y curl && \
    cd / && \
    mkdir runner && \
    cd runner && \
    curl -o actions-runner-linux-x64-2.299.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.299.1/actions-runner-linux-x64-2.299.1.tar.gz && \
    echo "147c14700c6cb997421b9a239c012197f11ea9854cd901ee88ead6fe73a72c74  actions-runner-linux-x64-2.299.1.tar.gz" | sha256sum -c && \
    tar xzf ./actions-runner-linux-x64-2.299.1.tar.gz && \
    ./bin/installdependencies.sh && \
    curl -fsSL https://get.docker.com -o- | sh && \
    rm -rf /var/lib/apt/lists/* && \
    DEBIAN_FRONTEND=noninteractive apt-get clean -y

ENTRYPOINT RUNNER_ALLOW_RUNASROOT=1 /runner/config.sh --url ${URL} --token ${TOKEN} --unattended && RUNNER_ALLOW_RUNASROOT=1 /runner/run.sh
