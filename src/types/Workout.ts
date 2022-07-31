import { ExcerciseSetGroup } from "@prisma/client";

interface ExcerciseMap {
  excercise_name: String;
  excercise_sets: ExcerciseSet[];
}

interface Workout {
  workout_id: String;
  workout_name: String;
  life_span: number;
  order_index: number;
  date_scheduled: String;
  date_completed: String;
  performance_rating: number;
  excercise_group_sets: ExcerciseSetGroup[];
}
