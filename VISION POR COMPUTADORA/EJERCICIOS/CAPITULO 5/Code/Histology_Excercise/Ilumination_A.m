clear all
close all

a=3;
b=-1.5;
c=22;
cont=1;

for x=1:400
    for y=1:400
        plane(y,x)=a*x+b*y+c; % +randn*20
        X(cont)=x;
        Y(cont)=y;
        cont=cont+1;
    end
end

surf(plane)

A=[X' Y' ones(length(X),1)];

noisy_plane=plane+randn(400)*80;

Z=reshape(noisy_plane,400*400,1);
p=regress(Z,A);
