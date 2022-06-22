const { gql } = require('apollo-server');

export const mutateUser = gql`
    "Response if a mutation event is successful"
    type MutateUserResponse implements MutationResponse {
        code: String!
        success: Boolean!
        message: String!
        user: User
    }

    "[PROTECTED] Mutation to update the requestor's user information"
    type Mutation {
        updateUser(
            gender:Gender,
            weight:Float,
            height:Float,
            weight_unit:WeightUnit,
            height_unit:LengthUnit,
            prior_years_of_experience:Int,
            level_of_experience: LevelOfExperience,
            age: Int,
            dark_mode: Boolean,
            goal: Goal,
            workout_frequency: Int,
            workout_duration: Int,
            automatic_scheduling: Boolean,
        )
        : MutateUserResponse
    }
`;