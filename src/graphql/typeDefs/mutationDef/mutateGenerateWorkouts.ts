const { gql } = require("apollo-server");

export const mutateGenerateWorkouts = gql`
  "Mutation to generate a set of workouts"
  type Mutation {
    generateWorkouts(no_of_workouts: Int!): [Workout!]
    regenerateWorkouts: [Workout!]
  }
`;
