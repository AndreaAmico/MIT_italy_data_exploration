LOAD CSV WITH HEADERS
FROM 'https://raw.githubusercontent.com/AndreaAmico/MIT_italy_data_exploration/master/data/small.dat'
AS row
MERGE (:Gara {id:row.id_gara, oggetto:row.oggetto_della_gara, resp:row.cf_rup})
MERGE (:Responsabile {rup:row.rup, cf:row.cf_rup, gara:row.id_gara});
MATCH (r:Responsabile), (g:Gara)
WHERE
	r.cf = g.resp AND
	g.id = r.gara
MERGE (g)-[:REGOLATA_DA]->(r)
REMOVE g.resp, r.gara
