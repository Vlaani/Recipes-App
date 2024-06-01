const { default: mongoose } = require("mongoose");
const { serverIp, Port } = require("../constants");
const Recipe = require("../models/recipe");
const Ingredient = require("../models/ingredient");
const { Types } = require('mongoose');
const { json } = require("express");

let bucket;

mongoose.connection.once('open', () => {
    bucket = new mongoose.mongo.GridFSBucket(mongoose.connection.db, { bucketName: 'images' });
});

module.exports.get_recipes = async (request, response) => {
    console.log("get_recipes: ");
    const {limit, last_id, query, ccalsMin, ccalsMax, cookTimeMin, cookTimeMax, includedIngredients, excludedIngredients} = request.query;
    //console.log(request.query);
    try
    {
        let q = {};
        if (last_id != "0") q["_id"] = {$gt: new Types.ObjectId(last_id)};
        if (query) q["name"] = {$regex:  ".*"+query+".*", $options : 'i'};
        if (ccalsMin || ccalsMax)
        {
            if (ccalsMin && ccalsMax) q["ccals"] = {$gt:  ccalsMin, $lt: ccalsMax};
            else if (ccalsMax) q["ccals"] = {$lt:  ccalsMax};
            else q["ccals"] = {$gt: ccalsMin};
        }
        if (cookTimeMin || cookTimeMax)
        {
            if (cookTimeMin && cookTimeMax) q["timeInKitchen"] = {$gt:  cookTimeMin, $lt: cookTimeMax};
            else if (cookTimeMax) q["timeInKitchen"] = {$lt:  cookTimeMax};
            else q["timeInKitchen"] = {$gt: cookTimeMin};
        }
        let hexId = (await Ingredient.findOne())._id.toString()
        let included = [];
        if (includedIngredients)
        {
            for (let i of JSON.parse(includedIngredients))
            {
                //console.log(hexId);
                //console.log("ObjectId(\'"+hexId.substring(0, hexId.length - 5) + (parseInt(hexId.substring(hexId.length - 5), 16) + parseInt(i)).toString(16)+"\')");
                included.push(new mongoose.Types.ObjectId(hexId.substring(0, hexId.length - 5) + (parseInt(hexId.substring(hexId.length - 5), 16) + parseInt(i)).toString(16)));
            }
        }      
        let excluded = [];  
        if (excludedIngredients)
        {
            for (let i of JSON.parse(excludedIngredients))
            {
                excluded.push(new mongoose.Types.ObjectId(hexId.substring(0, hexId.length - 5) + (parseInt(hexId.substring(hexId.length - 5), 16) + parseInt(i)).toString(16)));
            }           
        }
        if (includedIngredients || excludedIngredients)
            {
                //q["ingredients._id"] = {$all: included};
                if (includedIngredients && excludedIngredients) q["ingredients._id"] = {$all:  included, $nin: excluded};
                else if (excludedIngredients) q["ingredients._id"] = {$nin:  excluded};
                else q["ingredients._id"] = {$all: included};
            }
        const recipes =  await Recipe.find(q).limit(limit); 
        response.status(200).json(recipes);
    }
    catch (err)
    {
        console.log(err.message);
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
    bucket.openDownloadStreamByName(request.params.image).pipe(response);
};
