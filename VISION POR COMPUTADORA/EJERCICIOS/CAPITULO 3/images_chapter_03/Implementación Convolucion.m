
%ruta = "Fig0326(a)(embedded_square_noisy_512).tif"
ruta = "Fig3.24.jpg"
img = imread(ruta)
%imhist(img)
%histeq(img)
%imagesc(img)
%colormap("gray")
%histeq(img,5)

ker = [1 1 1; 1 1 1; 1 1 1]
tamano = size(img)
nueva = uint8(zeros([tamano(1) tamano(2)]))

for i = 2:(tamano(1)-1)
    for j = 2:(tamano(2)-1)
        %Aplicar la convolución%
        subimg = uint8(img((i-1):(i+1),(j-1):(j+1)) )
        nueva[i,j] = sum(sum(ker*subimg))/sum(sum(ker))
    end
end


i = 1
 















