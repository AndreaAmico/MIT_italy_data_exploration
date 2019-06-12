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
		gara.soggetto_per_cui_agisce_la_sa = row.soggetto_per_cui_agisce_la_sa

// Responsabile
MERGE (responsabile:Responsabile {cf_rup:row.cf_rup})
	ON CREATE SET
        responsabile.rup = row.rup

// Appalto
MERGE (appalto:Appalto {tipo_appalto:row.tipo_appalto});

// Lotto
MERGE (lotto:Lotto {id_lotto: row.id_lotto})

// Committente
MERGE (committente:Committente {soggetto_per_cui_agisce_la_sa=row.soggetto_per_cui_agisce_la_sa})
;

// Creazione relazioni
// Gara - Responsabile
MATCH (r:Responsabile), (g:Gara)
WHERE
	r.cf_rup = g.cf_rup
MERGE (g)-[:REGOLATA_DA]->(r);

// Appalto - Gara
MATCH (a:Appalto), (g:Gara)
WHERE
	g.tipo_appalto = a.tipo_appalto
MERGE (g)-[:TIPOLOGIA]->(a);

// Appalto - Gara
MATCH (c:Committente), (g:Gara)
WHERE
	c.soggetto_per_cui_agisce_la_sa = g.soggetto_per_cui_agisce_la_sa
MERGE (c)-[:INDETTO]->(g);

// Rimozione campi temporanei
MATCH (g:Gara)
REMOVE g.tipo_appalto, g.cf_rup, g.soggetto_per_cui_agisce_la_sa;
