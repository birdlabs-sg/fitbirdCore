// Per exercise: 1rm (x-axis - workout date),
// Total volume (per week) CONSIDER making it per session? The base is consistent, can superimpose graphs
// % of exercises tried
import gql from "graphql-tag";

export const Analytics = gql`
  type ExerciseOneRepMaxDataPoint {
    exercise_name: String
    estimated_one_rep_max_value: Float
    date_completed: Date
  }

  type ExerciseTotalVolumeDataPoint {
    exercise_name: String
    exercise_total_volume: Float
    date_completed: Date
  }

  type WorkoutAverageRPEDataPoint {
    average_rpe_value: Float
    date_completed: Date
  }
`;
