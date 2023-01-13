
query <- "SELECT
  dbo_Anag_Reparti_ConfProp.Descrizione As strproprconf,
  {fn year(dbo.Conferimenti.Data_Accettazione)}As anno,
  dbo.Conferimenti.Numero As nconf,
  dbo.Indice_Campioni_Esaminati.Numero_Campione As ncamp,
  dbo.Anag_Reparti.Descrizione As Reparto,
  dbo.Anag_Prove.Descrizione As prova,
  dbo.Anag_Tecniche.Descrizione As Tecnica,
  dbo.Anag_Metodi_di_Prova.Descrizione As MP,
  dbo.Conferimenti_Campioni.Identificazione As identifcamp,
  dbo.Nomenclatore_Range.Valore As rangevalore,
  dbo.Nomenclatore_Range.ModEspr As modexpr,
  dbo.Nomenclatore_Range.ModEspr2 As modexpr2,
  dbo.Risultati_Analisi.Segno As segno,
  dbo.Anag_UDM.Descrizione As udm, 
  dbo.Anag_Esiti.Descrizione As esiti,
  dbo.Anag_Matrici.Descrizione As matrice,
  dbo.Anag_Comuni.Provincia As prov,
  dbo.Risultati_Analisi.Valore As valore,
  dbo_Anag_Finalita_Confer.Descrizione As finalita,
  dbo.Conferimenti.Data As dtconf,
  dbo.Anag_Comuni.Descrizione As comune ,
  dbo.Conferimenti.Data_Prelievo As dtprel,
  convert (SMALLDATETIME, dbo.Conferimenti.Data_Primo_RDP_Completo_Firmato) As dtrdp
