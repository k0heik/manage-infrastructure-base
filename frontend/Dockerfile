FROM node:20-alpine AS base
ENV NEXT_TELEMETRY_DISABLED=1
WORKDIR /app

FROM base AS deps
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci

FROM deps AS builder
COPY frontend/. .
RUN npm run build

FROM base AS runner
ENV NODE_ENV=production
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci --omit=dev
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./next.config.js
EXPOSE 3000
CMD ["npm", "run", "start"]
