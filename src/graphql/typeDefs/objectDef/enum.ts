const { gql } = require('apollo-server');


export const Enum = gql`
    "Gender type."
    enum Gender {
        CIS_MALE
        CIS_FEMALE
        RATHER_NOT_SAY
    }

    "Units for weight"
    enum WeightUnit {
        KG
        LB
    }

    "Units for length."
    enum LengthUnit {
        CM
        MM
        MTR
        FT
    }

`
