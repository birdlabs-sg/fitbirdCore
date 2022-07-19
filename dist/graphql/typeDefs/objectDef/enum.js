"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Enum = void 0;
const { gql } = require("apollo-server");
exports.Enum = gql `
  "Gender type."
  enum Gender {
    MALE
    FEMALE
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

  enum ExcerciseMetadataState {
    LEARNING
    INCREASED_DIFFICULTY
    DECREASED_DIFFICULTY
    MAINTAINENCE
  }

  enum LevelOfExperience {
    BEGINNER
    MID
    ADVANCED
    EXPERT
  }

  enum Goal {
    BODY_RECOMPOSITION
    STRENGTH
    KEEPING_FIT
    ATHLETICISM
    OTHERS
  }

  "Units for weight"
  enum WorkoutFilter {
    ACTIVE
    COMPLETED
    NONE
  }
`;
//# sourceMappingURL=enum.js.map