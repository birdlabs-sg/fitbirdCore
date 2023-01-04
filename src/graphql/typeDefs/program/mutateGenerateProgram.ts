import gql from "graphql-tag";

export const mutateGenerateWorkouts = gql`
  "Mutation to generate a set of workouts"
  type Mutation {
    generateProgram(days_of_week: [DayOfWeek!]!): Program!
    refreshProgram(program_id: ID!): Program!
  }
`;
