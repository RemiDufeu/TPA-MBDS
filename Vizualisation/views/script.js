document.addEventListener("DOMContentLoaded", map);

function map() {
    const width = 700,
        height = 550;

    // Create a path object to manipulate geo data
    const path = d3.geoPath();

    // Define projection property
    const projection = d3
        .geoConicConformal() // Lambert-93
        .center([2.454071, 46.279229]) // Center on France
        .scale(2600)
        .translate([width / 2 - 50, height / 2]);

    path.projection(projection); // Assign projection to path object

    // Create the DIV that will contain our map
    const svg = d3
        .select("#chart")
        .append("svg")
        .attr("id", "svg")
        .attr("width", width)
        .attr("height", height)
        .attr("class", "Blues");

    // Append the group that will contain our paths
    const deps = svg.append("g");
    var promises = [];
    promises.push(d3.json("../departments.json"));
    promises.push(d3.json("../data.json"));

    var marqueSelected = "Mercedes";
    var modelSelected = "S500";
    var marqueDept = [];
    var modelDept = [];
    Promise.all(promises).then(function (values) {
        const geojson = values[0];
        const csv = values[1];
        var nbrMarque = {};
        var nbrModel = {};
        csv.forEach((e) => {
            delete e.id;
            delete e.couleur;
            delete e.nbportes;
            delete e.occasion;
            delete e.age;
            delete e.voiture_2;
            delete e.puissance;
            delete e.longeur;
            delete e.prix;
            delete e.taux;
            var imm = e.immatriculation.split(" ");
            e.immatriculation = imm[2];
        });
        csv.forEach((element) => {
            if (!nbrMarque[element.immatriculation]) {
                nbrMarque[element.immatriculation] = {};
            }
            if (!nbrMarque[element.immatriculation][element.marque]) {
                nbrMarque[element.immatriculation][element.marque] = 0;
            }
            nbrMarque[element.immatriculation][element.marque]++;
        });
        csv.forEach((element) => {
            if (!nbrModel[element.immatriculation]) {
                nbrModel[element.immatriculation] = {};
            }
            if (!nbrModel[element.immatriculation][element.nom]) {
                nbrModel[element.immatriculation][element.nom] = 0;
            }
            nbrModel[element.immatriculation][element.nom]++;
        });
        for (let i = 0; i < 100; i++) {
            if (nbrMarque[i]) {
                var val = nbrMarque[i][marqueSelected];
                if (val) {
                    marqueDept.push({
                        imma: i,
                        nbr: val,
                    });
                }
            }
        }
        for (let i = 0; i < 100; i++) {
            if (nbrModel[i]) {
                var val = nbrModel[i][modelSelected];
                if (val) {
                    modelDept.push({
                        imma: i,
                        nbr: val,
                    });
                }
            }
        }
        var features = deps
            .selectAll("path")
            .data(geojson.features)
            .enter()
            .append("path")
            .attr("id", (d) => "d" + d.properties.CODE_DEPT)
            .attr("d", path);

        // Quantile scales map an input domain to a discrete range, 0...max(population) to 1...9
        var quantile = d3
            .scaleQuantile()
            .domain([0, d3.max(marqueDept, (e) => +e.nbr)])
            .range(d3.range(9));

        var legend = svg
            .append("g")
            .attr("transform", "translate(525, 150)")
            .attr("id", "legend");

        legend
            .selectAll(".colorbar")
            .data(d3.range(9))
            .enter()
            .append("svg:rect")
            .attr("y", (d) => d * 20 + "px")
            .attr("height", "20px")
            .attr("width", "20px")
            .attr("x", "0px")
            .attr("class", (d) => "q" + d + "-9");

        var legendScale = d3
            .scaleLinear()
            .domain([0, d3.max(marqueDept, (e) => +e.nbr)])
            .range([0, 9 * 20]);

        var legendAxis = svg
            .append("g")
            .attr("transform", "translate(550, 150)")
            .call(d3.axisRight(legendScale).ticks(6));

        marqueDept.forEach(function (e, i) {
            d3.select("#d" + e.imma)
                .attr("class", (d) => "department q" + quantile(+e.nbr) + "-9")
                .on("mouseover", function (event, d) {
                    div.transition().duration(200).style("opacity", 0.9);
                    var data = geojson.features[e.imma].properties;
                    div.html(
                        "<b>Region : </b>" +
                            data.NOM_REGION +
                            "<br>" +
                            "<b>Departement : </b>" +
                            data.NOM_DEPT +
                            "<br>" +
                            "<b>Nombre de voitures : </b>" +
                            e.nbr
                    )
                        .style("left", event.pageX + 30 + "px")
                        .style("top", event.pageY - 30 + "px");
                })
                .on("mouseout", function (event, d) {
                    div.style("opacity", 0);
                    div.html("").style("left", "-500px").style("top", "-500px");
                });
        });
        d3.select("#carData").on("change", function () {
            marqueDept = [];
            for (let i = 0; i < 100; i++) {
                if (nbrMarque[i]) {
                    var val = nbrMarque[i][marqueSelected];
                    if (val) {
                        marqueDept.push({
                            imma: i,
                            nbr: val,
                        });
                    }
                }
            }
            marqueSelected = this.value;
            quantile = d3
                .scaleQuantile()
                .domain([0, d3.max(marqueDept, (e) => +e.nbr)])
                .range(d3.range(9));

            legendScale = d3
                .scaleLinear()
                .domain([0, d3.max(marqueDept, (e) => +e.nbr)])
                .range([0, 9 * 20]);
            legendAxis.call(d3.axisRight(legendScale).ticks(6));
            marqueDept.forEach(function (e, i) {
                d3.select("#d" + e.imma)
                    .attr(
                        "class",
                        (d) => "department q" + quantile(+e.nbr) + "-9"
                    )
                    .on("mouseover", function (event, d) {
                        div.transition().duration(200).style("opacity", 0.9);
                        var data = geojson.features[e.imma].properties;
                        div.html(
                            "<b>Region : </b>" +
                                data.NOM_REGION +
                                "<br>" +
                                "<b>Departement : </b>" +
                                data.NOM_DEPT +
                                "<br>" +
                                "<b>Nombre de voitures : </b>" +
                                e.nbr
                        )
                            .style("left", event.pageX + 30 + "px")
                            .style("top", event.pageY - 30 + "px");
                    })
                    .on("mouseout", function (event, d) {
                        div.style("opacity", 0);
                        div.html("")
                            .style("left", "-500px")
                            .style("top", "-500px");
                    });
            });
        });
        d3.select("#modelData").on("change", function () {
            modelDept = [];
            for (let i = 0; i < 100; i++) {
                if (nbrModel[i]) {
                    var val = nbrModel[i][modelSelected];
                    if (val) {
                        modelDept.push({
                            imma: i,
                            nbr: val,
                        });
                    }
                }
            }
            modelSelected = this.value;
            quantile = d3
                .scaleQuantile()
                .domain([0, d3.max(modelDept, (e) => +e.nbr)])
                .range(d3.range(9));

            legendScale = d3
                .scaleLinear()
                .domain([0, d3.max(modelDept, (e) => +e.nbr)])
                .range([0, 9 * 20]);
            legendAxis.call(d3.axisRight(legendScale).ticks(6));
            modelDept.forEach(function (e, i) {
                d3.select("#d" + e.imma)
                    .attr(
                        "class",
                        (d) => "department q" + quantile(+e.nbr) + "-9"
                    )
                    .on("mouseover", function (event, d) {
                        div.transition().duration(200).style("opacity", 0.9);
                        var data = geojson.features[e.imma].properties;
                        div.html(
                            "<b>Region : </b>" +
                                data.NOM_REGION +
                                "<br>" +
                                "<b>Departement : </b>" +
                                data.NOM_DEPT +
                                "<br>" +
                                "<b>Nombre de voitures : </b>" +
                                e.nbr
                        )
                            .style("left", event.pageX + 30 + "px")
                            .style("top", event.pageY - 30 + "px");
                    })
                    .on("mouseout", function (event, d) {
                        div.style("opacity", 0);
                        div.html("")
                            .style("left", "-500px")
                            .style("top", "-500px");
                    });
            });
        });
    });

    // Refresh colors on combo selection
    d3.select("select").on("change", function () {
        d3.selectAll("svg").attr("class", this.value);
    });

    // Append a DIV for the tooltip
    var div = d3
        .select("body")
        .append("div")
        .attr("class", "chart-tooltip")
        .style("opacity", 0);
}
