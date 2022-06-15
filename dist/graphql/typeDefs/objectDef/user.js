"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.User = void 0;
const { gql } = require('apollo-server');
exports.User = gql `
    "Represents a user. Contains meta-data specific to each user."
    type User {
        user_id:      ID           
        email:        String       
        displayName:         String
        gender:       Gender
        weight:       Float
        height:       Float
        weight_unit:  WeightUnit
        height_unit:  LengthUnit
        measurements: [Measurement]
        workouts:     [Workout]
        notifications: [Notification]
        broadcasts:  [BroadCast]
    }
`;
//# sourceMappingURL=user.js.map