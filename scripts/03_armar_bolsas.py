import re
import datatable
from datatable import f

clasificadas = datatable.fread('data/40-noticias-con-candidatos-clasificadas.csv')[:,:'dimensión valorativa?']
clasificadas.names = ('url', 'diario', 'seccion', 'sirve', 'dsustantiva', 'dvalorativa')
urls = clasificadas[f.sirve == True, f.url].to_list()[0]

noticias = open('data/noticias.csv', 'rt')
noticias.readline()

import csv
import sys
csv.field_size_limit(sys.maxsize)
csvnoticias = csv.reader(noticias)

import spacy
nlp = spacy.load('es_core_news_md')

bolsas = {}
i = 1
# while True:
for url, diario, seccion, fecha, titulo, texto in csvnoticias:
    print('noticia: ' + str(i))

    if texto == '':
        continue

    if url not in urls:
        i += 1
        continue

    dsustantiva, dvalorativa = clasificadas[f.url == url,(f.dsustantiva, f.dvalorativa)].to_tuples()[0]

    if dsustantiva not in bolsas:
        bolsas[dsustantiva] = {}

    if dvalorativa not in bolsas:
        bolsas[dvalorativa] = {}

    for t in nlp(titulo + '.' + texto):
        termino = ''
        if t.pos_ == 'NOUN' or t.pos_ == 'ADJ':
            termino = t.lemma_.lower()

        if termino == '':
            continue

        if termino in bolsas[dsustantiva]:
            bolsas[dsustantiva][termino] += 1
        else:
            bolsas[dsustantiva][termino] = 1

        if termino in bolsas[dvalorativa]:
            bolsas[dvalorativa][termino] += 1
        else:
            bolsas[dvalorativa][termino] = 1

    i += 1

for bolsa in bolsas.items():
    path = 'data/bolsa_' + bolsa[0] + '.csv'
    fbolsa = open(path, 'wt')
    fbolsa.write('termino,freq\n')

    terminos = [termino for termino in bolsa[1].items() if termino[1] > 3]
    terminos.sort(key = lambda x : x[1], reverse = True)
    for termino in terminos:
        fbolsa.write(termino[0] + ',' + str(termino[1]) + '\n')
    fbolsa.close()




