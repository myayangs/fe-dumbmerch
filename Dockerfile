FROM node:16-alpine as staging
WORKDIR /app
COPY . .
RUN npm install

FROM node:16-alpine as production
WORKDIR /app
COPY --from=staging /app /app
EXPOSE 3000
CMD [ "npm", "start"]
