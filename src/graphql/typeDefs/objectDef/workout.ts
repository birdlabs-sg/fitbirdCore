const { gql } = require('apollo-server');


export const Workout = gql`
    "Represents a user. Contains meta-data specific to each user."
    type Workout {
        workout_id:      ID           
        date_scheduled:        String       
        date_completed:        String     
        performance_rating:        Float
        user_id:    Int
        excercise_blocks: [ExcerciseBlock]
    }
`;