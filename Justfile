set dotenv-load := true
set export := true
set shell := ["bash", "-cu"]

ROOT := justfile_directory()
ENVIRONMENT := env_var_or_default("ENVIRONMENT", "dev")
AWS_PROFILE := env_var_or_default("AWS_PROFILE", "default")

TF_INTERACTIVE_FLAG := `test -t 0 && echo -it || true`
TF_LOCAL_HOST_UID := `id -u`
TF_DOCKER_SOCKET_MOUNT := `if [ -S /run/user/{{TF_LOCAL_HOST_UID}}/docker.sock ]; then echo "-v /run/user/{{TF_LOCAL_HOST_UID}}/docker.sock:/var/run/docker.sock:ro"; else echo "-v /var/run/docker.sock:/var/run/docker.sock"; fi`
TF_SSH_MOUNTS := "-v ~/.ssh:/root/.ssh:ro -v ~/.ssh/known_hosts:/root/.ssh/known_hosts:ro"
TF_AWS_MOUNTS := "-v ~/.aws:/root/.aws"
TF_TFLINT_CACHE_MOUNT := "-v ~/.tflint.d:/root/.tflint.d"
TF_IMAGE := "terraform:latest"
TF_RUN_BASE := "docker run --rm " + TF_INTERACTIVE_FLAG + " -v " + ROOT + ":/work -w /work/infrastructure " + TF_DOCKER_SOCKET_MOUNT + " " + TF_SSH_MOUNTS + " " + TF_AWS_MOUNTS
TF_RUN := TF_RUN_BASE + " --env-file .env " + TF_IMAGE
TF_TFLINT_RUN := TF_RUN_BASE + " " + TF_TFLINT_CACHE_MOUNT + " --entrypoint tflint " + TF_IMAGE

terraform-docker-build:
  DOCKER_BUILDKIT=1 docker build infrastructure -t {{TF_IMAGE}}

terraform-init-base env=ENVIRONMENT flags="": terraform-docker-build
  {{TF_RUN}} init {{flags}} -backend-config=envs/{{env}}/backend.conf

terraform-init env=ENVIRONMENT:
  @just terraform-init-base {{env}}

terraform-upgrade env=ENVIRONMENT:
  @just terraform-init-base {{env}} "-upgrade"

terraform-reconfigure env=ENVIRONMENT:
  @just terraform-init-base {{env}} "-reconfigure"

terraform-check env=ENVIRONMENT:
  @just terraform-init {{env}}
  {{TF_RUN}} fmt -check -recursive -diff
  {{TF_RUN}} validate
  {{TF_TFLINT_RUN}} --init
  {{TF_TFLINT_RUN}} -f compact

terraform-format env=ENVIRONMENT:
  @just terraform-init {{env}}
  {{TF_RUN}} fmt -recursive

terraform-fix env=ENVIRONMENT:
  @just terraform-format {{env}}
  {{TF_TFLINT_RUN}} --init
  {{TF_TFLINT_RUN}} --fix -f compact

terraform-all env=ENVIRONMENT:
  @just terraform-fix {{env}}
  @just terraform-check {{env}}

terraform-base command env=ENVIRONMENT:
  @just terraform-init {{env}}
  {{TF_RUN}} {{command}} -var-file=envs/{{env}}/terraform.tfvars

terraform-plan env=ENVIRONMENT:
  @just terraform-base "plan" {{env}}

terraform-apply env=ENVIRONMENT apply_flags="":
  @just terraform-base "apply {{apply_flags}}" {{env}}

terraform-destroy env=ENVIRONMENT:
  @just terraform-base "destroy" {{env}}

terraform-deploy-dev apply_flags="-auto-approve":
  @just terraform-apply dev "{{apply_flags}}"

terraform-destroy-dev:
  @just terraform-destroy dev

terraform-deploy-prod apply_flags="":
  @just terraform-apply prod "{{apply_flags}}"

terraform-destroy-prod:
  @just terraform-destroy prod

terraform-clean:
  find . -type d -name '.terraform' -exec rm -rf {} +
  find . -type f -name '.terraform.lock.hcl' -delete

sso-login:
  aws sso login --profile {{AWS_PROFILE}}