FROM
{ oj dbo.Anag_Reparti  dbo_Anag_Reparti_ConfProp INNER JOIN dbo.Laboratori_Reparto  dbo_Laboratori_Reparto_ConfProp ON ( dbo_Laboratori_Reparto_ConfProp.Reparto=dbo_Anag_Reparti_ConfProp.Codice )
  INNER JOIN dbo.Conferimenti ON ( dbo.Conferimenti.RepLab=dbo_Laboratori_Reparto_ConfProp.Chiave )
  INNER JOIN dbo.Anag_Comuni ON ( dbo.Anag_Comuni.Codice=dbo.Conferimenti.Luogo_Prelievo )
  LEFT OUTER JOIN dbo.Anag_Matrici ON ( dbo.Conferimenti.Matrice=dbo.Anag_Matrici.Codice )
  LEFT OUTER JOIN dbo.Esami_Aggregati ON ( dbo.Conferimenti.Anno=dbo.Esami_Aggregati.Anno_Conferimento and dbo.Conferimenti.Numero=dbo.Esami_Aggregati.Numero_Conferimento )
  LEFT OUTER JOIN dbo.Nomenclatore_MP ON ( dbo.Esami_Aggregati.Nomenclatore=dbo.Nomenclatore_MP.Codice )
  LEFT OUTER JOIN dbo.Anag_Metodi_di_Prova ON ( dbo.Nomenclatore_MP.MP=dbo.Anag_Metodi_di_Prova.Codice )
  LEFT OUTER JOIN dbo.Nomenclatore_Settori ON ( dbo.Nomenclatore_MP.Nomenclatore_Settore=dbo.Nomenclatore_Settori.Codice )
  LEFT OUTER JOIN dbo.Nomenclatore ON ( dbo.Nomenclatore_Settori.Codice_Nomenclatore=dbo.Nomenclatore.Chiave )
  LEFT OUTER JOIN dbo.Anag_Prove ON ( dbo.Nomenclatore.Codice_Prova=dbo.Anag_Prove.Codice )
  LEFT OUTER JOIN dbo.Anag_Tecniche ON ( dbo.Nomenclatore.Codice_Tecnica=dbo.Anag_Tecniche.Codice )
  LEFT OUTER JOIN dbo.Laboratori_Reparto ON ( dbo.Esami_Aggregati.RepLab_analisi=dbo.Laboratori_Reparto.Chiave )
  LEFT OUTER JOIN dbo.Anag_Reparti ON ( dbo.Laboratori_Reparto.Reparto=dbo.Anag_Reparti.Codice )
  INNER JOIN dbo.Indice_Campioni_Esaminati ON ( dbo.Esami_Aggregati.Anno_Conferimento=dbo.Indice_Campioni_Esaminati.Anno_Conferimento and dbo.Esami_Aggregati.Numero_Conferimento=dbo.Indice_Campioni_Esaminati.Numero_Conferimento and dbo.Esami_Aggregati.Codice=dbo.Indice_Campioni_Esaminati.Codice )
  LEFT OUTER JOIN dbo.Risultati_Analisi ON ( dbo.Indice_Campioni_Esaminati.Anno_Conferimento=dbo.Risultati_Analisi.Anno_Conferimento and dbo.Indice_Campioni_Esaminati.Numero_Conferimento=dbo.Risultati_Analisi.Numero_Conferimento and dbo.Indice_Campioni_Esaminati.Codice=dbo.Risultati_Analisi.Codice and dbo.Indice_Campioni_Esaminati.Numero_Campione=dbo.Risultati_Analisi.Numero_Campione )
  LEFT OUTER JOIN dbo.Nomenclatore_Range ON ( dbo.Risultati_Analisi.Range=dbo.Nomenclatore_Range.Codice )
  LEFT OUTER JOIN dbo.Anag_Esiti ON ( dbo.Risultati_Analisi.Esito=dbo.Anag_Esiti.Codice )
  LEFT OUTER JOIN dbo.Nomenclatore_UDM ON ( dbo.Risultati_Analisi.UDM=dbo.Nomenclatore_UDM.Codice )
  LEFT OUTER JOIN dbo.Anag_UDM ON ( dbo.Nomenclatore_UDM.Codice_UDM=dbo.Anag_UDM.Codice )
  LEFT OUTER JOIN dbo.Conferimenti_Campioni ON ( dbo.Conferimenti_Campioni.Anno=dbo.Indice_Campioni_Esaminati.Anno_Conferimento and dbo.Conferimenti_Campioni.Numero=dbo.Indice_Campioni_Esaminati.Numero_Conferimento and dbo.Conferimenti_Campioni.Campione=dbo.Indice_Campioni_Esaminati.Numero_Campione )
  LEFT OUTER JOIN dbo.Anag_Materiali ON ( dbo.Anag_Materiali.Codice=dbo.Conferimenti.Codice_Materiale )
  INNER JOIN dbo.Conferimenti_Finalita ON ( dbo.Conferimenti.Anno=dbo.Conferimenti_Finalita.Anno and dbo.Conferimenti.Numero=dbo.Conferimenti_Finalita.Numero )
  INNER JOIN dbo.Anag_Finalita  dbo_Anag_Finalita_Confer ON ( dbo.Conferimenti_Finalita.Finalita=dbo_Anag_Finalita_Confer.Codice )
}
WHERE
dbo.Esami_Aggregati.Esame_Altro_Ente = 0
AND  dbo.Esami_Aggregati.Esame_Altro_Ente = 0
AND  (
  dbo.Anag_Matrici.Descrizione  IN  ('MUSCOLO DI BOVINO', 'MUSCOLO DI BOVINO ADULTO', 'MUSCOLO DI VITELLO', 'MUSCOLO DI VITELLONE',
  'MUSCOLO DI SUINO', 'MUSCOLO DI SUINO DA INGRASSO', 'MUSCOLO DI SUINO LATTONZOLO/MAGRONE/MAGRONCELLO', 'MUSCOLO DI SUINO RIPRODUTTORE FEMMINA', 'MUSCOLO DI SUINO RIPRODUTTORE MASCHIO',
  'MUSCOLO DI POLLO', 'MUSCOLO DI TACCHINO')
  AND  dbo.Anag_Tecniche.Descrizione  IN  ('LC-HRMS', 'LC-MS/MS')
  AND  {fn year(dbo.Conferimenti.Data)}  >=  2018
)"




