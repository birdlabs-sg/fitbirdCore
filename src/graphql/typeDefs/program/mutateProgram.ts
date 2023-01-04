import gql from "graphql-tag";
export const mutateProgram = gql`
  type mutateProgramResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    program: Program
  }

  input workoutInput {
    dayOfWeek: DayOfWeek!
    workout_name: String!
    excercise_set_groups: [excerciseSetGroupInput!]!
    date_scheduled: Date
    date_closed: Date
  }

  type Mutation {
    "[PROTECTED] Creates a program object."
    createProgram(
      coach_id: ID
      user_id: ID!
      program_type: ProgramType!
      workoutsInput: [workoutInput!]!
    ): mutateProgramResponse!
    "[PROTECTED] Deletes a program object."
    deleteProgram(
      program_id: ID!
      user_id: ID!
      coach_id: ID
    ): mutateProgramResponse!

    "[PROTECTED] Updates a program object."
    updateProgram(
      program_id: ID!
      program_type: ProgramType
      coach_id: ID
      is_active: Boolean
      ending_date: Date
      starting_date: Date
    ): mutateProgramResponse!

    "[PROTECTED] ends an active program object (ONLY COACH)."
    endActiveProgram(user_id: ID!): mutateProgramResponse!
  }
`;
