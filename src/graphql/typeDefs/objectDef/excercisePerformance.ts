const { gql } = require("apollo-server");

export const ExcercisePerformance = gql`
  type GroupedExcerciseSets {
    date_completed: String
    excercise_sets: [ExcerciseSet]
  }
  type ExcercisePerformance {
    grouped_excercise_sets: [GroupedExcerciseSets]
  }
`;
