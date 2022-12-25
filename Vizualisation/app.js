const express = require("express");
const path = require("path");
const app = express();
const port = 3000;
var JDBC = require("jdbc");
var jinst = require("jdbc/lib/jinst");
var asyncjs = require("async");
var util = require("util");

app.set("views", path.join(__dirname, "views"));
app.set("view engine", "ejs");

app.get("/", (req, res) => {
    var data = [];
    //create a jvm and specify the jars required in the classpath and other jvm parameters
    if (!jinst.isJvmCreated()) {
        jinst.addOption("-Xrs");
        jinst.setupClasspath([
            "./lib/hive-jdbc-3.1.3-standalone.jar",
            "./lib/hadoop-common-3.3.4.jar",
        ]);
    }

    //read the input arguments

    //specify the hive connection parameters

    var conf = {
        url: "jdbc:hive2://localhost:10000",
        drivername: "org.apache.hive.jdbc.HiveDriver",
        properties: {},
    };

    var hive = new JDBC(conf);

    //initialize the connection

    hive.initialize(function (err) {
        if (err) {
            console.log(err);
        }
    });

    // create the connection

    hive.reserve(function (err, connObj) {
        if (connObj) {
            console.log("Connection : " + connObj.uuid);
            var conn = connObj.conn;

            asyncjs.series([
                //set hive paramters if required. A sample property is set below
                function (callback) {
                    conn.createStatement(function (err, statement) {
                        if (err) {
                            callback(err);
                        } else {
                            statement.execute(
                                "SET hive.metastore.sasl.enabled=false",
                                function (err, resultset) {
                                    if (err) {
                                        callback(err);
                                    } else {
                                        console.log(
                                            "Seccessfully set the properties"
                                        );
                                        callback(null, resultset);
                                    }
                                }
                            );
                        }
                    });
                },
                // calling a select query in the session below.
                function (callback) {
                    conn.createStatement(function (err, statement) {
                        if (err) {
                            callback(err);
                        } else {
                            console.log("Executing query.");
                            statement.executeQuery(
                                "SELECT * FROM clients_h_ext LIMIT 10",
                                function (err, resultset) {
                                    if (err) {
                                        console.log(err);
                                        callback(err);
                                    } else {
                                        resultset.toObjArray(function (
                                            err,
                                            result
                                        ) {
                                            if (result.length > 0) {
                                                console.log(result);
                                                res.render("index", {
                                                    title: "Hello World",
                                                    query: result,
                                                });
                                            }
                                            callback(null, resultset);
                                        });
                                    }
                                }
                            );
                        }
                    });
                },
            ]);
        }
    });
});

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`);
});
