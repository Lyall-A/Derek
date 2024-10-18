const fs = require("fs");

const error = fs.readFileSync("error.jpg");
const offline = fs.readFileSync("offline.jpg");

let state = 0;

stream.onStart = () => {
    state = 0;
}

stream.onError = () => {
    stream.active = true;
    state = 1;
}

setInterval(() => {
    if (state === 1) stream.handleFrame(error);
    if (state === 2) stream.handleFrame(offline);
}, 1000 / 1);