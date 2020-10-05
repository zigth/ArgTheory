:- include('argTheory.pl').

arguments([a,b,c,d]).

attack(a,b).
attack(b,c).
attack(c,b).
attack(c,d).
