'use strict';
const axios = require("axios")

function delay(time) {
  return new Promise(resolve => setTimeout(resolve, time));
}

module.exports.handler = async (event) => {
  await delay(15000)
  console.log(event.Records)
}

