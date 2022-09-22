"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
// This helps to add more fields into the generated types
const excerciseSetGroupWithExerciseSets = client_1.Prisma.validator()({
    include: { excercise_sets: true },
});
//# sourceMappingURL=ExcerciseSetGroup.js.map