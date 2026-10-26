
# Stage 1: Build the TypeScript application
FROM node:22-alpine AS builder

WORKDIR /build

COPY package*.json ./
RUN npm ci

COPY tsconfig.json ./
COPY src ./src

RUN npm run build

# Stage 2: Production runtime
FROM node:22-alpine AS production

WORKDIR /cloud-api

COPY package*.json ./
RUN npm ci --omit=dev

COPY --from=builder /build/dist ./dist

EXPOSE 3000

USER node

CMD ["node", "dist/server.js"]