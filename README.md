# python-nextjs-template

Monorepo template for a generic product stack using:
- Next.js (frontend)
- Python (backend, uv)
- AWS + Terraform (infrastructure)

## Structure
- `frontend/` Next.js app
- `backend/` Python API (FastAPI)
- `infrastructure/` Terraform (AWS)

## Quick start

Prerequisite:
- just
- Python 3.12
- uv
- Node.js + npm
- Docker
- AWS credentials (for Terraform deploy/validate)
- Create `.env` from `.env.sample`

Install just first (example):
```bash
brew install just
```

### Frontend
```bash
cd frontend
just install
just dev
```

### Backend
```bash
cd backend
just install
just run
```

### Infrastructure (Terraform)
```bash
# build terraform docker image (once)
just terraform-docker-build

# validate + lint
just terraform-check

# deploy
just terraform-deploy-dev
```

### Manual deploy with AWS SSO / IAM Identity Center
```bash
# create SSO profile (once)
# profile name: dev
aws configure sso

# set profile in .env (recommended)
# AWS_PROFILE=dev

# login and deploy (dev example)
just sso-login
just terraform-deploy-dev
```

Notes:
- Terraform runs in a container and mounts `~/.aws`, so SSO cache is available inside the container.
- If you prefer, you can export `AWS_PROFILE` in your shell instead of `.env`.

## CI/CD
GitHub Actions workflows are in `.github/workflows`.
- `ci.yml` runs lint/test for frontend & backend, and runs Terraform validate + lint
- `cd.yml` deploys Terraform to dev/prod based on branch

## Environment variables
Root `.env.sample` is used by Terraform and CI. Copy to `.env` and fill in values.
