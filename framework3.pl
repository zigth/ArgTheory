:- include('argTheory.pl').

arguments([a,b,c,d]).

attack(a,a).
attack(a,c).
attack(b,c).
attack(c,d).
