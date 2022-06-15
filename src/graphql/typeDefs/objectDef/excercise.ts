const { gql } = require('apollo-server');

export const Excercise = gql`
    "Represents a specific excercise."
    type Excercise {
        excercise_id:          ID           
        excercise_name:        String
        excercise_description: String
        target_regions:        [MuscleRegion]
    }
`;