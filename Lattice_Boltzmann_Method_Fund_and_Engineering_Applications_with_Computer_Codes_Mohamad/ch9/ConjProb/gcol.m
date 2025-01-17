% Collition
function [g]=gcol(nx,ny,u,v,cx,cy,omegag,g,rhog,w)
for j=1:ny

for i=1:nx

t1=u(i,j)*u(i,j)+v(i,j)*v(i,j);
mg=omegag;
if (j<11) mg=mg*0.1;
end

if(j>(ny-11)) mg=mg*0.1;
end

for k=1:9

t2=u(i,j)*cx(k)+v(i,j)*cy(k);

geq(i,j,k)=rhog(i,j)*w(k)*(1.0+3.0*t2);
g(i,j,k)=(1.-mg)*g(i,j,k)+mg*geq(i,j,k);

end

end

end
end
