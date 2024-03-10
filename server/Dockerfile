FROM oven/bun:1

WORKDIR /app

COPY ./package.json package.json
RUN bun install

COPY . .
CMD [ "bun", "run", "index.ts" ]

