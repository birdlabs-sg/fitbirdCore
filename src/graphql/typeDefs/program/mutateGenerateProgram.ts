import gql from "graphql-tag";

export const mutateGenerateWorkouts = gql`
  "Mutation to generate a set of workouts"
  type Mutation {
    generateProgram(days_of_week: [DayOfWeek!]!): Program!
    refreshProgram(program_id: ID!): Program!
    deleteProgram(program_id: ID!): Program!
    updateProgram(
      program_id: ID!
      program_type: ProgramType
      coach_id: ID
      is_active: Boolean
      ending_date: Date
      starting_date: Date
    ): Program!
  }
`;
