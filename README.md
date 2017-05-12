# Embed.rocks integration example (with a templating engine)

An example Node.js app for Embed.rocks. Use this for starting your own implementation.

Install by: 
  - cloning this repository. 
  - `npm install`
  - `npm start`
  - Then point your browser to http://127.0.0.1:3000

## What this contains

This version of our integration example is made with a (Mustache-like) templating engine. The other version is with plain JavaScript and can be found [here](https://github.com/embed-rocks/embed-example). You can use whichever suits you better, or even both.

In `views/card.html` file you will find the template that renders card data into html. You can use that as a basis for your own implementation.

In `styles/card.style` you will find the Stylus stylesheet code for cards. 

In `src/app/components/card.coffee` you will find the CoffeeScript source code for handling the different Card functionalities.

## Configuring

Set your API key in `src/server/route.coffee`.

Note that in this example app fetches the embed data on the server site, never exposing the api key to the public. This is how it should be done - securely on the server side, not directly on the client side.

## Safe images

If you want to use a "safe domain" (for safe images), set it in `src/app/components/card.coffee`. Remember to add a trailing slash into it. For example `//safe.mydomain.com/` (for both http and https). You need to have an NGINX setup for this. See the example [nginx.conf](https://gist.github.com/ile/ef57487dc556ef43d694863224a2f02f).

## About us

Brought to you by Embed.rocks, the [Embed.ly alternative](https://embed.rocks/).
