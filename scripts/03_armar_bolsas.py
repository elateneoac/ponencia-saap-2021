import datatable
from datatable import f

clasificadas = datatable.fread('data/40-noticias-con-candidatos-clasificadas.csv')[:,:'dimensión valorativa?']
clasificadas.names = ('url', 'diario', 'seccion', 'sirve', 'dsustantiva', 'dvalorativa')
clasificadas[f.sirve == True,:]

bolsas = {}

septiembre = open()

