import datatable
from datatable import f, dt
candidatos = datatable.fread('data/medicion.csv')[f.freq > 100, f.candidato].to_list()[0]
regex_candidatos = '|'.join(candidatos)

noticias = open('data/noticias.csv', 'rt')
noticias.readline()

import csv
import sys
csv.field_size_limit(sys.maxsize)
csvnoticias = csv.reader(noticias)

import spacy
nlp = spacy.load('es_core_news_md')

from nltk.tokenize import sent_tokenize as oracionador

from re import search, findall

i = 1
doraciones = dt.Frame(
              diario=[], seccion=[],
              sustantivos=[], adjetivos=[], verbos=[],
              candidatos=[])

for url, diario, seccion, fecha, titulo, texto in csvnoticias:
    print('noticia: ' + str(i))

    if texto == '':
        i += 1
        continue

    if bool(search(regex_candidatos, titulo + texto)) == False:
        i += 1
        continue

    for oracion in oracionador(texto):
        matcheos = findall(regex_candidatos, oracion)
        if len(matcheos) == 0:
            continue

        tokens = nlp(oracion)
        sustantivos = ','.join([t.lemma_.lower() for t in tokens if t.pos_ is 'NOUN'])
        adjetivos = ','.join([t.lemma_.lower() for t in tokens if t.pos_ is 'ADJ'])
        verbos = ','.join([t.lemma_.lower() for t in tokens if t.pos_ is 'VERB'])
        candidatos = ','.join(matcheos)

        fila = dt.Frame({"diario": [diario], "seccion" : [seccion],
                         "sustantivos" : [sustantivos], "adjetivos" : [adjetivos], "verbos" : [verbos],
                         "candidatos": [candidatos]})

        doraciones.rbind(fila)
    
    i += 1


doraciones.to_csv('data/oraciones.csv')    