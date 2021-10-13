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

path_data = '~/repos/elateneoac/ponencia-saap-2021/data/' # path a la carpeta 'ponencia-saap-2021/data'

notis = fread(paste0(path_data,'/noticias_con_menciones.csv'), select = c('diario', 'seccion'))[seccion %in% c('politica', 'economia', 'sociedad','internacional', 'espectaculos', 'deportes','cultura')]

## 1.1. noticias x diario x sección
notis_1_1 = notis[, .(n = .N), keyby = .(diario,seccion)]

notis_1_1[diario == 'clarin', diario := 'Clarín']
notis_1_1[diario == 'lanacion', diario := 'La Nación']
notis_1_1[diario == 'infobae', diario := 'Infobae']
notis_1_1[diario == 'paginadoce', diario := 'Página 12']
notis_1_1[diario == 'ambito', diario := 'Ámbito']

notis_1_1 = notis_1_1[seccion %in% c('politica', 'economia', 'sociedad','internacional', 'espectaculos', 'deportes','cultura')]
notis_1_1[seccion == 'politica', seccion := 'Política']
notis_1_1[seccion == 'economia', seccion := 'Economía']
notis_1_1[seccion == 'sociedad', seccion := 'Sociedad']
notis_1_1[seccion == 'internacional', seccion := 'Internacional']
notis_1_1[seccion == 'espectaculos', seccion := 'Espectáculos']
notis_1_1[seccion == 'deportes', seccion := 'Deportes']
notis_1_1[seccion == 'cultura', seccion := 'Cultura']

# fwrite(notis_1_1, paste0(path_data,'/menciones_x_seccion.csv'))

# notis_1_1[seccion == 'Internacional' & diario == 'Infobae', n := 0]
# notis_1_1[seccion == 'Sociedad' & diario == 'La Nación', n := 0]

ggplot(notis_1_1, aes(x = reorder(seccion,n), y = n), colour = 'red') +
  geom_bar(stat = 'identity', width = 0.5, fill = '#1B9E77', colour = 'black') + 
  facet_grid(~diario) + 
  theme_pander(nomargin = F) +
  scale_y_continuous(n.breaks = 2) + 
  labs(title = "¿Secciones con más menciones a candidatxs?", x = "", y = "Cantidad de noticias") +
  coord_flip()

#ggsave(filename = '~/Documentos/ponencia-ateneo/dibujos/1_1_noticias_diario_seccion.jpeg')