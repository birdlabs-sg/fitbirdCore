import gql from "graphql-tag";

export const Challenge = gql`
  "Represents a challenge."
  type Challenge {
    challenge_id: ID!
    workouts: [Workout!]
    user_id: ID!
    is_active: Boolean
    presetPreset_id: ID!
    completion_status: Boolean
    completion_date: Date
  }
`;
