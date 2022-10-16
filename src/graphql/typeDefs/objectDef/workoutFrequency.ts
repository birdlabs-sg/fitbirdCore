import gql from "graphql-tag";

export const WorkoutFrequency = gql`
  "Represents a user. Contains meta-data specific to each user."
  type WorkoutFrequency {
    workout_count: Int!
    week_identifier: String
  }
`;
