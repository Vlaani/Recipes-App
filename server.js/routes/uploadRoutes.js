const { Router } = require("express");
const { upload_image, add_recipe } = require("../controllers/uploadController");
const { requireAuth } = require("../middleware/verifyUser");
const upload = require("../middleware/upload");

const router = Router();

router.post("/uploadRecipe", requireAuth, upload.single("file"), add_recipe);
router.post("/uploadImage", requireAuth, upload.single("file"), upload_image);

module.exports = router;