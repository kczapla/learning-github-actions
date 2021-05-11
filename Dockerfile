ARG NODE_VERSION

FROM node:${NODE_VERSION}-alpine as base
WORKDIR /app

FROM base as dependencies
COPY . .
RUN npm ci --production
RUN cp -R node_modules /prod_node_modules
RUN npm install

FROM dependencies as tests
RUN npm run style && npm run lint && npm run tests

FROM dependencies as codecov
RUN npx jest --coverage --coverageThreshold 100 src/

FROM dependencies as prod
COPY --from=dependencies /prod_node_modules ./node_modules
COPY . .
CMD ["npm", "run", "start"]