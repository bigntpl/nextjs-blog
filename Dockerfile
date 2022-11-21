FROM node:14 as dependencies
WORKDIR /nextjs-blog
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

FROM node:14 as builder
WORKDIR /nextjs-blog
COPY . .
COPY --from=dependencies /nextjs-blog/node_modules ./node_modules
RUN yarn build

FROM node:14 as runner
WORKDIR /nextjs-blog
ENV NODE_ENV production
# If you are using a custom next.config.js file, uncomment this line.
# COPY --from=builder /nextjs-blog/next.config.js ./
COPY --from=builder /nextjs-blog/public ./public
COPY --from=builder /nextjs-blog/pages ./pages
COPY --from=builder /nextjs-blog/.next ./.next
COPY --from=builder /nextjs-blog/node_modules ./node_modules
COPY --from=builder /nextjs-blog/package.json ./package.json

EXPOSE 3000
CMD ["yarn", "start"]