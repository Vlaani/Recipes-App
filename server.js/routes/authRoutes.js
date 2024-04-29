const { Router } = require("express");
const { signup_post, login_post, profile_get, profile_update } = require("../controllers/authController");
const { requireAuth } = require("../middleware/verifyUser");
const upload = require("../middleware/upload");

const router = Router();

router.post("/signup", signup_post);
router.post("/login", login_post);
//router.post("/logout", logout_post);
router.get("/profile", requireAuth, profile_get);
router.put("/profile", requireAuth, upload.single("file"), profile_update);

module.exports = router;
