const { gql } = require('apollo-server');

export const MuscleRegion = gql`
    "Represents a specific body part in the human anatomy."
    type MuscleRegion {
        muscle_region_id:          Int        
        muscle_region_name:        String
        muscle_region_description: String
    }
`;