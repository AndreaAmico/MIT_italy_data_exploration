// Caricamento small csv
LOAD CSV WITH HEADERS
FROM 'https://raw.githubusercontent.com/AndreaAmico/MIT_italy_data_exploration/master/data/small.dat'
AS row

// Creazione nodi base
// Gara
MERGE (gara:Gara {id_gara:row.id_gara, oggetto_della_gara:row.oggetto_della_gara})
	ON CREATE SET
		gara.cf_rup = row.cf_rup,
		gara.tipo_appalto = row.tipo_appalto

// Responsabile
MERGE (responsabile:Responsabile {rup:row.rup, cf_rup:row.cf_rup})
	ON CREATE SET responsabile.id_gara = row.id_gara

// Appalto
MERGE (appalto:Appalto {tipo_appalto:row.tipo_appalto, id_lotto:row.id_lotto})

// Creazione relazioni
// Gara - Responsabile
MATCH (r:Responsabile), (g:Gara)
WHERE
	r.cf = g.resp AND
	g.id = r.gara
MERGE (g)-[:REGOLATA_DA]->(r)
REMOVE g.resp, r.gara;
// Appalto - Gara
MATCH (a:Appalto), (g:Gara)
WHERE
	g.tipo_appalto = a.tipo_appalto
MERGE (a)-[:ASSEGNATO_DA]->(g)
REMOVE g.tipo_appalto

