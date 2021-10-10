from re import search

noticias = open('data/noticias.csv', 'rt')

import datatable
from datatable import f
candidatos = datatable.fread('data/medicion.csv')[f.freq > 100, f.candidato].to_list()[0]

# descarto la primer linea con el nombre de las columnas, creo el encabezado en las selecionadas
noticias.readline()

i = 1
seleccionadas = []
while True:
    print('noticia ' + str(i))
    fila = noticias.readline()

    if fila == '':
        break

    try:
        url, diario, seccion, fecha, titulo_y_texto = fila.split(',', 4)
    except Exception:
        print('fila:' + fila)
        i += 1
        continue

    # if 'https://www.lanacion.com.ar/sociedad/coronavirus-en-' not in url and 'lifestyle' not in url:
    seccion_importante = seccion in ['politica', 'economia', 'sociedad']
    menciona_candidato = bool(search('|'.join(candidatos), titulo_y_texto))

    if seccion_importante and menciona_candidato:
       seleccionadas.append(','.join([url, diario, seccion]) + '\n')

    i += 1

noticias.close()

import random
random.shuffle(seleccionadas)


las_cuarenta = open('data/40_urls.csv', 'wt')
las_cuarenta.write('url,diario,seccion\n')

for seleccionada in seleccionadas[:40]:
    las_cuarenta.write(seleccionada)
las_cuarenta.close()

