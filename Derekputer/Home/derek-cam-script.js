const fs = require("fs");
const http = require("http");

const error = fs.readFileSync("error.jpg");
const offline = fs.readFileSync("offline.jpg");

let state = 0;

stream.keepStream = true; // Keep allowing clients when FFmpeg not running

stream.onStart = () => state = 0; // Set state to 0 on stream start
stream.onError = () => {
    // Set state to 1 on stream error
    stream.log("Setting frame to error scene");
    state = 1;
}

(async function checkPSU() {
    const status = await getPSUStatus().catch(err => {
        stream.log("Failed to get PSU status!");
        return setTimeout(checkPSU, 5000);
    });
    setTimeout(checkPSU, 5000);

    if (status == "off" && state != 2) {
        // Set state to 2 on PSU offline
        stream.log("Setting frame to offline scene");
        stream.stop(true);
        state = 2;
    } else
    if (status == "on" && state != 0) {
        // Start stream on PSU online, stream.start() will set state to 0
        stream.log("PSU is on, starting stream");
        stream.start();
    }
})();

setInterval(() => {
    if (state == 1) stream.handleFrame(error);
    if (state == 2) stream.handleFrame(offline);
}, 1000 / 1);

function getPSUStatus() {
    return new Promise((resolve, reject) => {
        const req = http.request({ host: "derek-psu", port: 5002, path: "/status", headers: { Authorization: "Derek1234*" } }, res => {
            if (res.statusCode != 200) return reject(`Got status code ${res.statusCode}`);
            let data = [];
            res.on("data", chunk => data.push(chunk));
            res.on("end", () => resolve(Buffer.concat(data).toString()));
        });
        req.on("error", err => reject(err));
        req.end();
    });
}