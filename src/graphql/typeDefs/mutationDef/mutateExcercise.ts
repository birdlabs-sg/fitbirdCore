const { gql } = require('apollo-server');

export const mutateExcercise = gql`
    "Response if mutating a excercise was successful"
    type mutateExcerciseResponse implements MutationResponse {
        code: String!
        success: Boolean!
        message: String!
        excercise: Excercise
    }

    type Mutation {
        "[PROTECTED:ADMIN ONLY] Creates a excercise object."
        createExcercise(
            excercise_name:String!,
            excercise_description:String!,
            target_regions:[Int],
        )
        : mutateExcerciseResponse

        "[PROTECTED:ADMIN ONLY] Updates a excercise object."
        updateExcercise(
            excercise_id: Int!,
            excercise_name:String,
            excercise_description:String,
            target_regions:[Int!],
        )
        : mutateExcerciseResponse

        "[PROTECTED:ADMIN ONLY] Deletes a excercise object."
        deleteExcercise(
            excercise_id: Int!,
        )
        : mutateExcerciseResponse
    }
`;