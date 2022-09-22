"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
// This helps to add more fields into the generated types
// 2: Define a type that only contains a subset of the scalar fields
const WorkoutWithExerciseSets = client_1.Prisma.validator()({
    include: { excercise_set_groups: { include: { excercise_sets: true } } },
});
//# sourceMappingURL=Prisma.js.map