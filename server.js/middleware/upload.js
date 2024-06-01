const multer = require("multer");
const { GridFsStorage } = require("multer-gridfs-storage");
const { dbURI, serverIp, Port } = require("../constants");
const crypto = require("crypto");

const storage = GridFsStorage({
    url: dbURI,
    file: (request, file) =>
    {
        return new Promise((resolve, reject) => {
            crypto.randomBytes(16, (err, buf) => {
                if (err)
                {
                    return reject(err);
                }
                const filename = buf.toString('hex') + "-" + file.originalname;
                const fileinfo = {
                    filename: filename,
                    bucketName: "images"
                };
                console.log("resolved");
                resolve(fileinfo);
            });
        });
    }
});

module.exports = multer({storage});

/*
const match = ["image/png", "image/jpeg"];
        if (match.indexOf(file.mimetype) === -1)
        {
            const filename = Date.now() + "-" + file.originalname;
            return filename;
        }
        return {
            bucketName: "uploads",
            filename: Date.now() + "-" + file.originalname
        };
         */