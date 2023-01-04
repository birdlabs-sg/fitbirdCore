import gql from "graphql-tag";
export const mutateProgram = gql`
  type mutateProgramResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    program: Program
  }

  input workoutInput {
    program_id: ID!
    dayOfWeek: DayOfWeek!
    workout_name: String!
    excercise_set_groups: [excerciseSetGroupInput!]!
    date_scheduled: Date
    date_closed: Date
  }

  type Mutation {
    "[PROTECTED] Creates a program object (ONLY COACH)."
    createProgram(
      coach_id: ID!
      user_id: ID!
      workoutsInput: [workoutInput!]!
    ): mutateProgramResponse

    "[PROTECTED] ends an active program object (ONLY COACH)."
    endActiveProgram(user_id: ID!): mutateProgramResponse
  }
`;
