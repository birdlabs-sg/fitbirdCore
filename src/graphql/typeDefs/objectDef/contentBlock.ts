import gql from "graphql-tag";

export const ContentBlock = gql`
  "Represents broadcast message to selected users."
  type ContentBlock {
    content_block_id: ID!
    content_block_type: ContentBlockType!
    title: String!
    description: String!
    video_url: String
  }
`;
