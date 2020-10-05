:- include('argTheory.pl').

arguments([a,b,c,d,e,f,g]).

attack(b,a).
attack(c,b).
attack(d,f).
attack(e,g).
attack(g,d).
attack(f,e).

