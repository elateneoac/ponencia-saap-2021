import re
import datatable
from datatable import f


clasificadas = datatable.fread('data/40-noticias-con-candidatos-clasificadas.csv')[:,:'dimensión valorativa?']
clasificadas.names = ('url', 'diario', 'seccion', 'sirve', 'dsustantiva', 'dvalorativa')
clasificadas[f.sirve == True,:]
urls = clasificadas[:, f.url].to_list()[0]

noticias = open('data/noticias.csv', 'rt')
noticias.readline()

import spacy
nlp = spacy.load('es_core_news_md')

bolsas = {}
while True:
    noticia = noticias.readline()

    if noticia == '':
        break

    url = noticia.split(',', 1)[0]
    if url not in urls:
        continue

    url, diario, seccion, fecha, titulo, texto = re.split(''',(?=(?:[^'"]|'[^']*'|"[^"]*")*$)''', noticia)

    dsustantiva, dvalorativa = clasificadas[f.url == url,(f.dsustantiva, f.dvalorativa)].to_tuples()[0]

    if dsustantiva not in bolsas:
        bolsas[dsustantiva] = {}

    if dvalorativa not in bolsas:
        bolsas[dvalorativa] = {}

    terminos = [t.lemma_.lower() for t in nlp(titulo + '.' + texto) if t.pos_ == 'NOUN' or t.pos_ == 'ADJ' or t.pos_ == 'PROPN']

    for termino in terminos:
        if termino in bolsas[dsustantiva]:
            bolsas[dsustantiva][termino] += 1
        else:
            bolsas[dsustantiva][termino] = 1

        if termino in bolsas[dvalorativa]:
            bolsas[dvalorativa][termino] += 1
        else:
            bolsas[dvalorativa][termino] = 1

for bolsa in bolsas.items():
    path = 'data/bolsa_' + bolsa[0] + '.csv'
    fbolsa = open(path)
    fbolsa.write('termino,freq\n')

    terminos = [termino for termino in bolsa[1].items()].sort(key = lambda x : x[1], reverse = True)
    for termino in terminos:
        fbolsa.write(termino[0] + ',' + str(termino[1]) + '\n')
    fbolsa.close()




