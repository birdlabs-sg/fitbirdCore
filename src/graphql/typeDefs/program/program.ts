import gql from "graphql-tag";

export const Program = gql`
  "Represents programs for coaches."
  type Program {
    program_type: ProgramType
    program_id: ID!
    workouts: [Workout!]
    coach: Coach
    user: User!
    is_active: Boolean
    ending_date: Date
    starting_date: Date!
  }
`;
