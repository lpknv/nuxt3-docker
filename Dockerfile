FROM node:20.6.1-alpine AS base

# Install dependencies only when needed
FROM base AS deps

# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed
RUN apk add --no-cache libc6-compat

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Rebuild the source code only when needed
FROM base AS builder

WORKDIR /app

COPY . .
COPY --from=deps /app/node_modules ./node_modules

RUN npm run build

# Production image, copy all the files and run nuxt
FROM base AS runner

RUN apk add --no-cache dumb-init

WORKDIR /app/.output

ENV NODE_ENV=production \
  HOSTNAME="0.0.0.0" \
  PORT=3000

RUN addgroup --system --gid 1001 nodejs && \
  adduser --system --no-create-home --uid 1001 nuxtjs

COPY --from=builder --chown=nuxtjs:nodejs /app/.output .

USER nuxtjs

EXPOSE ${PORT}

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["node", "server/index.mjs"]
