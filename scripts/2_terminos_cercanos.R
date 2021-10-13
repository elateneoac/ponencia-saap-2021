library(data.table)
library(jsonlite)
library(stringr)
library(ggplot2)
library(ggpubr)
library(ggthemes)
library(ggExtra)
library(treemap)
library(gridExtra)

# 1. General
paleta = 'Dark2'

path_data = '~/repos/elateneoac/ponencia-saap-2021/data/' # path a la carpeta 'ponencia-unl/data'

oraciones = fread(paste0(path_data,'/oraciones_clasificadas.csv'))

# 2. Casos puntuales: adjetivos cercanos
basura = c('','"','“', '”', '‘', '’', '-', ']', '[', '-', '–')
freqs = function(oraciones, que, quien) {
  
  frecuencias = as.data.table(
    table(
      unlist(
        str_split(
          oraciones[candidatos == quien, get(que)], ','))))[!(V1 %in% basura)][order(-N)]
  
  return(setnames(frecuencias, 'V1', 'termino'))
}

adjetivos_comunes = as.data.table(table(unlist(str_split(oraciones[, adjetivos], ','))))[!(V1 %in% basura)][order(-N)][1:15, V1]
sustantivos_comunes = as.data.table(table(unlist(str_split(oraciones[, sustantivos], ','))))[!(V1 %in% basura)][order(-N)][1:15, V1]
terminos_comunes = c(adjetivos_comunes, sustantivos_comunes)

ggterminos = function(terminos, nombre) {
  
  filtrados = terminos[!termino %in% sustantivos_comunes]
  
  p = ggbarplot(filtrados[1:15],
                x = 'termino',
                y = 'N',
                fill = 'tipo',
                width = 0.5,
                palette = paleta,
                sort.val = 'asc',
                sort.by.groups = F,
                rotate = T,
                title = paste0("Cerca a ", nombre),
                ggtheme = theme_pander(nomargin = F),
                xlab = "",
                ylab = "Cantidad de menciones")
  return(p)
}

## 2.1. María Eugneia Vidal, Facundo Manes, Diego Santilli
candidate = 'María Eugenia Vidal'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

ggvidal = ggterminos(terminos, candidate)

candidate = 'Facundo Manes'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

ggmanes = ggterminos(terminos, candidate)

candidate = 'Diego Santilli'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

ggsantilli = ggterminos(terminos, candidate)

grid.arrange(ggvidal, ggmanes, ggsantilli, ncol = 3)

## 2.2. Victoria Tolosa Paz, Leandro Santoro, Daniel Gollan
candidate = 'Victoria Tolosa Paz'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

ggtolosapaz = ggterminos(terminos, candidate)

candidate = 'Leandro Santoro'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

ggsantoro = ggterminos(terminos, candidate)

candidate = 'Daniel Gollan'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

gggollan = ggterminos(terminos, candidate)

grid.arrange(ggtolosapaz, ggsantoro, gggollan, ncol = 3)

## 2.3. Nicolás del Caño, Myriam Bregman, Manuela Castañeira
candidate = 'Nicolás del Caño'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

ggdelcaño = ggterminos(terminos, candidate)

candidate = 'Myriam Bregman'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

ggbregman = ggterminos(terminos, candidate)

candidate = 'Manuela Castañeira'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

ggcastañeira = ggterminos(terminos, candidate)

grid.arrange(ggdelcaño, ggbregman, ggcastañeira, ncol = 3)

## 2.4. José Luis Espert, Javier Milei, Carolina Píparo
candidate = 'José Luis Espert'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

ggespert = ggterminos(terminos, candidate)

candidate = 'Javier Milei'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

ggmilei = ggterminos(terminos, candidate)

candidate = 'Carolina Píparo'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

ggpiparo = ggterminos(terminos, candidate)

grid.arrange(ggespert, ggmilei, ggpiparo, ncol = 3)

## 2.5. Florencio Randazzo, Cinthia Fernández, Cynthia Hotton
candidate = 'Florencio Randazzo'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

ggrandazzo = ggterminos(terminos, candidate)

candidate = 'Cinthia Fernández'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

ggcinthiafernandez = ggterminos(terminos, candidate)

candidate = 'Cynthia Hotton'
adjetivos = freqs(oraciones, 'adjetivos', candidate)[,tipo := 'adjetivo']
sustantivos = freqs(oraciones, 'sustantivos', candidate)[,tipo := 'sustantivo']

terminos = rbind(adjetivos, sustantivos)[order(-N)]

gghotton = ggterminos(terminos, candidate)

grid.arrange(ggrandazzo, ggcinthiafernandez, gghotton, ncol = 3)
