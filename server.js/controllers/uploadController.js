const { serverIp, Port } = require("../constants");
const { default: mongoose } = require("mongoose");
const { Types } = require('mongoose');
const Ingredient = require("../models/ingredient");
const Recipe = require("../models/recipe");


module.exports.add_recipe = async (request, response) => {
    let hexId = (await Ingredient.findOne())._id.toString()
    const { recipeName, photoPaths, description, readyTime, timeInKitchen, spiciness, difficulty, ingredients, steps, kitchen  } = request.body;
    _ingredients = [];
    for (let i of ingredients)
        {
            _ingredients.push({_id: new mongoose.Types.ObjectId(hexId.substring(0, hexId.length - 5) + (parseInt(hexId.substring(hexId.length - 5), 16) + parseInt(i.key)).toString(16)),
                count: {differentTypeCount:
                    "По вкусу",
                    weight: i.value}
             });
        }
        console.log("upload recipe");
    console.log(request.body);
    // upload multiple images before
    const recipe = await Recipe.create({
        name:recipeName,
        description:description,
         photoPaths:photoPaths, 
         ingredients:_ingredients, 
         steps:steps, 
         kitchen:kitchen, 
         readinessTime:readyTime,
         timeInKitchen:timeInKitchen, 
         spiciness:spiciness,
        difficulty:difficulty});
    //console.log(recipe._id.toString());
    response.status(201).send(recipe._id.toString());
};

module.exports.upload_image = async (request, response) => {
    if (request.file === undefined)
    {
        return response.status(422).send("No file sended");
    }
    return response.status(201).send(request.file.filename);
    //const imageURL = serverIp + ":" + Port + "/images/" + request.file.filename;
};
