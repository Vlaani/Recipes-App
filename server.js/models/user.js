const mongoose = require("mongoose");
const { isEmail } = require("validator");
const bcrypt = require("bcrypt");
const { dbURI } = require("../constants");

mongoose.connect(dbURI);

const userSchema = new mongoose.Schema({
    pofilePhotoPath:
    {
        type: String,
        unique: false
    },
    nickName: {
        type: String,
        required: [true, "Name required"]
    },
    login: {
        type: String,
        unique: [true, "User with this login already exists"],
        required: [true, "Login required"],
        lowercase: true
    },
    email: {
        type: String,
        unique: [true, "User with this email already exists"],
        required: [true, "Email required"],
        lowercase: true,
        validate : [isEmail, "Invalid email"]
    },
    password : {
        type: String,
        required: [true, "Password required"],
        minlength: [8, "Minimum password length is 8"]
    },
});

userSchema.pre("save", async function(next) {
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
    next();
});

userSchema.statics.login = async function(login_or_email, password)
{
    var user = isEmail(login_or_email) ? await this.findOne({email: login_or_email}) : await this.findOne({login: login_or_email});
    if (user)
    {
        const auth = await bcrypt.compare(password, user.password);
        if (auth)
        {
            return user;
        }
        throw Error("Incorrect password");
    }
    throw Error("User doesn't exist");
}

userSchema.statics.load = async function(id)
{
    console.log(id);
    const user = await this.findOne({_id: id});
    if (user)
    {
        return user;
    }
    throw Error("User doesn't exist");
}

const User = mongoose.model("user", userSchema);

module.exports = User;