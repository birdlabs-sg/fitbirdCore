import gql from "graphql-tag";

export const ExcercisePerformance = gql`
  type GroupedExcerciseSets {
    date_completed: Date
    excercise_sets: [ExcerciseSet!]
  }
  type ExcercisePerformance {
    grouped_excercise_sets: [GroupedExcerciseSets!]
  }
`;
