:- include('argTheory.pl').

arguments([a,b,c,d,e]).

attack(a,b).
attack(b,a).
attack(b,c).
attack(c,c).
attack(c,d).
attack(d,e).
attack(e,d).
