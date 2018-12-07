# Stage 1 - the build process
FROM node:9.9.0 as build-deps
RUN npm install -g typescript

ARG nodeEnv=production

# Best practise: https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#environment-variables
ENV NODE_ENV=$nodeEnv

WORKDIR /app-build

COPY package.json yarn.lock tsconfig.json ./

# This will skip dev dependencies if NODE_ENV=production.
RUN yarn install

# Build inside docker
COPY ./src ./src
RUN yarn build

# Stage 2 - the production environment
FROM node:9.9.0
COPY --from=build-deps /app-build/package.json /app/package.json
COPY --from=build-deps /app-build/yarn.lock /app/yarn.lock
COPY --from=build-deps /app-build/lib /app/lib
COPY --from=build-deps /app-build/node_modules /app/node_modules

WORKDIR /app

EXPOSE 3000

# Best practise: https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#non-root-user
USER node

# Best practise: https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md#environment-variables
CMD [ "npm", "start" ]

# Test docker on localhost
# docker build . -t node-app
# docker run -p 80:3000 node-app