# ---------------------------
# 1. BUILD STAGE
# ---------------------------
FROM node:18-alpine AS builder

WORKDIR /reddit-clone

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Build for production
RUN npm run build


# ---------------------------
# 2. RUN STAGE
# ---------------------------
FROM node:18-alpine AS runner

WORKDIR /reddit-clone

# Install only production dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Copy only the built app + public folder
COPY --from=builder /reddit-clone/.next ./.next
COPY --from=builder /reddit-clone/public ./public
COPY --from=builder /reddit-clone/node_modules ./node_modules
COPY --from=builder /reddit-clone/package.json ./package.json

EXPOSE 3000

CMD ["npm", "run", "start"]
