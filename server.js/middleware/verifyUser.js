const jwt = require("jsonwebtoken");

const requireAuth = async (request, response, next) => {
    const token = request.cookies.jwt;
    if (token)
    {
        jwt.verify(token, "f86a4999def34b24e3e39a0e10470909de4605540751f4cb6167c42df5a7328d", (err, id) =>
        {
            if (!err)
            {
                response.locals.id = id;
                next();
            }
            else
            {
                response.status(401).send("Require auth");
            }
        });
    }
    else
    {
        response.status(401).send("Require auth");
    }
}

module.exports = {requireAuth};