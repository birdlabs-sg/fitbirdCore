const { gql } = require("apollo-server");

export const WorkoutGroup = gql`
  "Represents a user. Contains meta-data specific to each user."
  type WorkoutGroup {
    workout_group_id: ID!
    workout_group_name: String!
    life_span: Int!
  }
`;