# suino <- "SELECT
#   dbo_Anag_Reparti_ConfProp.Descrizione As strproprconf,
#   {fn year(dbo.Conferimenti.Data_Accettazione)}As anno,
#   dbo.Conferimenti.Numero As nconf,
#   dbo.Indice_Campioni_Esaminati.Numero_Campione As ncamp,
#   dbo.Anag_Reparti.Descrizione As Reparto,
#   dbo.Anag_Prove.Descrizione As prova,
#   dbo.Anag_Tecniche.Descrizione As Tecnica,
#   dbo.Anag_Metodi_di_Prova.Descrizione As MP,
#   dbo.Conferimenti_Campioni.Identificazione As identifcamp,
#   dbo.Nomenclatore_Range.Valore As rangevalore,
#   dbo.Nomenclatore_Range.ModEspr As modexpr,
#   dbo.Nomenclatore_Range.ModEspr2 As modexpr2,
#   dbo.Risultati_Analisi.Segno As segno,
#   dbo.Anag_UDM.Descrizione As udm, 
#   dbo.Anag_Esiti.Descrizione As esiti,
#   dbo.Anag_Matrici.Descrizione As matrice,
#   dbo.Anag_Comuni.Provincia As prov,
#   dbo.Risultati_Analisi.Valore As valore,
#   dbo_Anag_Finalita_Confer.Descrizione As finalita,
#   dbo.Conferimenti.Data As dtconf,
#   dbo.Anag_Comuni.Descrizione As comune ,
#   dbo.Conferimenti.Data_Prelievo As dtprel,
#   convert (SMALLDATETIME, dbo.Conferimenti.Data_Primo_RDP_Completo_Firmato) As dtrdp
# FROM
# { oj dbo.Anag_Reparti  dbo_Anag_Reparti_ConfProp INNER JOIN dbo.Laboratori_Reparto  dbo_Laboratori_Reparto_ConfProp ON ( dbo_Laboratori_Reparto_ConfProp.Reparto=dbo_Anag_Reparti_ConfProp.Codice )
#   INNER JOIN dbo.Conferimenti ON ( dbo.Conferimenti.RepLab=dbo_Laboratori_Reparto_ConfProp.Chiave )
#   INNER JOIN dbo.Anag_Comuni ON ( dbo.Anag_Comuni.Codice=dbo.Conferimenti.Luogo_Prelievo )
#   LEFT OUTER JOIN dbo.Anag_Matrici ON ( dbo.Conferimenti.Matrice=dbo.Anag_Matrici.Codice )
#   LEFT OUTER JOIN dbo.Esami_Aggregati ON ( dbo.Conferimenti.Anno=dbo.Esami_Aggregati.Anno_Conferimento and dbo.Conferimenti.Numero=dbo.Esami_Aggregati.Numero_Conferimento )
#   LEFT OUTER JOIN dbo.Nomenclatore_MP ON ( dbo.Esami_Aggregati.Nomenclatore=dbo.Nomenclatore_MP.Codice )
#   LEFT OUTER JOIN dbo.Anag_Metodi_di_Prova ON ( dbo.Nomenclatore_MP.MP=dbo.Anag_Metodi_di_Prova.Codice )
#   LEFT OUTER JOIN dbo.Nomenclatore_Settori ON ( dbo.Nomenclatore_MP.Nomenclatore_Settore=dbo.Nomenclatore_Settori.Codice )
#   LEFT OUTER JOIN dbo.Nomenclatore ON ( dbo.Nomenclatore_Settori.Codice_Nomenclatore=dbo.Nomenclatore.Chiave )
#   LEFT OUTER JOIN dbo.Anag_Prove ON ( dbo.Nomenclatore.Codice_Prova=dbo.Anag_Prove.Codice )
#   LEFT OUTER JOIN dbo.Anag_Tecniche ON ( dbo.Nomenclatore.Codice_Tecnica=dbo.Anag_Tecniche.Codice )
#   LEFT OUTER JOIN dbo.Laboratori_Reparto ON ( dbo.Esami_Aggregati.RepLab_analisi=dbo.Laboratori_Reparto.Chiave )
#   LEFT OUTER JOIN dbo.Anag_Reparti ON ( dbo.Laboratori_Reparto.Reparto=dbo.Anag_Reparti.Codice )
#   INNER JOIN dbo.Indice_Campioni_Esaminati ON ( dbo.Esami_Aggregati.Anno_Conferimento=dbo.Indice_Campioni_Esaminati.Anno_Conferimento and dbo.Esami_Aggregati.Numero_Conferimento=dbo.Indice_Campioni_Esaminati.Numero_Conferimento and dbo.Esami_Aggregati.Codice=dbo.Indice_Campioni_Esaminati.Codice )
#   LEFT OUTER JOIN dbo.Risultati_Analisi ON ( dbo.Indice_Campioni_Esaminati.Anno_Conferimento=dbo.Risultati_Analisi.Anno_Conferimento and dbo.Indice_Campioni_Esaminati.Numero_Conferimento=dbo.Risultati_Analisi.Numero_Conferimento and dbo.Indice_Campioni_Esaminati.Codice=dbo.Risultati_Analisi.Codice and dbo.Indice_Campioni_Esaminati.Numero_Campione=dbo.Risultati_Analisi.Numero_Campione )
#   LEFT OUTER JOIN dbo.Nomenclatore_Range ON ( dbo.Risultati_Analisi.Range=dbo.Nomenclatore_Range.Codice )
#   LEFT OUTER JOIN dbo.Anag_Esiti ON ( dbo.Risultati_Analisi.Esito=dbo.Anag_Esiti.Codice )
#   LEFT OUTER JOIN dbo.Nomenclatore_UDM ON ( dbo.Risultati_Analisi.UDM=dbo.Nomenclatore_UDM.Codice )
#   LEFT OUTER JOIN dbo.Anag_UDM ON ( dbo.Nomenclatore_UDM.Codice_UDM=dbo.Anag_UDM.Codice )
#   LEFT OUTER JOIN dbo.Conferimenti_Campioni ON ( dbo.Conferimenti_Campioni.Anno=dbo.Indice_Campioni_Esaminati.Anno_Conferimento and dbo.Conferimenti_Campioni.Numero=dbo.Indice_Campioni_Esaminati.Numero_Conferimento and dbo.Conferimenti_Campioni.Campione=dbo.Indice_Campioni_Esaminati.Numero_Campione )
#   LEFT OUTER JOIN dbo.Anag_Materiali ON ( dbo.Anag_Materiali.Codice=dbo.Conferimenti.Codice_Materiale )
#   INNER JOIN dbo.Conferimenti_Finalita ON ( dbo.Conferimenti.Anno=dbo.Conferimenti_Finalita.Anno and dbo.Conferimenti.Numero=dbo.Conferimenti_Finalita.Numero )
#   INNER JOIN dbo.Anag_Finalita  dbo_Anag_Finalita_Confer ON ( dbo.Conferimenti_Finalita.Finalita=dbo_Anag_Finalita_Confer.Codice )
# }
# WHERE
# dbo.Esami_Aggregati.Esame_Altro_Ente = 0
# AND  dbo.Esami_Aggregati.Esame_Altro_Ente = 0
# AND  (
#   dbo.Anag_Matrici.Descrizione  IN  ( 'MUSCOLO DI SUINO', 'MUSCOLO DI SUINO DA INGRASSO', 'MUSCOLO DI SUINO LATTONZOLO/MAGRONE/MAGRONCELLO', 'MUSCOLO DI SUINO RIPRODUTTORE FEMMINA', 'MUSCOLO DI SUINO RIPRODUTTORE MASCHIO')
#   AND  dbo.Anag_Tecniche.Descrizione  IN  ('LC-HRMS', 'LC-MS/MS')
#   AND  {fn year(dbo.Conferimenti.Data)}  >=  2018
# )"
# 
# 
# volatili <- "SELECT
#   dbo_Anag_Reparti_ConfProp.Descrizione As strproprconf,
#   {fn year(dbo.Conferimenti.Data_Accettazione)}As anno,
#   dbo.Conferimenti.Numero As nconf,
#   dbo.Indice_Campioni_Esaminati.Numero_Campione As ncamp,
#   dbo.Anag_Reparti.Descrizione As Reparto,
#   dbo.Anag_Prove.Descrizione As prova,
#   dbo.Anag_Tecniche.Descrizione As Tecnica,
#   dbo.Anag_Metodi_di_Prova.Descrizione As MP,
#   dbo.Conferimenti_Campioni.Identificazione As identifcamp,
#   dbo.Nomenclatore_Range.Valore As rangevalore,
#   dbo.Nomenclatore_Range.ModEspr As modexpr,
#   dbo.Nomenclatore_Range.ModEspr2 As modexpr2,
#   dbo.Risultati_Analisi.Segno As segno,
#   dbo.Anag_UDM.Descrizione As udm, 
#   dbo.Anag_Esiti.Descrizione As esiti,
#   dbo.Anag_Matrici.Descrizione As matrice,
#   dbo.Anag_Comuni.Provincia As prov,
#   dbo.Risultati_Analisi.Valore As valore,
#   dbo_Anag_Finalita_Confer.Descrizione As finalita,
#   dbo.Conferimenti.Data As dtconf,
#   dbo.Anag_Comuni.Descrizione As comune ,
#   dbo.Conferimenti.Data_Prelievo As dtprel,
#   convert (SMALLDATETIME, dbo.Conferimenti.Data_Primo_RDP_Completo_Firmato) As dtrdp
# FROM
# { oj dbo.Anag_Reparti  dbo_Anag_Reparti_ConfProp INNER JOIN dbo.Laboratori_Reparto  dbo_Laboratori_Reparto_ConfProp ON ( dbo_Laboratori_Reparto_ConfProp.Reparto=dbo_Anag_Reparti_ConfProp.Codice )
#   INNER JOIN dbo.Conferimenti ON ( dbo.Conferimenti.RepLab=dbo_Laboratori_Reparto_ConfProp.Chiave )
#   INNER JOIN dbo.Anag_Comuni ON ( dbo.Anag_Comuni.Codice=dbo.Conferimenti.Luogo_Prelievo )
#   LEFT OUTER JOIN dbo.Anag_Matrici ON ( dbo.Conferimenti.Matrice=dbo.Anag_Matrici.Codice )
#   LEFT OUTER JOIN dbo.Esami_Aggregati ON ( dbo.Conferimenti.Anno=dbo.Esami_Aggregati.Anno_Conferimento and dbo.Conferimenti.Numero=dbo.Esami_Aggregati.Numero_Conferimento )
#   LEFT OUTER JOIN dbo.Nomenclatore_MP ON ( dbo.Esami_Aggregati.Nomenclatore=dbo.Nomenclatore_MP.Codice )
#   LEFT OUTER JOIN dbo.Anag_Metodi_di_Prova ON ( dbo.Nomenclatore_MP.MP=dbo.Anag_Metodi_di_Prova.Codice )
#   LEFT OUTER JOIN dbo.Nomenclatore_Settori ON ( dbo.Nomenclatore_MP.Nomenclatore_Settore=dbo.Nomenclatore_Settori.Codice )
#   LEFT OUTER JOIN dbo.Nomenclatore ON ( dbo.Nomenclatore_Settori.Codice_Nomenclatore=dbo.Nomenclatore.Chiave )
#   LEFT OUTER JOIN dbo.Anag_Prove ON ( dbo.Nomenclatore.Codice_Prova=dbo.Anag_Prove.Codice )
#   LEFT OUTER JOIN dbo.Anag_Tecniche ON ( dbo.Nomenclatore.Codice_Tecnica=dbo.Anag_Tecniche.Codice )
#   LEFT OUTER JOIN dbo.Laboratori_Reparto ON ( dbo.Esami_Aggregati.RepLab_analisi=dbo.Laboratori_Reparto.Chiave )
#   LEFT OUTER JOIN dbo.Anag_Reparti ON ( dbo.Laboratori_Reparto.Reparto=dbo.Anag_Reparti.Codice )
#   INNER JOIN dbo.Indice_Campioni_Esaminati ON ( dbo.Esami_Aggregati.Anno_Conferimento=dbo.Indice_Campioni_Esaminati.Anno_Conferimento and dbo.Esami_Aggregati.Numero_Conferimento=dbo.Indice_Campioni_Esaminati.Numero_Conferimento and dbo.Esami_Aggregati.Codice=dbo.Indice_Campioni_Esaminati.Codice )
#   LEFT OUTER JOIN dbo.Risultati_Analisi ON ( dbo.Indice_Campioni_Esaminati.Anno_Conferimento=dbo.Risultati_Analisi.Anno_Conferimento and dbo.Indice_Campioni_Esaminati.Numero_Conferimento=dbo.Risultati_Analisi.Numero_Conferimento and dbo.Indice_Campioni_Esaminati.Codice=dbo.Risultati_Analisi.Codice and dbo.Indice_Campioni_Esaminati.Numero_Campione=dbo.Risultati_Analisi.Numero_Campione )
#   LEFT OUTER JOIN dbo.Nomenclatore_Range ON ( dbo.Risultati_Analisi.Range=dbo.Nomenclatore_Range.Codice )
#   LEFT OUTER JOIN dbo.Anag_Esiti ON ( dbo.Risultati_Analisi.Esito=dbo.Anag_Esiti.Codice )
#   LEFT OUTER JOIN dbo.Nomenclatore_UDM ON ( dbo.Risultati_Analisi.UDM=dbo.Nomenclatore_UDM.Codice )
#   LEFT OUTER JOIN dbo.Anag_UDM ON ( dbo.Nomenclatore_UDM.Codice_UDM=dbo.Anag_UDM.Codice )
#   LEFT OUTER JOIN dbo.Conferimenti_Campioni ON ( dbo.Conferimenti_Campioni.Anno=dbo.Indice_Campioni_Esaminati.Anno_Conferimento and dbo.Conferimenti_Campioni.Numero=dbo.Indice_Campioni_Esaminati.Numero_Conferimento and dbo.Conferimenti_Campioni.Campione=dbo.Indice_Campioni_Esaminati.Numero_Campione )
#   LEFT OUTER JOIN dbo.Anag_Materiali ON ( dbo.Anag_Materiali.Codice=dbo.Conferimenti.Codice_Materiale )
#   INNER JOIN dbo.Conferimenti_Finalita ON ( dbo.Conferimenti.Anno=dbo.Conferimenti_Finalita.Anno and dbo.Conferimenti.Numero=dbo.Conferimenti_Finalita.Numero )
#   INNER JOIN dbo.Anag_Finalita  dbo_Anag_Finalita_Confer ON ( dbo.Conferimenti_Finalita.Finalita=dbo_Anag_Finalita_Confer.Codice )
# }
# WHERE
# dbo.Esami_Aggregati.Esame_Altro_Ente = 0
# AND  dbo.Esami_Aggregati.Esame_Altro_Ente = 0
# AND  (
#   dbo.Anag_Matrici.Descrizione  IN  ('MUSCOLO DI POLLO', 'MUSCOLO DI TACCHINO')
#   AND  dbo.Anag_Tecniche.Descrizione  IN  ('LC-HRMS', 'LC-MS/MS')
#   AND  {fn year(dbo.Conferimenti.Data)}  >=  2018
# )"
