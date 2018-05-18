var resourceWait  = 1000,
    maxRenderWait = 600000;


var page          = require('webpage').create(),
    count         = 0,
    system = require('system'),
    forcedRenderTimeout,
    renderTimeout;

address = system.args[1];
output = system.args[2];

page.viewportSize = { width: 700, height : 1000 };

function doRender() {
    setTimeout( function () {
        page.render(output);
        phantom.exit();
    }, 3000)
}

page.onResourceRequested = function (req) {
    count += 1;
    clearTimeout(renderTimeout);
};

page.onResourceReceived = function (res) {
    if (!res.stage || res.stage === 'end') {
        count -= 1;
        if (count === 0) {
            renderTimeout = setTimeout(doRender, resourceWait);
        }
    }
};

page.open(address, function (status) {
    if (status !== "success") {
        phantom.exit();
    } else {
        forcedRenderTimeout = setTimeout(function () {
            doRender();
        }, maxRenderWait);
    }
});