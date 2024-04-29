const { default: mongoose } = require("mongoose");
const { tokenExpiresIn } = require("../constants");
const User = require("../models/user");
const jwt = require("jsonwebtoken");

const createToken = (id) => {
    return jwt.sign({ id }, "f86a4999def34b24e3e39a0e10470909de4605540751f4cb6167c42df5a7328d", { expiresIn: tokenExpiresIn });
};

let bucket;

mongoose.connection.once('open', () => {
    bucket = new mongoose.mongo.GridFSBucket(mongoose.connection.db, { bucketName: 'images' });
});

module.exports.signup_post = async (request, response) => {
    console.log("signup");
    const { userName, login, email, password } = request.body;
    console.log(email);
    try
    {
        const user = await User.create({profilePhoto: "", userName, login, email, password});
        const token = createToken(user._id);
        response.cookie("jwt", token, { maxAge: tokenExpiresIn * 1000 });
        response.status(201).json({ user: user._id });
    }
    catch (err)
    {
        console.log(err.keyPattern);
        response.status(400).send(err.code === 11000 ? "User with this" + ("login" in err.keyPattern ? " login" : " email") + " already exists" : err.message);
    }
};

module.exports.login_post = async (request, response) => {
    //console.log("login");
    const { login_or_email, password } = request.body;
    console.log(login_or_email, password);
    try
    {
        const user = await User.login(login_or_email, password);
        const token = createToken(user._id);
        response.cookie("jwt", token, { maxAge: tokenExpiresIn * 1000 });
        response.status(200).json({ user: user._id });
    }
    catch (err)
    {
        response.status(400).send(err.message);
    }
};

module.exports.profile_get = async (request, response) => {
    try
    {
        const user = await User.load(response.locals.id.id);
        console.log(JSON.stringify(user));
            response.status(200).json({
                pofilePhotoPath: user.pofilePhotoPath,
                userName: user.userName,
                login: user.login,
                email: user.email,
                likedRecipes: null});  
    }
    catch (err)
    {
        response.status(400).send(err.message);
    }           
};

module.exports.profile_update = async (request, response) => {
    console.log("profile_update");
    try
    {
        const { userName, login, email, password } = request.body;
        pofilePhotoPath = request.file != undefined ? request.file.filename : undefined;
        await User.update(response.locals.id.id, pofilePhotoPath, userName, login, email, password);
        response.status(204).send("User updated succesfully");    
    }
    catch (err)
    {
        response.status(400).send(err.message);
    }  
};