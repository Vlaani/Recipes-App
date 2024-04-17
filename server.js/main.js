const express = require("express");
const mongoose = require("mongoose");
const cookieParser = require("cookie-parser");
const { Port, dbURI, serverIp } = require("./constants");
const cors = require('cors');
const Grid = require("gridfs-stream");
const uploadRouter = require("./routes/uploadRoutes");
const authRouter = require("./routes/authRoutes");
const upload = require("./middleware/upload");
const { upload_image } = require("./controllers/uploadController");

//let conn = mongoose.createConnection(dbURI);
let bucket;

mongoose.createConnection(dbURI).once('open', () => {
    bucket = new mongoose.mongo.GridFSBucket(mongoose.connection.db, { bucketName: 'images' });
});

const app = express();

app.use(cors());
app.use(express.static("public"));
app.use(express.json());
app.use(cookieParser());
app.use(authRouter);
app.use(uploadRouter);

app.post("/uploadImage", upload.single("file"), upload_image);
app.get("/images/:image", async (request, response) =>
{
    bucket.openDownloadStreamByName(request.params.image).pipe(response);
});

async function init()
{
        const server = app.listen(Port, () => 
        {
            console.log("Server " + serverIp + ':' + Port + " has been started");
        });
}

init();

    /*const file = await bucket.find({filename: request.params.image});
    if (file && (file.contentType == "image/jpeg" || file.contentType == "image/png"))
    {
        const readStream = bucket.openDownloadStream(file._id);
        readStream.pipe(response);
        //response.status(200).send("found");
    }    
    else
    {
        response.status(404).send("Not found");
    }*/

/*app.get("images/:image", async (request, response) =>
{
    try
    {
        const file = await gridfs.files.findOne({fileName: request.params.fileName});
        const readStream = gridfs.createReadStream(file.fileName);
        readStream.pipe(response);
    }
    catch (err)
    {
        response.status(404).send("Not found");
    }
});*/