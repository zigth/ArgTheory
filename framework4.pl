:- include('argTheory.pl').

arguments([a,b,c,d,e]).

attack(a,b).
attack(b,c).
attack(c,d).
attack(d,c).
attack(d,e).
