var agencyData = {
  "arango" : {
     "Sync" : {
        "LatestID" : "\"1\"",
        "Problems" : {},
        "UserVersion" : "\"1\"",
        "ServerStates" : {},
        "HeartbeatIntervalMs" : "1000",
        "Commands" : {}
     },
     "Current" : {
        "Collections" : {
           "_system" : {}
        },
        "Version" : "\"1\"",
        "ShardsCopied" : {},
        "NewServers" : {},
        "Coordinators" : {},
        "Lock" : "\"UNLOCKED\"",
        "DBservers" : {},
        "ServersRegistered" : {
           "Version" : "\"1\""
        },
        "Databases" : {
           "_system" : {
              "id" : "\"1\"",
              "name" : "\"name\""
           }
        }
     },
     "Plan" : {
        "Coordinators" : {
          "Claus" : '"none"'
        },
        "MapLocalToEndpoint" : {},
        "Databases" : {
           "_system" : "{\"name\":\"_system\", \"id\":\"1\"}"
        },
        "DBServers" : {
          "Pavel" : '"none"'
        },
        "Version" : "\"1\"",
        "Collections" : {
           "_system" : {
             "0000001" :
             '{ "isSystem" : true, "name" : "_configuration", "isVolatile" : false, "deleted" : false, "keyOptions" : { "allowUserKeys" : true, "type" : "traditional" }, "waitForSync" : true, "type" : 2, "shards" : { "s0000002" : "Pavel" }, "status" : 3, "shardKeys" : [ "_key" ], "journalSize" : 33554432, "doCompact" : true, "indexes" : [ { "id" : "0", "type" : "primary", "fields" : [ "_key" ], "unique" : true } ], "id" : "0000001" }',
             "0000003" :
             '{ "waitForSync" : false, "deleted" : false, "shardKeys" : [ "_key" ], "journalSize" : 33554432, "indexes" : [ { "fields" : [ "_key" ], "unique" : true, "id" : "0", "type" : "primary" }, { "id" : "0000004", "type" : "skiplist", "fields" : [ "time" ], "unique" : false } ], "doCompact" : true, "keyOptions" : { "allowUserKeys" : true, "type" : "traditional" }, "shards" : { "s0000005" : "Pavel" }, "isSystem" : true, "isVolatile" : false, "type" : 2, "status" : 3, "name" : "_statisticsRaw", "id" : "0000003" }',
             "0000006" :
             '{ "indexes" : [ { "fields" : [ "_key" ], "id" : "0", "unique" : true, "type" : "primary" }, { "type" : "hash", "unique" : true, "fields" : [ "user" ], "id" : "0000008" } ], "shardKeys" : [ "user" ], "isVolatile" : false, "waitForSync" : true, "name" : "_users", "journalSize" : 33554432, "deleted" : false, "isSystem" : true, "id" : "0000006", "doCompact" : true, "keyOptions" : { "allowUserKeys" : true, "type" : "traditional" }, "status" : 3, "shards" : { "s0000007" : "Pavel" }, "type" : 2 }',
             "0000009" :
             '{ "indexes" : [ { "id" : "0", "fields" : [ "_key" ], "unique" : true, "type" : "primary" } ], "doCompact" : true, "type" : 2, "shards" : { "s0000010" : "Pavel" }, "shardKeys" : [ "_key" ], "waitForSync" : false, "name" : "_modules", "deleted" : false, "keyOptions" : { "allowUserKeys" : true, "type" : "traditional" }, "status" : 3, "id" : "0000009", "journalSize" : 1048576, "isVolatile" : false, "isSystem" : true }',
             "0000011" :
             '{ "status" : 3, "isSystem" : true, "name" : "_routing", "journalSize" : 33554432, "id" : "0000011", "indexes" : [ { "type" : "primary", "fields" : [ "_key" ], "id" : "0", "unique" : true } ], "waitForSync" : false, "type" : 2, "shards" : { "s0000012" : "Pavel" }, "doCompact" : true, "shardKeys" : [ "_key" ], "isVolatile" : false, "deleted" : false, "keyOptions" : { "allowUserKeys" : true, "type" : "traditional" } }',
             "0000013" :
             '{ "shards" : { "s0000014" : "Pavel" }, "deleted" : false, "doCompact" : true, "journalSize" : 33554432, "waitForSync" : true, "indexes" : [ { "type" : "primary", "fields" : [ "_key" ], "id" : "0", "unique" : true }, { "unique" : true, "type" : "hash", "fields" : [ "name", "version" ], "id" : "0000015" } ], "isVolatile" : false, "shardKeys" : [ "name", "version" ], "name" : "_aal", "type" : 2, "id" : "0000013", "isSystem" : true, "keyOptions" : { "type" : "traditional", "allowUserKeys" : true }, "status" : 3 }',
             "0000016" :
             '{ "indexes" : [ { "unique" : true, "fields" : [ "_key" ], "id" : "0", "type" : "primary" } ], "isSystem" : true, "waitForSync" : false, "id" : "0000016", "doCompact" : true, "shards" : { "s0000017" : "Pavel" }, "journalSize" : 4194304, "name" : "_aqlfunctions", "keyOptions" : { "type" : "traditional", "allowUserKeys" : true }, "type" : 2, "isVolatile" : false, "status" : 3, "shardKeys" : [ "_key" ], "deleted" : false }',
             "0000018" :
             '{ "journalSize" : 33554432, "name" : "_jobs", "id" : "0000018", "indexes" : [ { "unique" : true, "type" : "primary", "id" : "0", "fields" : [ "_key" ] } ], "doCompact" : true, "deleted" : false, "isVolatile" : false, "type" : 2, "shardKeys" : [ "_key" ], "shards" : { "s0000019" : "Pavel" }, "isSystem" : true, "status" : 3, "keyOptions" : { "type" : "traditional", "allowUserKeys" : true }, "waitForSync" : false }',
             "0000020" :
             '{ "indexes" : [ { "unique" : true, "fields" : [ "_key" ], "id" : "0", "type" : "primary" } ], "isVolatile" : false, "name" : "_sessions", "isSystem" : true, "doCompact" : true, "type" : 2, "deleted" : false, "journalSize" : 33554432, "waitForSync" : false, "status" : 3, "shards" : { "s0000021" : "Pavel" }, "keyOptions" : { "allowUserKeys" : true, "type" : "traditional" }, "shardKeys" : [ "_key" ], "id" : "0000020" }',
             "0000022" :
             '{ "name" : "_statistics", "status" : 3, "id" : "0000022", "indexes" : [ { "fields" : [ "_key" ], "unique" : true, "id" : "0", "type" : "primary" }, { "type" : "skiplist", "id" : "0000023", "unique" : false, "fields" : [ "time" ] } ], "keyOptions" : { "allowUserKeys" : true, "type" : "traditional" }, "deleted" : false, "isVolatile" : false, "waitForSync" : false, "isSystem" : true, "shards" : { "s0000024" : "Pavel" }, "doCompact" : true, "type" : 2, "shardKeys" : [ "_key" ], "journalSize" : 33554432 }',
             "0000025" :
             '{ "deleted" : false, "waitForSync" : false, "type" : 2, "indexes" : [ { "id" : "0", "type" : "primary", "fields" : [ "_key" ], "unique" : true }, { "id" : "0000026", "type" : "skiplist", "unique" : false, "fields" : [ "time" ] } ], "isSystem" : true, "status" : 3, "shards" : { "s0000027" : "Pavel" }, "shardKeys" : [ "_key" ], "journalSize" : 33554432, "id" : "0000025", "name" : "_statistics15", "keyOptions" : { "allowUserKeys" : true, "type" : "traditional" }, "doCompact" : true, "isVolatile" : false }',
             "0000028" :
             '{ "journalSize" : 1048576, "id" : "0000028", "deleted" : false, "doCompact" : true, "keyOptions" : { "type" : "traditional", "allowUserKeys" : true }, "shards" : { "s0000029" : "Pavel" }, "shardKeys" : [ "_key" ], "status" : 3, "type" : 2, "waitForSync" : true, "name" : "_graphs", "indexes" : [ { "unique" : true, "fields" : [ "_key" ], "type" : "primary", "id" : "0" } ], "isVolatile" : false, "isSystem" : true }'
           }
        },
        "Lock" : "\"UNLOCKED\""
     },
     "Launchers" : {
     },
     "Target" : {
        "Coordinators" : {
        },
        "MapIDToEndpoint" : {
        },
        "Collections" : {
           "_system" : {}
        },
        "Version" : "\"1\"",
        "MapLocalToEndpoint" : {},
        "Databases" : {
           "_system" : "{\"name\":\"_system\", \"id\":\"1\"}"
        },
        "DBServers" : {
        },
        "Lock" : "\"UNLOCKED\""
     }
  }
};

