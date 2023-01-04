import gql from "graphql-tag";

export const ClientCoachRelationship = gql`
  "Represents broadcast message to selected users."
  type ClientCoachRelationship {
    coach: Coach
    user: User
    date_created: Date
    active: Boolean
  }
`;
