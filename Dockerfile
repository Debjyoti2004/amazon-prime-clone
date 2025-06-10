# Stage 1:
FROM node:16-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --only=production
COPY . .

# Stage 2: 
FROM node:16-alpine
WORKDIR /app
COPY --from=build /app /app
EXPOSE 3000

CMD ["npm", "start"]

