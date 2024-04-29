const { default: mongoose } = require("mongoose");
const { serverIp, Port } = require("../constants");
const Recipe = require("../models/recipe");
const Ingredient = require("../models/ingredient");
const { Types } = require('mongoose');

let bucket;

mongoose.connection.once('open', () => {
    bucket = new mongoose.mongo.GridFSBucket(mongoose.connection.db, { bucketName: 'images' });
});

module.exports.get_recipes = async (request, response) => {
    console.log("get_recipes: ");
    const {limit, last_id} = request.query;
    console.log(limit, last_id);
    try
    {
        const recipes = last_id == "0" ? await Recipe.find().limit(limit) : await Recipe.find({_id:{$gt: new Types.ObjectId(last_id)}}).limit(limit);
        response.status(200).json(recipes);
    }
    catch (err)
    {
        response.status(400).send(err.message);
    }    
};

module.exports.get_ingredients = async (request, response) => {
    console.log("get_ingredients: ");
    try
    {
        response.status(200).json(await Ingredient.find());
    }
    catch (err)
    {
        response.status(400).send(err.message);
    }    
};

module.exports.download_image = async (request, response) =>
{
    console.log(request.params.image);
    bucket.openDownloadStreamByName(request.params.image).pipe(response);
};
