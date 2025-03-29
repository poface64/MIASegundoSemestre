clear all
close all

 a=30;
b=-1.5;
c=22;
d=4;
e=1;
f=2.5;

cont=1;

for x=1:100
    for y=1:100
        plane(y,x)=a*x*x+b*x*y+c*y*y+d*x+e*y+f+randn*90;
        A(cont)=x*x;
        B(cont)=x*y;
        C(cont)=y*y;
        D(cont)=x;
        E(cont)=y;
        Z(cont)=plane(y,x);
        cont=cont+1;
    end
end

surf(plane)

A=[A' B' C' D' E' ones(length(A),1)];

p=regress(Z',A);

