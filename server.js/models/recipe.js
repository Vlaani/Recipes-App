const mongoose = require("mongoose");
const { dbURI } = require("../constants");
const { Int32 } = require("mongodb");

mongoose.connect(dbURI);

const recipeSchema = new mongoose.Schema({
    photoPaths:
    {
        type: Array,
        of: {
            type: String,
        },
        unique: false
    },
    name: {
        type: String,
        //required: [true, "Name required"]
    },
    description: {
        type: String
    },
    kitchen: {
        type: Map,
        of: String
    },
    readinessTime:
    {
        type: Number,
        //required: true
    },
    timeInKitchen:
    {
        type: Number,
        //required: true
    },
    difficulty:
    {
        type: Number,
        //required: true
    },
    spiciness:
    {
        type: Number,
        //required: true
    },
    ingredients: {
        type: Array,
        of: {
            type: Map,
            of: mongoose.Schema.Types.Mixed
        },
       // required: true
    },
    steps: {
        type: Array,
        //required: true
    },
    weight:
    {
        type: Number
    },
    ccals:
    {
        type: Number
    },
    proteins:
    {
        type: Number
    },
    fats:
    {
        type: Number
    },
    carbohydrates:
    {
        type: Number
    }
});

const Recipe = mongoose.model("recipe", recipeSchema);

module.exports = Recipe;

/*
  String recipeName;
  String previewPath;
  final Kitchen? kitchen;
  List<Ingredient> ingredients;
  int readyTime;
  int timeInKitchen;
  int spiciness;
  int difficulty;
*/