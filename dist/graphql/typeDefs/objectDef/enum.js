"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Enum = void 0;
const { gql } = require('apollo-server');
exports.Enum = gql `
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

`;
//# sourceMappingURL=enum.js.map