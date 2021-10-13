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

from re import search, findall

# filtradas = open('data/noticias_con_menciones.csv', 'wt')
# filtradas.write('url,diario,seccion,fecha,titulo,texto,candidatos\n')

filtradas = dt.Frame(url=[], diario=[], seccion=[],fecha=[], titulo=[], texto=[], candidatos=[])

i = 1
for url, diario, seccion, fecha, titulo, texto in csvnoticias:
    print('noticia: ' + str(i))

    if texto == '':
        i += 1
        continue

    if bool(search(regex_candidatos, titulo + texto)) == False:
        i += 1
        continue

    matcheos = findall(regex_candidatos, titulo + texto)
    fila = dt.Frame({
        "url": [url], "diario": [diario], "seccion" : [seccion], "fecha" : [fecha],
        "titulo" : [titulo], "texto" : [texto],
        "candidatos": ['|'.join(matcheos)]})

    filtradas.rbind(fila)
    i += 1


noticias.close()

filtradas.to_csv('data/noticias_con_menciones.csv')