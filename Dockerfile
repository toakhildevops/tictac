# build stage

FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# production stage

FROM nginx:alpine

# upgrade Alpine packages to fix CVEs (like libexpat)
RUN apk update && apk upgrade --no-cache

COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]