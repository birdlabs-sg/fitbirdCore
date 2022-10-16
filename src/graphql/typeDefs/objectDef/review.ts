import gql from "graphql-tag";

export const Review = gql`
  "Represents broadcast message to selected users."
  type Review {
    review_id: ID!
    rating: String!
    content: String!
  }
`;
