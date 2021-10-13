library(data.table)
library(stringr)

data = '~/repos/elateneoac/ponencia-saap-2021/data/'

# levanto oraciones preprocesadas
oraciones = fread(paste0(data,'oraciones.csv'))

# levanto las bolsas de palabras de los atributos y las junto cada una en una expresion regulares para dsp calcular la distancias de jaccard.
bolsa_etica = fread(paste0(data,'bolsa_etica.csv'))[`bolsa?` == 'si', termino]
regex_etica = str_c(bolsa_etica, collapse='|')

bolsa_gestion = fread(paste0(data,'bolsa_gestion.csv'))[`bolsa?` == 'si', termino]
regex_gestion = str_c(bolsa_gestion, collapse='|')

bolsa_ideologia = fread(paste0(data,'bolsa_ideologia.csv'))[`bolsa?` == 'si', termino]
regex_ideologia = str_c(bolsa_ideologia, collapse='|')

bolsa_personalidad = fread(paste0(data,'bolsa_personalidad.csv'))[`bolsa?` == 'si', termino]
regex_personalidad = str_c(bolsa_personalidad, collapse='|')

bolsa_positiva = fread(paste0(data,'bolsa_positiva.csv'))[`bolsa?` == 'si', termino]
regex_positiva = str_c(bolsa_positiva, collapse='|')

bolsa_negativa = fread(paste0(data,'bolsa_negativa.csv'))[`bolsa?` == 'si', termino]
regex_negativa = str_c(bolsa_negativa, collapse='|')

## calculo distancia de jaccard para cada atributo

# primero cuento la cantidad total de terminos
oraciones[, terminos := str_c(sustantivos, adjetivos, verbos, sep=',')]

# distancia a 'etica'
oraciones[, etica := str_count(terminos, regex_etica)] # interseccion
oraciones[, etica := etica / (str_count(terminos, '[^,],[^,]') + 1 + str_count(regex_etica, '\\|') + 1 - etica)] # interseccion / union

# distancia a 'gestion'
oraciones[, gestion := str_count(terminos, regex_gestion)]
oraciones[, gestion := gestion / (str_count(terminos, '[^,],[^,]') + 1 + str_count(regex_gestion, '\\|') + 1 - gestion)]

# distancia a 'ideologia'
oraciones[, ideologia := str_count(terminos, regex_ideologia)]
oraciones[, ideologia := ideologia / (str_count(terminos, '[^,],[^,]') + 1 + str_count(regex_ideologia, '\\|') + 1 - ideologia)]

# distancia a 'personalidad'
oraciones[, personalidad := str_count(terminos, regex_personalidad)]
oraciones[, personalidad := personalidad / (str_count(terminos, '[^,],[^,]') + 1 + str_count(regex_personalidad, '\\|') + 1 - personalidad)]

# distancia a 'positiva'
oraciones[, positiva := str_count(terminos, regex_positiva)]
oraciones[, positiva := positiva / (str_count(terminos, '[^,],[^,]') + 1 + str_count(regex_positiva, '\\|') + 1 - positiva)]

# distancia a 'negativa'
oraciones[, negativa := str_count(terminos, regex_negativa)]
oraciones[, negativa := negativa / (str_count(terminos, '[^,],[^,]') + 1 + str_count(regex_negativa, '\\|') + 1 - negativa)]

# seteo las dimensiones de cada oración
oraciones[, dsustantiva := colnames(.SD)[max.col(.SD)], .SDcols = 8:11]
oraciones[, dvalorativa := colnames(.SD)[max.col(.SD)], .SDcols = 12:13]

# corrijo las oraciones que son de 'otras' dimensiones

## calculo promedios de cada dimensión
promedios = oraciones[, .(etica = mean(etica),
                          gestion = mean(gestion),
                          ideologia = mean(ideologia),
                          personalidad = mean(personalidad),
                          negativa = mean(negativa),
                          positiva = mean(positiva))]

## seteo en 0 los valores que no superen al promedio
oraciones[etica < promedios$etica, etica := 0]
oraciones[gestion < promedios$gestion, gestion := 0]
oraciones[personalidad < promedios$personalidad, personalidad := 0]
oraciones[ideologia < promedios$ideologia, ideologia := 0]
oraciones[negativa < promedios$negativa, negativa := 0]
oraciones[positiva < promedios$positiva, positiva := 0]

## seteo en 'otra' la dimensión sustantiva que no sea de ninguna de las cuatro
oraciones[ideologia + gestion + etica + personalidad == 0, dsustantiva := 'otras']

## seteo en 'otra' la dimensión valorativa que no sea de ninguna de las cuatro
oraciones[positiva + negativa == 0, dvalorativa := 'neutra']

# guardo
fwrite(oraciones, paste0(data,'oraciones_clasificadas.csv'))

# gráfico de torta de atributos de Ginés
pie(table(oraciones[candidatos == 'María Eugenia Vidal', dsustantiva]), main = 'Sustantivos de Mariu')
pie(table(oraciones[candidatos == 'Victoria Tolosa Paz', dsustantiva]), main = 'Sustantivos de Tolosa Paz')

pie(table(oraciones[candidatos == 'María Eugenia Vidal', dvalorativa]), main = 'Valoraciones de Mariu')

# soria = oraciones[candidatos == 'Victoria Tolosa Paz'][, .(etica = sum(etica), gestion = sum(gestion), personalidad = sum(personalidad), ideologia = sum(ideologia), positiva = sum(positiva), negativa = sum(negativa)), keyby = candidatos]
# pie(unlist(soria[,.(etica, gestion, personalidad, ideologia)]), main = 'Atributos de Tolosa Paz')
# pie(unlist(soria[,.(positiva, negativa)]), main = 'Atributos de Tolosa Paz')
