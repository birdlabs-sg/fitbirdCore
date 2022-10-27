export async function report(message: string) {
  console.log(process.env.NODE_ENV);
  if (process.env.NODE_ENV == "development") {
    return;
  }
  const https = require("https");
  const data = JSON.stringify({
    text: message,
  });

  var request = require("request");
  var options = {
    url: process.env.SLACK_REPORT_WEBHOOK_URL,
    method: "POST",
    body: data,
  };

  function callback(error: any, response: any, body: string) {
    if (!error && response.statusCode == 200) {
      console.log(body);
    } else {
      console.log(error, response.statusCode);
    }
  }

  request(options, callback);
}
