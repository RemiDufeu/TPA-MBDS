const express = require("express");
const path = require("path");
const app = express();
const port = 3000;
var JDBC = require("jdbc");
var jinst = require("jdbc/lib/jinst");
var fs = require("fs");
var cors = require("cors");
app.use(cors());

/// uncomment if you wanna use hive connection
if (!jinst.isJvmCreated()) {
    jinst.addOption("-Xrs");
    jinst.setupClasspath([
        "./lib/hive-jdbc-3.1.3-standalone.jar",
        "./lib/hadoop-common-3.3.4.jar",
    ]);
}
var conf = {
    url: "jdbc:hive2://localhost:10000",
    drivername: "org.apache.hive.jdbc.HiveDriver",
    properties: {},
};
var hive = new JDBC(conf);
hive.initialize(function (err) {
    if (err) {
        console.log(err);
    }
});
///

app.get("/hive", (req, res) => {
    var data = [];
    hive.reserve(function (err, connObj) {
        if (connObj) {
            console.log("Connection : " + connObj.uuid);
            var conn = connObj.conn;
            conn.createStatement(function (err, statement) {
                if (err) {
                    console.log(err);
                } else {
                    statement.executeQuery(
                        "select clients_h_ext.clientid as id, clients_h_ext.age as age, clients_h_ext.sexe as sexe, clients_h_ext.taux as taux, clients_h_ext.situation_familiale as situation_familiale, clients_h_ext.nbr_enfant as nbr_enfant, clients_h_ext.voiture_2 as voiture_2, clients_h_ext.immatriculation as immatriculation, immatriculation_h_ext.marque as marque, immatriculation_h_ext.nom as nom, immatriculation_h_ext.puissance as puissance, immatriculation_h_ext.longueur as longueur, immatriculation_h_ext.nbplaces as nbplaces, immatriculation_h_ext.nbportes as nbportes, immatriculation_h_ext.couleur as couleur, immatriculation_h_ext.occasion as occasion, immatriculation_h_ext.prix as prix from clients_h_ext inner join immatriculation_h_ext on clients_h_ext.immatriculation = immatriculation_h_ext.immatriculation",
                        function (err, resultset) {
                            if (err) {
                                console.log(err);
                            } else {
                                // Convert the result set to an object array.
                                resultset.toObjArray(function (err, results) {
                                    if (results.length > 0) {
                                        console.log(results.length);
                                        res.render("index", {
                                            query: results,
                                            title: "Hive Query",
                                        });
                                    }
                                });
                            }
                        }
                    );
                }
            });
        }
    });
});

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`);
});
