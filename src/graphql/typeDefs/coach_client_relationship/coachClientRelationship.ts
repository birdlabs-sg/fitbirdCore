import gql from "graphql-tag";

export const CoachClientRelationship = gql`
  "Represents broadcast message to selected users."
  type CoachClientRelationship {
    coach: Coach
    user: User
    date_created: Date
    active: Boolean
  }
`;
