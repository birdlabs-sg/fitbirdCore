export const oneRepMaxCalculator = (weight: number, reps: number) => {
  return weight * (1 + reps / 30); //1RM formula
};

export const suggestedWeightCalculator = (
  best_weight: number,
  reps: number
) => {
  return best_weight / (1 + reps / 30);
};
// premises that have to be noted on the frontend
// 1. both body weight and weighted exercises done before cannot have a best rep to be 0;
// 2. otherwise a user filling in their 1RM on the frontend side will have their best_rep set to 1;
export const suggestedRepCalculator = (best_rep: number, sets: number) => {
  return (1.6 * best_rep) / sets;
};
