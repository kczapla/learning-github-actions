FROM node:15.12-alpine as base

WORKDIR /app
COPY . .
RUN npm ci

FROM base as lint
RUN npm run lint

FROM base as tests
RUN npm run test

FROM node:15.12-alpine as prod

COPY . .
RUN npm ci --production
CMD ["npm", "run", "start"]