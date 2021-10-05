import datatable
from datatable import dt

candidatos = datatable.fread('data/preseleccion.csv')['Candidato/a'].to_list()[0]

filtradas = open('noticias.csv', 'rt')

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

# paso de json a csv
csv = open('medicion.csv', 'wt')
csv.write('candidato,freq\n')
for candidato, freq in medicion.items():
    fila = candidato + ',' + str(freq) + '\n'

    csv.write(fila)

csv.close()