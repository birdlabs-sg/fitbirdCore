import axios from "axios";

export const report = async (content: string) => {
  if (
    process.env.NODE_ENV == "production" &&
    process.env.SLACK_REPORT_WEBHOOK_URL
  ) {
    axios({
      method: "post",
      url: process.env.SLACK_REPORT_WEBHOOK_URL,
      data: {
        text: content,
      },
    });
  }
};
