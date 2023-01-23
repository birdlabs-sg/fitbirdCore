import axios from "axios";

export type block = {
  type: string;
  text: block | string;
};

export const report = async (content: string, blocks?: block[]) => {
  if (
    process.env.NODE_ENV == "production" &&
    process.env.SLACK_REPORT_WEBHOOK_URL
  ) {
    axios({
      method: "post",
      url: process.env.SLACK_REPORT_WEBHOOK_URL,
      data: {
        text: content,
        ...(blocks != undefined && { blocks: blocks }),
      },
    });
  }
};
