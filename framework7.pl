:- include('argTheory.pl').

arguments([a,b,c,d,e,f,g,h,i,j,k,l,m,n,p,q]).

attack(c,a).
attack(c,d).
attack(d,a).
attack(d,b).
attack(d,e).
attack(e,b).
attack(g,d).
attack(g,p).
attack(h,a).
attack(h,e).
attack(h,p).
attack(i,e).
attack(i,j).
attack(i,n).
attack(j,i).
attack(j,n).
attack(k,l).
attack(l,m).
attack(m,c).
attack(m,k).
attack(n,f).
attack(n,p).
attack(p,c).
attack(p,l).
attack(p,q).


