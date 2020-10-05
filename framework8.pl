:- include('argTheory.pl').

arguments([a,b,c,d,e,f,g,h,i,x,y]).

attack(b,a).
attack(c,a).
attack(x,b).
%attack(x,x).
attack(d,b).
attack(e,c).
attack(f,e).
attack(g,f).
attack(h,e).
attack(i,h).

