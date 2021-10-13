library(data.table)
library(jsonlite)
library(stringr)
library(ggplot2)
library(ggpubr)
library(ggthemes)
library(ggExtra)
library(treemap)

# 1. General
paleta = 'Dark2'

path_data = '~/repos/elateneoac/ponencia-saap-2021/data/' # path a la carpeta 'ponencia-unl/data'

oraciones = fread(paste0(path_data,'/oraciones_clasificadas.csv'))

## 3.2. Para cada uno de lxs ministrxs
oraciones_por_candidato = oraciones[str_detect(candidatos, ',', negate = T)]

oraciones_por_candidato = oraciones_por_candidato[dsustantiva == 'etica', dsustantiva := 'Ética']
oraciones_por_candidato = oraciones_por_candidato[dsustantiva == 'gestion', dsustantiva := 'Gestión']
oraciones_por_candidato = oraciones_por_candidato[dsustantiva == 'personalidad', dsustantiva := 'Personalidad']
oraciones_por_candidato = oraciones_por_candidato[dsustantiva == 'ideologia', dsustantiva := 'Ideología']
oraciones_por_candidato = oraciones_por_candidato[dsustantiva == 'otras', dsustantiva := 'Otras']

oraciones_por_candidato = oraciones_por_candidato[dvalorativa == 'positiva', dvalorativa := 'Positiva']
oraciones_por_candidato = oraciones_por_candidato[dvalorativa == 'negativa', dvalorativa := 'Negativa']
oraciones_por_candidato = oraciones_por_candidato[dvalorativa == 'neutra', dvalorativa := 'Neutral']

dsustantiva_por_candidato = oraciones_por_candidato[,
                                                  .('sustantiva' = .N,
                                                    dsustantiva),
                                                  by = .(candidatos, dsustantiva)][
                                                    , .('porcentaje' = sustantiva * 100/ sum(sustantiva),
                                                        'atributo' = dsustantiva),
                                                    by = candidatos
                                                    ]
dsustantiva_por_candidato = setnames(dsustantiva_por_candidato, 'candidatos', 'candidato')

dvalorativa_por_candidato = oraciones_por_candidato[,
                                                  .('valorativa' = .N,
                                                    dvalorativa),
                                                  by = .(candidatos, dvalorativa)][
                                                    , .('porcentaje' = valorativa * 100/ sum(valorativa),
                                                        'atributo' = dvalorativa),
                                                    by = candidatos
                                                    ]
dvalorativa_por_candidato = setnames(dvalorativa_por_candidato, 'candidatos', 'candidato')

listas = list(list('nombre' = 'JXC', 'candidatos' = c('María Eugenia Vidal', 'Martín Tetaz', 'Ricardo López Murphy', 'Graciela Ocaña', 'Facundo Manes', 'Diego Santilli', 'Adolfo Rubinstein', 'Sandra Pitta'), 'color' = '#FFD500', 'orden' = 1),
              list('nombre' = 'FDT', 'candidatos' = c('Victoria Tolosa Paz', 'Leandro Santoro', 'Daniel Gollan', 'Gisela Marziotta'), 'color' = 'darkcyan', 'orden' = 2),
              list('nombre' = 'Izquierda', 'candidatos' = c('Nicolás del Caño', 'Myriam Bregman', 'Manuela Castañeira'), 'color' = 'darkred', 'orden' = 3),
              list('nombre' = 'Libertarios', 'candidatos' = c('José Luis Espert', 'Javier Milei', 'Carolina Píparo'), 'color' = 'purple', 'orden' = 4))

dsustantiva_por_candidato[, color := 'darkgrey']
dsustantiva_por_candidato[, orden := 5]
dvalorativa_por_candidato[, color := 'darkgrey']
dvalorativa_por_candidato[, orden := 5]
for(lista in listas) {
  dsustantiva_por_candidato[candidato %in% lista$candidatos, color := lista$color]
  dsustantiva_por_candidato[candidato %in% lista$candidatos, orden := lista$orden]
  dvalorativa_por_candidato[candidato %in% lista$candidatos, color := lista$color]
  dvalorativa_por_candidato[candidato %in% lista$candidatos, orden := lista$orden]
}

candidatos_ordenados = unique(dsustantiva_por_candidato[order(orden), candidato])
candidatos_ordenados_para_color = unique(dsustantiva_por_candidato[, candidato])
atributos_sustantivos_ordenados = c('Personalidad', 'Ideología', 'Gestión', 'Ética', 'Otras')

ggplot(dsustantiva_por_candidato, aes(x = factor(candidato, levels=rev(candidatos_ordenados)), y = porcentaje)) +
  geom_bar(stat = 'identity', width = 0.5, fill = dsustantiva_por_candidato[order(factor(atributo, levels=atributos_sustantivos_ordenados), factor(candidato, levels=candidatos_ordenados_para_color)), color], colour = 'black') + 
  theme_pander(nomargin = F) +
  scale_y_continuous(n.breaks = 3) + 
  labs(title = "Asignación de atributos sustantivos por candidatx", x = "", y = "%") +
  facet_grid(~factor(atributo, levels = atributos_sustantivos_ordenados)) + 
  coord_flip()
# ggsave(filename = '~/Documentos/ponencia-ateneo/dibujos/3_2_sustantiva_por_candidato.jpeg')

atributos_valorativos_ordenados = c('Positiva', 'Negativa', 'Neutral')

ggplot(dvalorativa_por_candidato, aes(x = factor(candidato, levels=rev(candidatos_ordenados)), y = porcentaje)) +
  geom_bar(stat = 'identity', width = 0.5, fill = dvalorativa_por_candidato[order(factor(atributo, levels=atributos_valorativos_ordenados), factor(candidato, levels=candidatos_ordenados_para_color)), color], colour = 'black') + 
  theme_pander(nomargin = F) +
  scale_y_continuous(n.breaks = 3) + 
  labs(title = "Asignación de atributos valorativos por candidatx", x = "", y = "%") +
  facet_grid(~factor(atributo, levels = atributos_valorativos_ordenados)) + 
  coord_flip()

# ggplot(dvalorativa_por_candidato, aes(x = reorder(candidato,porcentaje), y = porcentaje)) +
#   geom_bar(stat = 'identity', width = 0.5, fill = '#1B9E77', colour = 'black') + 
#   facet_grid(~atributo) + 
#   theme_pander(nomargin = F) +
#   scale_y_continuous(n.breaks = 3) + 
#   labs(title = "Asignación de atributos valorativos por candidato", x = "", y = "%") +
#   coord_flip()
# ggsave(filename = '~/Documentos/ponencia-ateneo/dibujos/3_2_valorativa_por_candidato.jpeg')