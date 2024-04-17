const { serverIp, Port } = require("../constants");

module.exports.add_recipe = async (request, response) => {
    response.send({status : "ok"});
};

module.exports.upload_image = async (request, response) => {
    if (request.file === undefined)
    {
        return response.status(422).send("No file sended");
    }
    const imageURL = serverIp + ":" + Port + "/images/" + request.file.filename;
    return response.status(201).send(imageURL);
};
