FROM node:20-alpine

WORKDIR /app
COPY server.js /app/server.js

EXPOSE 3000
EXPOSE 9229

CMD ["node", "--inspect=0.0.0.0:9229", "server.js"]