var download = require("internal").download;
var print = require("internal").print;

function encode (st) {
  var st2 = "";
  var i;
  for (i = 0; i < st.length; i++) {
    if (st[i] === "_") {
      st2 += "@U";
    }
    else if (st[i] === "@") {
      st2 += "@@";
    }
    else {
      st2 += st[i];
    }
  }
  return encodeURIComponent(st2);
}

function sendToAgency (agencyURL, path, obj) {
  var res;
  var body;

  print("Sending",path," to agency...");
  if (typeof obj === "string") {
    var count = 0;
    while (count++ <= 2) {
      body = "value="+encodeURIComponent(obj);
      print("Body:", body);
      print("URL:", agencyURL+path);
      res = download(agencyURL+path,body,
          {"method":"PUT", "followRedirects": true,
           "headers": { "Content-Type": "application/x-www-form-urlencoded"}});
      if (res.code === 201 || res.code === 200) {
        return true;
      }
      wait(3);  // wait 3 seconds before trying again
    }
    return res;
  }
  if (typeof obj !== "object") {
    return "Strange object found: not a string or object";
  }
  var keys = Object.keys(obj);
  var i;
  if (keys.length !== 0) {
    for (i = 0; i < keys.length; i++) {
      res = sendToAgency (agencyURL, path+encode(keys[i])+"/", obj[keys[i]]);
      if (res !== true) {
        return res;
      }
    }
    return true;
  }
  else {
    body = "dir=true";
    res = download(agencyURL+path, body,
          {"method": "PUT", "followRedirects": true,
           "headers": { "Content-Type": "application/x-www-form-urlencoded"}});
    if (res.code !== 201 && res.code !== 200) {
      return res;
    }
    return true;
  }
}

print("Starting to send data to Agency...");
var res = sendToAgency("http://localhost:4001/v2/keys", "/", agencyData);
print("Result:",res);
