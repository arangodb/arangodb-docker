'use strict';

var fs = require('fs');
var foxx = require('org/arangodb/foxx/manager');
var internal = require('internal');

function main(argv) {
  var mounts = "";

  try {
    mounts = fs.read('/foxxes/mounts.json');
  }
  catch (err) {
    internal.print("no '/foxxes/mounts.json' file found, nothing to install");
    internal.print("(" + err.stack + ")");
  }

  if (mounts !== "") {
    try {
      mounts = JSON.parse(mounts);
    }
    catch (err) {
      internal.print("'/foxx/mounts.json' file is corrupt, aborting install");
      internal.print("(" + err.stack + ")");
      mounts = [];
    }
  }

  var i;

  for (i = 0; i < mounts.length; ++i) {
    var mount = mounts[i];

    internal.print("installing '" + mount.app + "' on path '" + mount.mount + "'");

    try {
      foxx.install('/foxxes/' + mount.app, mount.mount, mount.options || {});
    }
    catch (err) {
      internal.print("installation failed: '%s'" + err.stack + "'");
    }
  }
}
