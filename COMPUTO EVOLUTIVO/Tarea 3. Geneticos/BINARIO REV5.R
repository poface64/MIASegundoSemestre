
A = optimizar(problema=2,pobsize=10,ngen=2000,PC,PM)





reporte = optimizar(problema,pobsize,PC,PM,Dn = 10)
plot(reporte[,2],type = "l")
min(reporte[,2])


X = mejor_individuo

# Definir limites del problema segun sea el caso:
limites = if (problema == 1) c(-10, 10) else c(-5.12, 5.12)
# Dividir X en segmentos de nbits
segmentos = 150/nbits
# Hacer una matriz con segmentos
msegmentos = matrix(X,nrow = nbits,ncol = segmentos)
# Cada columna como un subvector de bits
vresu = apply(msegmentos,2,function(bits){
  b2r(bits,nbits,a = limites[1],b = limites[2])})
vresu

