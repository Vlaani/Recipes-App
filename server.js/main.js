const express = require("express");
const mongoose = require("mongoose");
const cookieParser = require("cookie-parser");
const { Port, dbURI, serverIp } = require("./constants");
const cors = require('cors');
const uploadRouter = require("./routes/uploadRoutes");
const downloadRouter = require("./routes/downloadRoutes");
const authRouter = require("./routes/authRoutes");
const Recipe = require("./models/recipe");
const Ingredient = require("./models/ingredient");

mongoose.createConnection(dbURI);

const app = express();

app.use(cors());
app.use(express.static("public"));
app.use(express.json());
app.use(cookieParser());
app.use(authRouter);
app.use(uploadRouter);
app.use(downloadRouter);

app.listen(Port, () => 
{
    console.log("Server " + serverIp + ':' + Port + " has been started");
});          

function roundHalf(num) {
    return Math.round(num*20)/20;
} 

app.put("/rename",  async (request, response) => {

    await Recipe.updateMany(
        { "ingredients.ingredient": { $exists: true } },
        [{
          $set: {
            ingredients: {
              $map: {
                input: "$ingredients",
                in: {
                  _id: "$$this.ingredient",
                  count: "$$this.count"
                }
              }
            }
          }
        }, { $unset: "lessons"}],
        { multi: true }
      );
response.status(200).send("ok");
});

app.put("/updt", async (request, response) => {
  /*const recipes = await Recipe.find();

  for (let r of recipes)
    {*/
      /*await Recipe.findOneAndUpdate({_id: r._id},
        { $unset: { photosPath: "" } }
        );*/
      /*Recipe.updateOne(
        { _id : r["id"] },
        [{ $set: { photosPath: { $objectToArray : r["photosPath"] } } }]
      );*/
       //await Recipe.updateOne({_id: r["_id"]}, {$rename:{"photosPath": "photoPaths"}})
    //}
    /*const new_recipes = await Recipe.find();
    const ingredients = await Ingredient.find();
    for (let g of ingredients)
      {
        await Ingredient.findOneAndUpdate({name: g.name}, {iconPath: "no_icon.png"} );
      }*/
    /*let g = await Ingredient.find();
    for (let f of g)
    {
        await Ingredient.findOneAndUpdate({name: f.name}, {ccal:  Number(f.ccal), protein: Number(f.protein), 
        fats: Number(f.fats),
        carbohydrates: Number(f.carbohydrates)});
    }*/
    /*for (let recipe of new_recipes) {
        let weight = 0, ccals = 0, proteins = 0, fats = 0, carbohydrates = 0;
        let ing = [{}];
        ing.pop();
        for (let element of recipe.ingredients) {
            const f = await Ingredient.findOne({name: element.get("ingredient")});
            element.set("ingredient", f._id);
            ing.push(element);
            let iW = Number(element.get("count").weight) / 1000;
            weight += iW;
            ccals += f.ccal * iW;
            proteins += f.protein * iW;
            fats += f.fats * iW;
            carbohydrates += f.carbohydrates * iW;
        } 
        //await Recipe.findOneAndUpdate({_id: recipe._id}, {});
        await Recipe.findOneAndUpdate({_id: recipe._id}, {ingredients: ing, weight: roundHalf(weight * 1000), 
            ccals: roundHalf(ccals / weight),
             proteins: roundHalf(proteins / weight), 
             fats: roundHalf(fats / weight), 
             carbohydrates: roundHalf(carbohydrates / weight)});
     }*/
    response.status(200).send("ok");
})