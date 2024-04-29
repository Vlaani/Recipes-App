const mongoose = require("mongoose");
const { dbURI } = require("../constants");
const { Int32 } = require("mongodb");

mongoose.connect(dbURI);

const ingredientSchema = new mongoose.Schema({
    ingredientImagePath:
    {
        type: String,
        unique: false
    },
    name: {
        type: String,
        required: [true, "Name required"],
        unique: true
    },
    ccal: {
        type: Number,
        required: true
    },
    protein: {
        type: Number,
        required: true
    },
    fats : {
        type: Number,
        required: true
    },
    carbohydrates : {
        type: Number,
        required: true
    }
});

const Ingredient = mongoose.model("ingredient", ingredientSchema);

module.exports = Ingredient;