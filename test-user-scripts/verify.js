if (db._collection('testcollection_from_js_test') === null) {
  throw new Error("test javascript didn't run");
}
if (db._collection('testcollection_from_sh_test') === null) {
  throw new Error("test shellscript didn't run");
}
if (db._databases().indexOf('KnowsGraph') < 0) {
  throw new Error("test import didn't create its database");
}
db._useDatabase('KnowsGraph');

if (db._collection('knows') === null) {
  throw new Error("Import didn't create 'knows'-collection!");
}
if (db._collection('persons') === null) {
  throw new Error("Import didn't create 'persons'-collection!");
}

if (db.knows.toArray().length !== 5) {
  throw new Error("Import didn't create all documents in the 'knows'-collection!");
}
if (db.persons.toArray().length !== 5) {
  throw new Error("Import didn't create all documents in the 'persons'-collection!");
}
