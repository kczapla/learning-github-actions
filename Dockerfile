FROM node:15.12-alpine as base

WORKDIR /app
COPY . .
RUN npm ci

FROM base as style
RUN npx prettier --check .

FROM base as lint
RUN npx eslint .

FROM base as tests
RUN npx jest src/

FROM node:15.12-alpine as prod

COPY . .
RUN npm ci --production
CMD ["npm", "run", "start"]