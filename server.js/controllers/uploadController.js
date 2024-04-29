const { serverIp, Port } = require("../constants");
const Recipe = require("../models/recipe");

module.exports.add_recipe = async (request, response) => {
    const { previewPath, name, readinessTime, timeInKitchen, spiciness, difficulty } = request.body;
    const { ingredients, steps, kitchen } = request.body;

    // upload multiple images before
    const recipe = await Recipe.create({previewPath, name, ingredients, steps, kitchen, readinessTime, timeInKitchen, spiciness, difficulty});



    response.status(201).send("Recipe created");
};

module.exports.upload_image = async (request, response) => {
    if (request.file === undefined)
    {
        return response.status(422).send("No file sended");
    }
    return response.status(201).send(request.file.filename);
    //const imageURL = serverIp + ":" + Port + "/images/" + request.file.filename;
};
