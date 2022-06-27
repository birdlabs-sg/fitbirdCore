"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Workout = void 0;
const { gql } = require('apollo-server');
exports.Workout = gql `
    "Represents a user. Contains meta-data specific to each user."
    type Workout {
        workout_id:      ID           
        date_scheduled:        String       
        date_completed:        String     
        performance_rating:        Float
        repetition_count_left:        Int
        user_id:    Int
        excercise_sets: [ExcerciseSet]
    }
`;
//# sourceMappingURL=workout.js.map