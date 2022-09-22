"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const workoutWithExerciseSetGroups = client_1.Prisma.validator()({
    include: { excercise_set_groups: { include: { excercise_sets: true } } },
});
//# sourceMappingURL=Workout.js.map