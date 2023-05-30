'use strict';
const axios = require("axios")

// function delay(time) {
//   return new Promise(resolve => setTimeout(resolve, time));
// }

module.exports.handler = async (event) => {
  // await delay(15000)
  // console.log(event.Records)

  for (const record of event.Records) {

    const body = JSON.parse(record.body)
    const payload = {
      MessageGroupId: "stock-arrival-group",
      MessageAttributeProductId: body.MessageAttributes.ProductId.Value,
      MessageAttributeProductCnt: 5,
      MessageAttributeFactoryId: body.MessageAttributes.FactoryId.Value,
      MessageAttributeRequester: "sanghyup",
      CallbackUrl: process.env.increase_ENDPOINT
    }


console.log(payload)

axios.post('http://project3-factory.coz-devops.click/api/manufactures', payload)
.then(function (response) {
  console.log(response);
})
.catch(function (error) {
  console.log(error);
});
}
};
