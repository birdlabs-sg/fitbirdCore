"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sixDaySplit = exports.fiveDaySplit = exports.fourDaySplitMuscle = exports.fourDaySplitPushPull = exports.threeDaySplitMuscle = exports.threeDaySplitPushPull = exports.twoDaySplitMuscle = exports.twoDaySplitPushPull = void 0;
const constants_1 = require("./constants");
//two day splits
exports.twoDaySplitPushPull = [constants_1.pushDay, constants_1.pullDay];
exports.twoDaySplitMuscle = [constants_1.upperDay, constants_1.lowerDay];
//three day splits
//pending fix DO NOT TOUCH OR USE
exports.threeDaySplitPushPull = [
    constants_1.pushDay,
    constants_1.pullDay,
    constants_1.pushDay,
];
/////////
exports.threeDaySplitMuscle = [
    constants_1.upperDay,
    constants_1.lowerDay,
    constants_1.legDay,
];
//four day splits
//pending fix DO NOT TOUCH OR USE
exports.fourDaySplitPushPull = [
    constants_1.pushDay,
    constants_1.pullDay,
    constants_1.pushDay,
    constants_1.pullDay,
];
//////////
exports.fourDaySplitMuscle = [
    constants_1.upperDay,
    constants_1.lowerDay,
    constants_1.upperDay,
    constants_1.lowerDay,
];
//five day splits
exports.fiveDaySplit = [
    constants_1.chestAndArmDay,
    constants_1.backAndArmDay,
    constants_1.legDay,
    constants_1.upperDay,
    constants_1.lowerDay,
];
//six day splits
exports.sixDaySplit = [
    constants_1.upperDay,
    constants_1.lowerDay,
    constants_1.legDay,
    constants_1.upperDay,
    constants_1.lowerDay,
    constants_1.legDay,
];
//# sourceMappingURL=rotations_types_general.js.map