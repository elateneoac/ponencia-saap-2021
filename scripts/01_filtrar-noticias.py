
todas = open('noticias.csv', 'rt')
filtradas = open('filtradas.csv', 'wt')

# leo el encabezado y lo escribo en el nuevo csv
filtradas.write(todas.readline())

# diarios a analizar
a_analizar = ['infobae', 'clarin', 'lanacion', 'paginadoce', 'ambito']

i = 1
while True:
    print('noticia ' + str(i))
    fila = todas.readline()

    if fila == '':
        break

    diario = fila[:fila.find(',')]
    
    if diario in a_analizar:
        filtradas.write(fila)
    
    i += 1

todas.close()
filtradas.close()
