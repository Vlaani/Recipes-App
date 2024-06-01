const { Router } = require("express");
const { get_recipes, get_ingredients, download_image } = require("../controllers/downloadController");

const router = Router();

router.get("/getRecipes", get_recipes);
router.get("/getIngredients", get_ingredients);
router.get("/images/:image", download_image);

module.exports = router;