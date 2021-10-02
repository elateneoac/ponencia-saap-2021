import json

f = open('medicion.json', 'rt')
medicion = json.load(f)
f.close()

csv = open('medicion.csv', 'wt')
csv.write('candidato,freq\n')
for candidato, freq in medicion.items():
    fila = candidato + ',' + str(freq) + '\n'

    csv.write(fila)

csv.close()