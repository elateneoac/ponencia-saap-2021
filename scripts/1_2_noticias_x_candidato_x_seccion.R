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

path_data = '~/repos/elateneoac/ponencia-saap-2021/data' # path a la carpeta 'ponencia-unl/data'

notis = fread(paste0(path_data,'/noticias_con_menciones.csv'), select = c('diario','seccion','candidatos'))[seccion %in% c('politica', 'economia', 'sociedad','internacional', 'espectaculos', 'deportes','cultura')]

## 1.2  noticias x ministrx
lcandidatos = unique(unlist(str_split(unlist(notis[, candidatos]), pattern = fixed('|'))))
ldiarios = unique(notis[,diario])
lsecciones = unique(notis[seccion != 'cultura',seccion])

conteo_candidatos = data.table()
for(c in lcandidatos) {
  for(d in ldiarios) {
    for(s in lsecciones){
      aux = notis[diario == d & seccion == s, .(candidato = c,
                                            diario = d,
                                            seccion = s,
                                            n = sum(str_count(candidatos, c)))]
      conteo_candidatos = rbind(conteo_candidatos, aux)
    }
    aux = notis[diario == d,
                .(candidato = c,
                  diario = d,
                  seccion = 'Total',
                  n = sum(str_count(candidatos, c)))]
    conteo_candidatos = rbind(conteo_candidatos, aux)
  }
}

# conteo_ministros[ministro == 'kulfas', ministro := 'Kulfas']
# conteo_ministros[ministro == 'trotta', ministro := 'Trotta']
# conteo_ministros[ministro == 'soria', ministro := 'Soria']
# conteo_ministros[ministro == 'sola', ministro := 'Solá']
# conteo_ministros[ministro == 'salvarezza', ministro := 'Salvarezza']
# conteo_ministros[ministro == 'rossi', ministro := 'Rossi']
# conteo_ministros[ministro == 'moroni', ministro := 'Moroni']
# conteo_ministros[ministro == 'meoni', ministro := 'Meoni']
# conteo_ministros[ministro == 'losardo', ministro := 'Losardo']
# conteo_ministros[ministro == 'lammens', ministro := 'Lammens']
# conteo_ministros[ministro == 'katopodis', ministro := 'Katopodis']
# conteo_ministros[ministro == 'guzman', ministro := 'Guzmán']
# conteo_ministros[ministro == 'gomezalcorta', ministro := 'G. Alcorta']
# conteo_ministros[ministro == 'gines', ministro := 'Ginés G.G.']
# conteo_ministros[ministro == 'frederic', ministro := 'Frederic']
# conteo_ministros[ministro == 'ferraresi', ministro := 'Ferraresi']
# conteo_ministros[ministro == 'depedro', ministro := 'De Pedro']
# conteo_ministros[ministro == 'cafiero', ministro := 'Cafiero']
# conteo_ministros[ministro == 'cabandie', ministro := 'Cabandié']
# conteo_ministros[ministro == 'bielsa', ministro := 'M. E. Bielsa']
# conteo_ministros[ministro == 'bauer', ministro := 'Bauer']
# conteo_ministros[ministro == 'basterra', ministro := 'Basterra']
# conteo_ministros[ministro == 'arroyo', ministro := 'Arroyo']
# conteo_ministros[ministro == 'vizzotti', ministro := 'Vizzotti']
conteo_candidatos[diario == 'clarin', diario := 'Clarín']
conteo_candidatos[diario == 'lanacion', diario := 'La Nación']
conteo_candidatos[diario == 'infobae', diario := 'Infobae']
conteo_candidatos[diario == 'paginadoce', diario := 'Página 12']
conteo_candidatos[diario == 'ambito', diario := 'Ámbito']
conteo_candidatos[seccion == 'politica', seccion := 'Política']
conteo_candidatos[seccion == 'economia', seccion := 'Economía']
conteo_candidatos[seccion == 'sociedad', seccion := 'Sociedad']
conteo_candidatos[seccion == 'internacional', seccion := 'Internacional']
conteo_candidatos[seccion == 'espectaculos', seccion := 'Espectáculos']
conteo_candidatos[seccion == 'deportes', seccion := 'Deportes']
conteo_candidatos[seccion == 'cultura', seccion := 'Cultura']

listas = list(list('nombre' = 'JXC', 'candidatos' = c('María Eugenia Vidal', 'Martín Tetaz', 'Ricardo López Murphy', 'Graciela Ocaña', 'Facundo Manes', 'Diego Santilli', 'Adolfo Rubinstein', 'Sandra Pitta'), 'color' = '#FFD500', 'orden' = 1),
              list('nombre' = 'FDT', 'candidatos' = c('Victoria Tolosa Paz', 'Leandro Santoro', 'Daniel Gollan', 'Gisela Marziotta'), 'color' = 'darkcyan', 'orden' = 2),
              list('nombre' = 'Izquierda', 'candidatos' = c('Nicolás del Caño', 'Myriam Bregman', 'Manuela Castañeira'), 'color' = 'darkred', 'orden' = 3),
              list('nombre' = 'Libertarios', 'candidatos' = c('José Luis Espert', 'Javier Milei', 'Carolina Píparo'), 'color' = 'purple', 'orden' = 4))

conteo_candidatos[, color := 'darkgrey']
for(lista in listas) {
  conteo_candidatos[candidato %in% lista$candidatos, color := lista$color]
  conteo_candidatos[candidato %in% lista$candidatos, orden := lista$orden]
}

ggplot(conteo_candidatos[seccion %in% c('Economía', 'Política', 'Sociedad', 'Espectáculos', 'Total')], aes(x = candidato, y = n), colour = diario) +
  geom_linerange(aes(x = candidato, ymin = 0, ymax = n, colour = diario),
                 position = position_dodge(width = 0.6)) +
  geom_point(aes(colour = diario),
             position = position_dodge(width = 0.6), size=1, alpha=1) +
  coord_flip() +
  labs(title = "¿Candidatxs más mencionadxs? Marzo 2020 ~ Septiembre 2021", x = "", y = "Cantidad de noticias") + 
  theme_pander(nomargin = F) +
  scale_y_continuous(n.breaks = 3) + 
  scale_color_manual(values = c('Clarín' = 'red', 'Infobae' = 'orange', 'La Nación'  = 'blue', 'Página 12' = 'darkcyan', 'Ámbito' = 'darkgrey')) + 
  facet_grid(~seccion)
# ggsave(filename = '~/Documentos/ponencia-ateneo/dibujos/1_2_noticias_ministro_diario_seccion.jpeg')