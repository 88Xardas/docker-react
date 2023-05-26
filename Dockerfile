# Block or phase 1 (build)
#"as builder" part means that from that FROM command on and underneath it, it's all going to be referred to as builder phase until the next FROM
FROM node:alpine as builder
WORKDIR '/app'

COPY package.json .
RUN npm install
COPY . .
# Creates the build folder. So the folder we really care about is /app/build
RUN npm run build

# Block or phase 2 (run), automatically starts after another FROM image statement
FROM nginx
# We want to copy our /app/build folder into this new nginx container. The --from means from another phase
# If we watch the nginx configuration on dockerhub we see that the build files (build folder) have to go to /usr/share/nginx/html
COPY --from=builder /app/build /usr/share/nginx/html