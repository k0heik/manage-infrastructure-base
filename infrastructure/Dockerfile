FROM hashicorp/terraform:latest

ARG TARGETARCH

RUN apk add --no-cache bash curl unzip python3 py3-pip git ca-certificates \
  && python3 -m pip install --no-cache-dir --upgrade pip --break-system-packages \
  && case "$TARGETARCH" in \
       amd64) TFLINT_ARCH=amd64 ;; \
       arm64) TFLINT_ARCH=arm64 ;; \
       *) echo "unsupported arch: $TARGETARCH"; exit 1 ;; \
     esac \
  && curl -sSLo /tmp/tflint.zip "https://github.com/terraform-linters/tflint/releases/latest/download/tflint_linux_${TFLINT_ARCH}.zip" \
  && unzip /tmp/tflint.zip -d /usr/local/bin \
  && rm /tmp/tflint.zip
