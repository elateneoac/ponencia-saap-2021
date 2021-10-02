import datatable
from datatable import dt

candidatos = datatable.fread('data/preseleccion.csv')['Candidato/a'].to_list()[0]

filtradas = open('filtradas.csv', 'rt')

medicion = {}
i = 1
while True:
    print('noticia ' + str(i))
    fila = filtradas.readline()

    if fila == '':
        break

    for candidato in candidatos:
        apariciones = fila.count(candidato)

        if apariciones == 0:
            continue

        if candidato in medicion:
            medicion[candidato] += apariciones
        else:
            medicion[candidato] = apariciones

    i += 1

filtradas.close()

import json

salida = open('medicion.json', 'wt')
json.dump(medicion, salida)
salida.close()
