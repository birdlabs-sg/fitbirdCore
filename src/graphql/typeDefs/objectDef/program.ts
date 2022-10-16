import gql from "graphql-tag";

export const Program = gql`
  "Represents programs for coaches."
  type Program {
    program_id: ID!
    user_id: ID!
    coach_id: ID!
    workouts: [Workout!]
    is_active: Boolean
  }
`;
