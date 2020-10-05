%subset/2 O(lp2)
%para1: a sorted list
%para2: a sorted list 								instantiation necessary
%returns true if para1 is a subset of para2
subset([],[]).
subset([X|L],[X|S]):- subset(L,S).
subset(L, [_|S]):- subset(L,S).

%subsetOf/2 O(lp2*lep2)
%para1: a sorted list
%para2: a list of sorted lists						instantiation necessary
%returns true if para1 is a subset of any list in para2
subsetOf(X,[H|T]):-subset(X,H);subsetOf(X,T).

%supersetOf/2 O(lp2*lp1)
%para1: a sorted list
%para2: a list of sorted lists						instantiation necessary
%returns true if para1 is a superset of any list in para2
supersetOf(X,[H|T]):-subset(H,X);supersetOf(X,T).

%supersetsOf/3 O(lp2*lep2)
%para1: a sorted list
%para2: a list of sorted lists						instantiation necessary
%para3: a sorted list
%returns true if para3 is a superset of para1 that is a member of the list para2
supersetsOf(X,[H|T],R):-(subset(X,H),R=H);supersetsOf(X,T,R).

%allSupersetsOf/3 O(lp2*lep2)
%para1: a sorted list
%para2: a list of sorted lists						instantiation necessary
%para3: a list of sorted lists
%returns true if para3 is a list of all supersets of para1 that are members of the list para2
allSupersetsOf(X,S,L):-findall(R,supersetsOf(X,S,R),L).

%maxSubset/2 O(lp1^2*lep1)
%para1: a list of lists								instantiation necessary
%para2: a list of lists		
%returns true if para2 consists all lists of para1 that maximal with regard to set inclusion
maxSubset(L,Res):-maxSubsetF(L,L,Res).
%maxSubsetF/3 (support function, not meant to be used directly)
%para1: a list of lists								instantiation necessary
%para1: a list of lists								instantiation necessary
%para2: a list of lists		
%returns true if the list para3 is a subset of para1 that consists of all elements except any lists in para2 that are subsets of any list in para1 other than itself
maxSubsetF(L,[H|T],Res):-delete(L,H,L2),(subsetOf(H,L2)->maxSubsetF(L2,T,Res);maxSubsetF(L,T,Res)).
maxSubsetF(X,[],X).

%minSubset/2 O(lp1^2*lep1)
%para1: a list of lists								instantiation necessary
%para2: a list of lists		
%returns true if para2 consists all lists of para1 that minimal with regard to set inclusion
minSubset(L,Res):-minSubsetF(L,L,Res).
%minSubsetF/3 (support function, not meant to be used directly)
%para1: a list of lists								instantiation necessary
%para1: a list of lists								instantiation necessary
%para2: a list of lists		
%returns true if the list para3 is a subset of para1 that consists of all elements except any lists in para2 that are supersets of any list in para1 other than itself
minSubsetF(L,[H|T],Res):-delete(L,H,L2),(supersetOf(H,L2)->minSubsetF(L2,T,Res);minSubsetF(L,T,Res)).
minSubsetF(X,[],X).

%resultsAppend/3 (support function, not meant to be used directly)
%para1: a list of lists								instantiation necessary
%para2: a list										instantiation necessary
%para3: a list
%returns true if para3 is a list of all the elements in para2 followed by the elements in all the lists in para1
resultsAppend([],Acc,Acc).
resultsAppend([H|T],Acc,Res):- append(Acc,H,Acc2),resultsAppend(T,Acc2,Res). 

%subtractAttack/4 (support function, not meant to be used directly)
%para1: a list of lists								instantiation necessary
%para2: a list 										instantiation necessary
%para3: a list of lists								instantiation necessary
%para4: a list of lists
%returns true if para4 is a list of all the attacks(2 element lists) in para1, where the attacker is not in para2, followed by all the lists in para3
subtractAttack([],_,Acc,Acc).
subtractAttack([[A,B]|T],L,Acc,Res):-member(A,L)->(subtractAttack(T,L,Acc,Res));(subtractAttack(T,L,[[A,B]|Acc],Res)).

%appendToAll\4
%para1: a list										instantiation necessary
%para2: a list of lists								instantiation necessary
%para3: a list of lists								instantiation necessary
%para2: a list of lists
%returns true if para4 is a reversed list of the concatenations of para1 and every element of para2 followed by all the elements of para3
appendToAll(_,[],Acc,Acc).
appendToAll(X,[H|T],Acc,Res):-appendToAll(X,T,[[X|H]|Acc],Res).

%intersect/2 O(lp1*lp2)
%para1: a list										instantiation necessary
%para2: a list										instantiation necessary
%returns true if para1 and para2 have any element in common
intersect(L1,L2):- (member(X,L1),member(X,L2)).
intersection(L1,L2,Res):-findall(X,(member(X,L1),member(X,L2)),Res).

%minHittingSets/2 
%para1: a list of lists								instantiation necessary
%para2: a list of lists								instantiation necessary
%returns true if para2 is a list of the minimal hitting sets of the elements in the lists in para1
minHittingSets(L,Res):-minHittingSetsF(L,[],[],Res2),(Res2=[[]]->Res=[];Res=Res2).
minHittingSetsF([],_,Msh,[Msh]).
minHittingSetsF([H|T],P,Msh,Res):-intersect(H,Msh)->minHittingSetsF(T,[H|P],Msh,Res);(findall(SubRes,(member(E,H),forall(member(E2,Msh),(member(S,P),\+member(E,S),intersection(S,Msh,[E2]))),minHittingSetsF(T,[H|P],[E|Msh],SubRes)),Res2),resultsAppend(Res2,[],Res)).
														
														

%attackOneOf/2 O(lp2)
%para1: an argument
%para2: a list of arguments							instantiation necessary
%returns true if para1 attacks one of the arguments in para2
attackOneOf(X,[H|T]):- attack(X,H);attackOneOf(X,T).

%oneOfAttack/2 O(lp1)
%para1: a list of arguments							instantiation necessary
%para2: an argument
%returns true if one of the arguments in para1 attacks para2
oneOfAttack([H|T],X):- attack(H,X);oneOfAttack(T,X).

%conflictFree/1 O(lp1^2)
%para1: a list of arguments							instantiation necessary
%returns true if no argument in the list attacks any other argument in the list
conflictFree([]).
conflictFree([H|T]):- (attackOneOf(H,[H|T]);oneOfAttack([H|T],H)),!,fail.
conflictFree([_|T]):- conflictFree(T).

%cfSubset/2 O(lp1*L)
%para1: a sorted list
%para2: a sorted list 								instantiation necessary
%returns true if para1 is a conflict-free subset of para2
cfSubset([],[]).
cfSubset([X|L],[X|S]):- argPlus(X,P),argMinus(X,M),subtract(S,P,S1),subtract(S1,M,S2),cfSubset(L,S2).
cfSubset(L, [_|S]):- cfSubset(L,S).

%cfGroundedSuperSet/1 O(L^3)
%para1: a sorted list
%returns true if para1 is a conflict-free superset of the grounded set
cfGroundedSuperSet(X):-arguments(L),grounded(G),argsPlus(G,G2),subtract(L,G,L2),subtract(L2,G2,L3),cfSubset(X2,L3),append(X2,G,X3),sort(X3,X). 


%conflictFreeSets/1 O(2^L)
%para1: a list of lists of arguments
%returns true if para1 is a list of all conflict-free sets
conflictFreeSets(Res):-arguments(L),findall(X,(member(X,L),\+attack(X,X)),Args),cSetFrom(Args,[],Res).
%cSetFrom/3 (support function, not meant to be used directly)
%para1: a list of arguments							instantiation necessary
%para2: a list of arguments							instantiation necessary
%para3: a list of lists of arguments
%returns true if para3 is a list of all unions of conflict-free subsets of para1 with para2
cSetFrom([],In,[Res]):-sort(In,Res).
cSetFrom([H|T],In,Res):-findall(X,(member(X,T),(attack(H,X);attack(X,H))),Att),subtract(T,Att,Args),cSetFrom(Args,[H|In],Res1),cSetFrom(T,In,Res2),append(Res1,Res2,Res).

%cfGroundedSuperSets/1 O(2^L)
%para1: a list of lists of arguments
%returns true if para1 is a list of all conflict-free supersets of the grounded set
cfGroundedSuperSets(Res):-arguments(L),findall(X,(member(X,L),\+attack(X,X)),Args),grounded(G),argsPlus(G,Gatt),subtract(Args,Gatt,Args2),subtract(Args2,G,Args3),cSetFrom(Args3,G,Res).


%argPlus/2 O(L)
%para1: an argument									instantiation necessary
%para2: a sorted list of arguments
%returns true if para2 is a list of all arguments that para1 attacks
argPlus(X,R):-findall(Y,attack(X,Y),L),sort(L,R).

%argsPlus/2 O(L*lp1)
%para1: a list of arguments							instantiation necessary
%para2: a sorted list of arguments
%returns true if para2 is a list of all arguments that any argument in para1 attacks
argsPlus(X,R):-findall(Y,oneOfAttack(X,Y),L),sort(L,R).
		
%argMinus/2 O(L)
%para1: an argument									instantiation necessary
%para2: a sorted list of arguments
%returns true if para2 is a list of all arguments that para1 is attacked by
argMinus(X,R):-findall(Y,attack(Y,X),L),sort(L,R).

%argMinusAtt/2 O(L)
%para1: an argument									instantiation necessary
%para2: a sorted list of lists of arguments
%returns true if para2 is a list of all attacks against para1
argMinusAtt(X,R):-findall([Y,X],attack(Y,X),L),sort(L,R).

%argsMinus/2 O(L*lp1)
%para1: a list of arguments							instantiation necessary
%para2: a sorted list of arguments
%returns true if para2 is a list of all arguments that any argument in para1 attacked by
argsMinus(X,R):-findall(Y,attackOneOf(Y,X),L),sort(L,R).

%argsMinusAtt/2 O(L*lp1)
%para1: a list of arguments							instantiation necessary
%para2: a sorted list of lists of arguments
%returns true if para2 is a list of all attacks against any argument in para1
argsMinusAtt(X,R):-findall(Att,(member(A,X),argMinusAtt(A,Att)),L),resultsAppend(L,[],R).


%undec/2 O(L*lp1)
%para1: a list of arguments							instantiation necessary
%para2: a sorted list of arguments
%returns true if para2 consists of all arguments that would be labelled undet if all arguments in para1 are labelled in
undec(In,Und):-arguments(L),argsPlus(In,Out),subtract(L,In,R1),subtract(R1,Out,Und).

%undecL/2 O(lp1*lep1*L)
%para1: a list of lists of arguments				instantiation necessary
%para2: a list of sorted list of arguments
%returns true if para2 is a list of all lists of arguments that would be labelled undet if all arguments in the corresponding list in para1 are labelled in
undecL([],[]).
undecL([Hin|Tin],[Hun|Tun]):-undec(Hin,Hun),undecL(Tin,Tun).




%defendArg/2 O(L*lp1)
%para1: a list of arguments							instantiation necessary
%para2: an argument									instantiation necessary	
%returns true if the arguments in para1 defend para2 	
defendArg(A,B):-argsPlus(A,L1),argMinus(B,L2),subset(L2,L1).	

%defendArgs/2 O(L*max(lp1,lp2))
%para1: a list of arguments							instantiation necessary
%para2: a list of argument							instantiation necessary	
%returns true if the arguments in para1 defend the arguments in para2 	
defendArgs(A,B):-argsPlus(A,L1),argsMinus(B,L2),subset(L2,L1).

%defendF/2 O(L^2*lp1)
%para1: a list of arguments							instantiation necessary
%para2: a sorted list of argument					
%returns true if para2 is a list of all arguments that the arguments in para1 defend
defendF(A,R):-arguments(L),defendLA(A,L,[],Res),sort(Res,R).
%defendLA/4 (support function, not meant to be used directly)
%para1: a list of arguments							instantiation necessary
%para2: a list of arguments							instantiation necessary
%para3: a list of arguments							instantiation necessary
%para4: a list of arguments			
%returns true if para4 is a list of all arguments in para2 that the arguments in para1 defend, in reverse order, followed by the elements of para3
defendLA(A,[H|T],Acc,Res):- (defendArg(A,H) -> defendLA(A,T,[H|Acc],Res);defendLA(A,T,Acc,Res)).
defendLA(_,[],Acc,Acc).	
	
%defendsSelf/1 O(L*lp1)
%para1: a sorted list of arguments					instantiation necessary
%returns true if the arguments in para1 defend themselves and nothing else
defendsSelf(X):-arguments(L),argsPlus(X,Xatt),subtract(L,Xatt,L2),findall(Y,oneOfAttack(L2,Y),L3),subtract(L2,L3,L4),X=L4.	
	
	
%admissible/1 O(l^2*lp1)	
%para1: a sorted list of arguments
%returns true if the arguments in para1 represent the set IN of an admissible labelling	
admissible(S):-arguments(L),cfSubset(S,L),argsPlus(S,P),argsMinus(S,M),subset(M,P).

%allAdmissible/1 O(2^L*L^2)
%para1: a sorted list of sorted lists of arguments
%returns true if para1 contains all lists of arguments that represent the set IN of an admissible labelling
allAdmissible(R):-conflictFreeSets(X),findall(Y,(member(Y,X),argsPlus(Y,P),argsMinus(Y,M),subset(M,P)),R).
	
%complete/1 O(L^2*lp1)
%para1: a sorted list of arguments
%returns true if the arguments in para1 represent the set IN of a complete labelling				
complete(S):-cfGroundedSuperSet(S),defendsSelf(S).  

%allComplete/1 O(2^L*L^3)
%para1: a sorted list of sorted lists of arguments
%returns true if para1 contains all lists of arguments that represent the set IN of a complete labelling
allCompleteAlt(R):-findall(X,complete(X),L),sort(L,R).

%allComplete/1 O(2^L*L^2)
%para1: a sorted list of sorted lists of arguments
%returns true if para1 contains all lists of arguments that represent the set IN of a complete labelling
allComplete(R):-cfGroundedSuperSets(X),findall(Y,(member(Y,X),defendsSelf(Y)),R).


%stable/1 O(L*lp1)
%para1: a sorted list of arguments
%returns true if para1 contains a list of arguments that represents the set IN of a stable labelling (assuming any exist)
stable(A):-cfGroundedSuperSet(A),argsPlus(A,R),length(A,N),length(R,M),arguments(L),length(L,K),K is N+M.

%allStable/1 O(2^L*L^2)
%para1: a sorted list of sorted lists of arguments
%returns true if para1 contains all lists of arguments that represent the set IN of a stable labelling (assuming any exist)
allStableAlt(R):-findall(X,stable(X),L),sort(L,R).

%allStableAlt/1 O(2^L*L^2)
%para1: a sorted list of sorted lists of arguments
%returns true if para1 contains all lists of arguments that represent the set IN of a stable labelling (assuming any exist)
allStable(R):-cfGroundedSuperSets(C),arguments(L),length(L,K),findall(A,(member(A,C),argsPlus(A,R),length(A,N),length(R,M),K is N+M),R).


%preferred/1 O(2^L*L^2)
%para1: a sorted list of arguments
%returns true if para1 contains a list of arguments that represents the set IN of a preferred labelling
preferred(A):-allComplete(Args),member(A,Args),delete(Args,A,Args2),\+subsetOf(A,Args2). 

%allPreferred/1 O(2^L*L^3)
%para1: a sorted list of sorted lists of arguments
%returns true if para1 contains all lists of arguments that represent the set IN of a preferred labelling
allPreferred(L):-allComplete(Args),maxSubset(Args,L).


%allSemiStable/1 O(2^L*L^3)
%para1: a sorted list of sorted lists of arguments
%returns true if para1 contains all lists of arguments that represent the set IN of a semi-stable labelling
allSemiStable(X):-allComplete(Lin),undecL(Lin,Lun),semiStableEx(Lin,Lun,Lun,[],Res),sort(Res,X).
%semiStableEx/5 (support function, not meant to be used directly)
%para1: a list of lists of arguments				instantiation necessary
%para2: a list of lists of arguments				instantiation necessary
%para3: a list of lists of arguments				instantiation necessary
%para4: a list 										instantiation necessary
%para5: a list 
%returns true if para5 contains all lists of arguments in para1 that are in the same position as the lists in para2, 
%that are not a superset of any list in para3 other than itself, in reverse order, followed by all the elements in para4
semiStableEx([Hin|Tin],[Hun|Tun],L,Acc,Res):-delete(L,Hun,L2),(supersetOf(Hun,L2)->semiStableEx(Tin,Tun,L,Acc,Res);semiStableEx(Tin,Tun,L,[Hin|Acc],Res)).
semiStableEx([],[],_,Res,Res).


%grounded/1 O(L^3)
%para1: a sorted list of arguments
%returns true if para1 contains a list of arguments that represents the set IN of the grounded labelling
grounded(X):-arguments(L),groundedAdd([],L,L,R),sort(R,X).
%groundedAdd/4 (support function, not meant to be used directly)
%para1: a list 										instantiation necessary
%para2: a list of arguments							instantiation necessary
%para3: a list of arguments							instantiation necessary
%para4: a list
%returns true if para4 contains a list of arguments in para3 that are not attacked by any argument in para2, that isn't removed
%because it itself is attacked by an element of para2, followed by the elements in para1
groundedAdd(X,L,[H|T],R):- (oneOfAttack(L,H)->groundedAdd(X,L,T,R);(delete(L,H,L2),groundedRemove([H|X],[],L2,R))).
groundedAdd(X,_,[],X).
%groundedRemove/4 (support function, not meant to be used directly)
%para1: a list of arguments							instantiation necessary
%para2: a list of arguments							instantiation necessary
%para3: a list of arguments							instantiation necessary
%para4: a list
%returns true if para4 contains a list of arguments in para3 that are not attacked by any argument in para3, that isn't removed
%because it itself is attacked by an element of para3 or para2, followed by the elements in para1
groundedRemove([A|B],L,[H|T],R):- (attack(A,H)->groundedRemove([A|B],L,T,R);groundedRemove([A|B],[H|L],T,R)).
groundedRemove(X,L,[],R):-groundedAdd(X,L,L,R).


%groundedArg/1 O(L^L)
%para1: an argument									instantiation necessary
%returns true if para1 is in the grounded set
groundedArg(Arg):-arguments(L),member(Arg,L),groundedDef(Arg,[]).
%groundedDef/2 (support function, not meant to be used directly)
%para1: an argument									instantiation necessary
%para2: a list of arguments							instantiation necessary
%returns true if all attackers of para1 can be beaten by grounded arguments not in para2
groundedDef(Arg,L):- append(L,[Arg],L2),forall(attack(X,Arg),groundedAtt(X,L2)).
%groundedAtt/2 (support function, not meant to be used directly)
%para1: an argument									instantiation necessary
%para2: a list of arguments							instantiation necessary
%returns true if there exists an attacker of para1 that is a grounded argument and not in para2
groundedAtt(Arg,L):- \+forall((attack(X,Arg),\+member(X,L)),\+groundedDef(X,L)).

%groundedPath/2
%para1: an argument									instantiation necessary
%para2: a list of arguments or lists of arguments, or ...
%returns true if para1 is grounded and para2 is a list of strategies for every possible opponent move, to prove that para1 is grounded
groundedPath(Arg,Res):-groundedPro(Arg,[],Res).
groundedPro(Arg,L,Res):- append(L,[Arg],L2),argMinus(Arg,Att),(Att=[]->Res=L2;
						  (findall(SubRes,(member(X,Att),argMinus(X,Xatt),subtract(Xatt,L2,Xatt2),groundedOp(X,L2,SubRes,Xatt2)),Res),
						  length(Att,N),length(Res,N))).
groundedOp(_,_,_,[]):-!,fail.
groundedOp(Arg,L,Res,[H|T]):- append(L,[Arg],L2),(groundedPro(H,L2,Res2)->Res=Res2;groundedOp(Arg,L,Res,T)).

%groundedAllPath/2
%para1: an argument									instantiation necessary
%para2: a list of arguments or lists of arguments, or ...
%returns true if para1 is grounded and para2 is a list of all strategies for proving that para1 is grounded
groundedAllPath(Arg,Res):-groundedAllPro(Arg,[],Res).
groundedAllPro(Arg,L,Res2):- append(L,[Arg],L2),argMinus(Arg,Att),(Att=[]->Res2=[L2];
							  (findall(SubRes,(member(X,Att),groundedAllOp(X,L2,SubRes)),Res),
							  length(Att,N),length(Res,N),resultsAppend(Res,[],Res2))).
groundedAllOp(Arg,L,Res2):- append(L,[Arg],L2),argMinus(Arg,Att),subtract(Att,L2,Att2),
							 (Att2=[]->fail;(findall(SubRes,(member(X,Att2),groundedAllPro(X,L2,SubRes)),Res),
							 length(Res,N),N>=1,resultsAppend(Res,[],Res2))).



%preferredArg/1 O(L^L)
%para1: an argument									instantiation necessary
%returns true if para1 is in any preferred set
preferredArg(Arg):-arguments(L),member(Arg,L),preferredDef(Arg,[],[]).
%groundedDef/2 (support function, not meant to be used directly)
%para1: a list of arguments							instantiation necessary
%para2: a list of arguments							instantiation necessary
%para3: a list of arguments							instantiation necessary
%returns true if all attackers of para1 or elements in para2 can be beaten by a preferred argument not in para3
preferredDef(Arg,Pl,Ol):- append(Pl,[Arg],Pl2),findall(A,(attackOneOf(A,Pl2),\+member(A,Ol)),Att2),(member(X,Att2)->preferredAtt(X,Pl2,Ol);\+intersect(Pl,Ol)).
%groundedAtt/2 (support function, not meant to be used directly)
%para1: an argument									instantiation necessary
%para2: a list of arguments							instantiation necessary
%returns true if there exists an attacker of para1 that is a preferred argument and not in para3
preferredAtt(Arg,Pl,Ol):- append(Ol,[Arg],Ol2),\+forall((attack(X,Arg),\+member(X,Ol2)),\+preferredDef(X,Pl,Ol2)).

%allPreferredArg/1 
%para1: an argument									instantiation necessary
%returns true if para1 is in all preferred sets
allPreferredArg(Arg):-preferredArg(Arg),argPlus(Arg,Att),forall(member(X,Att),\+preferredArg(X)).


%defAllStrategy/3 
%para1: an argument									instantiation necessary
%para2: a list of lists of lists of arguments									
%para3: a list of lists of arguments				instantiation necessary
%returns true if para2 is the list of defense strategies(lists of proponent attacks) for the argument in para1, in the framework where the attacks in para3 have been removed																
defAllStrategy(Arg,Res,Exclude):-argMinusAtt(Arg,Att),subtract(Att,Exclude,Att2),((member([X,Arg],Att2),defAllStrategyOp(X,[],[Arg],[],Res1,Exclude))->sort(Res1,Res);Res=[]).			
defAllStrategyPro(Arg,Parg,Pattl,Pl,Ol,Res,Exclude):- append(Pattl,[[Arg,Parg]],Pattl2),append(Pl,[Arg],Pl2),argsMinusAtt(Pl2,Att),subtract(Att,Exclude,Att2),subtractAttack(Att2,Ol,[],Att3),		
																(Att3=[]->(intersect(Pl2,Ol)->fail;(sort(Pattl2,Pattl3),Res=[Pattl3]));(member([Y,_],Att3),defAllStrategyOp(Y,Pattl2,Pl2,Ol,Res,Exclude))).
defAllStrategyOp(Arg,Pattl,Pl,Ol,Res2,Exclude):- append(Ol,[Arg],Ol2),argMinusAtt(Arg,Att),subtract(Att,Exclude,Att2),subtractAttack(Att2,Ol2,[],Att3),
																(Att3=[]->fail;(findall(SubRes,(member([Y,X],Att3),defAllStrategyPro(Y,X,Pattl,Pl,Ol2,SubRes,Exclude)),Res),
																length(Res,N),N>=1,resultsAppend(Res,[],Res2))).																

%defAllStrategyArgs/3 
%para1: an argument									instantiation necessary
%para2: a list of lists of arguments									
%para3: a list of arguments				instantiation necessary
%returns true if para2 is the list of defense strategies(lists of proponent arguments) for the argument in para1, in the framework where the arguments in para3 have been removed	
defAllStrategyArgs(Arg,Res,Exclude):-member(Arg,Exclude)->Res=[];(defAllStrategyArgsPro(Arg,[],[],Res1,Exclude)->sort(Res1,Res);Res=[]).			
defAllStrategyArgsPro(Arg,Pl,Ol,Res,Exclude):- append(Pl,[Arg],Pl2),argsMinus(Pl2,Att),subtract(Att,Exclude,Att2),subtract(Att2,Ol,Att3),		
																(Att3=[]->(intersect(Pl2,Ol)->fail;(sort(Pl2,Pl3),Res=[Pl3]));(member(X,Att3),defAllStrategyArgsOp(X,Pl2,Ol,Res,Exclude))).
defAllStrategyArgsOp(Arg,Pl,Ol,Res2,Exclude):- append(Ol,[Arg],Ol2),argMinus(Arg,Att),subtract(Att,Exclude,Att2),subtract(Att2,Ol2,Att3),
																(Att3=[]->fail;(findall(SubRes,(member(X,Att3),defAllStrategyArgsPro(X,Pl,Ol2,SubRes,Exclude)),Res),
																length(Res,N),N>=1,resultsAppend(Res,[],Res2))).

%critDefSets/3 O
%para1: an argument									instantiation necessary
%para2: a list of lists of lists of arguments									
%para3: a list of lists of arguments				instantiation necessary
%returns true if para2 is the list of critical defense sets for the argument in para1, in the framework where the attacks in para3 have been removed	
critDefSets(Arg,Res,Exclude):-defAllStrategy(Arg,Res1,Exclude),minHittingSets(Res1,Res).

%critDefSetsArgs/3 O
%para1: an argument									instantiation necessary
%para2: a list of lists of arguments									
%para3: a list of arguments							instantiation necessary
%returns true if para2 is the list of critical defense sets for the argument in para1, in the framework where the arguments in para3 have been removed	
critDefSetsArgs(Arg,Res,Exclude):-defAllStrategyArgs(Arg,Res1,Exclude),minHittingSets(Res1,Res).


%makeNotPreferred/4 
%para1: an argument									instantiation necessary
%para2: a list of lists of arguments				instantiation necessary				
%para3: a list of lists of lists of arguments		instantiation necessary
%para4: a list of lists of lists of arguments
%returns true if para4 is the list of lists of attacks, whose removal from the framework makes the argument in para1 not preferred, excluding those who are supersets of any element in para3,
%in the framework where the attacks in para2 have been removed	
makeNotPreferred(Arg,Except,Exclude,Res):-critDefSets(Arg,Res1,Exclude),findall(X,(member(X,Res1),forall(member(E,Except),\+subset(E,X))),Res2),
										    ((Res2=[],Res1\=[])->fail;makeNotPreferredF(Arg,Res2,Exclude,[],Res)).
makeNotPreferredF(_,[],_,Acc,Acc).
makeNotPreferredF(Arg,[H|T],Exclude,Acc,Res):-append(T,Acc,Except),append(Exclude,H,Exclude2),(makeNotPreferred(Arg,Except,Exclude2,SubRes)->
												((SubRes=[]->SubRes2=H;appendToAll(H,SubRes,[],SubRes2)),append(Acc,[SubRes2],Acc2),makeNotPreferredF(Arg,T,Exclude,Acc2,Res));makeNotPreferredF(Arg,T,Exclude,Acc,Res)).

%makeNotPreferredArgs/4 
%para1: an argument									instantiation necessary
%para2: a list of arguments							instantiation necessary				
%para3: a list of lists of arguments				instantiation necessary
%para4: a list of lists of arguments
%returns true if para4 is the list of lists of arguments, whose removal from the framework makes the argument in para1 not preferred, excluding those who are supersets of any element in para3,
%in the framework where the arguments in para2 have been removed	
makeNotPreferredArgs(Arg,Except,Exclude,Res):-critDefSetsArgs(Arg,Res1,Exclude),findall(X,(member(X,Res1),forall(member(E,Except),\+subset(E,X))),Res2),
											    ((Res2=[],Res1\=[])->fail;makeNotPreferredArgsF(Arg,Res2,Exclude,[],Res)).
makeNotPreferredArgsF(_,[],_,Acc,Acc).
makeNotPreferredArgsF(Arg,[H|T],Exclude,Acc,Res):-append(T,Acc,Except),append(Exclude,H,Exclude2),(makeNotPreferredArgs(Arg,Except,Exclude2,SubRes)->
													((SubRes=[]->SubRes2=H;appendToAll(H,SubRes,[],SubRes2)),append(Acc,[SubRes2],Acc2),makeNotPreferredArgsF(Arg,T,Exclude,Acc2,Res));makeNotPreferredArgsF(Arg,T,Exclude,Acc,Res)).



										


%Obsolete Code (but might still be usefull somehow?)
%altminHittingSets(X,Res):-X=[]->Res=[];altminHittingSetsF(X,[],[],Res).
%altminHittingSetsF([],_,_,[[]]).
%altminHittingSetsF([X|T],In,Out,Res):- \+intersect(X,In)->(subtract(X,Out,X2),findall([A|Tres],(member(A,X2),delete(X2,A,X3),append(Out,X3,Out2),altminHittingSetsF(T,[A|In],Out2,Res2),member(Tres,Res2)),Res));
%														(findall(Tres,(altminHittingSetsF(T,In,Out,Res2),member(Tres,Res2)),Res)).
%cSetFrom([H|T],In,Res):-findall(X,(member(X,T),\+attack(H,X),\+attack(X,H)),Args),cSetFrom(Args,[H|In],Res1),cSetFrom(T,In,Res2),append(Res1,Res2,Res).
%argPlus(X,R):-arguments(L),argPlusA(X,L,[],Res),sort(Res,R).
%argPlusA/4 (support function, not meant to be used directly)
%para1: an argument									instantiation necessary
%para2: a list of arguments							instantiation necessary
%para3: a list of arguments							instantiation necessary
%para4: a list of arguments
%returns true if para4 is a list of all arguments in para2 that para1 attacks, in reverse order, followed by all elements in para3
%argPlusA(X,[H|T],A,Res):- (attack(X,H)->argPlusA(X,T,[H|A],Res);argPlusA(X,T,A,Res)).
%argPlusA(_,[],A,A).	
%argMinus(X,R):-arguments(L),argMinusA(X,L,[],Res),sort(Res,R).
%argMinusA/4 (support function, not meant to be used directly)
%para1: an argument									instantiation necessary
%para2: a list of arguments							instantiation necessary
%para3: a list of arguments							instantiation necessary
%para4: a list of arguments
%returns true if para4 is a list of all arguments in para2 that para1 is attacked by, in reverse order, followed by all elements in para3
%argMinusA(X,[H|T],A,Res):- (attack(H,X)->argMinusA(X,T,[H|A],Res);argMinusA(X,T,A,Res)).
%argMinusA(_,[],A,A).
%argsPlus(X,R):-arguments(L),argsPlusA(X,L,[],Res),sort(Res,R).
%argsPlusA/4(support function, not meant to be used directly)
%para1: a list of arguments							instantiation necessary
%para2: a list of arguments							instantiation necessary
%para3: a list of arguments							instantiation necessary
%para4: a list of arguments
%returns true if para4 is a list of all arguments in para2 that any argument in para1 attacks, in reverse order, followed by all elements in para3
%argsPlusA(X,[H|T],A,Res):- (oneOfAttack(X,H)->argsPlusA(X,T,[H|A],Res);argsPlusA(X,T,A,Res)).
%argsPlusA(_,[],A,A).		
%argsMinus(X,R):-arguments(L),argsMinusA(X,L,[],Res),sort(Res,R).
%argsMinusA/4 (support function, not meant to be used directly)
%para1: a list of arguments							instantiation necessary
%para2: a list of arguments							instantiation necessary
%para3: a list of arguments							instantiation necessary
%para4: a list of arguments
%returns true if para4 is a list of all arguments in para2 that any argument in para1 is attacked by, in reverse order, followed by all elements in para3
%argsMinusA(X,[H|T],A,Res):- (attackOneOf(H,X)->argsMinusA(X,T,[H|A],Res);argsMinusA(X,T,A,Res)).
%argsMinusA(_,[],A,A).		
%argPlusA(X,[H|T],A,Res):- \+attack(X,H),argPlusA(X,T,A,Res).
%argsPlusA(X,[H|T],A,Res):- \+oneOfAttack(X,H),argsPlusA(X,T,A,Res).
%argMinusA(X,[H|T],A,Res):- \+attack(H,X),argMinusA(X,T,A,Res).
%argsMinusA(X,[H|T],A,Res):- \+attackOneOf(H,X),argsMinusA(X,T,A,Res).
%defendLA(A,[H|T],Acc,Res):- \+defendArg(A,H),defendLA(A,T,Acc,Res).
%complete(A):-sort(A,L),defendF(L,L),conflictFree(L).
%semiStable(X):-allUndet(L),minSubset(L,L,X).
%undetComp(X):-arguments(Args),complete(In),argsPlus(In,Out),subtract(Args,In,R1),subtract(R1,Out,X).
%allUndetComp(L):-findall(X,undetComp(X),L).
%undecL(InL,UnL):-findall(Und,(member(In,InL),undec(In,Und)),UnL).
%minSubset(L,[H|T],Res):-delete(L,H,L2),allSupersetsOf(H,L2,R),subtract(L,R,NL),subtract(T,R,NT),minSubset(NL,NT,Res).
%minSubset(X,[],X).
%preferred([H|T],L):-complete(H),(subsetOf(H,L)->;preferred(T,[H|L])).
%groundedAdd(X,L,[H|T],R):- oneOfAttack(L,H),groundedAdd(X,L,T,R).
%groundedRemove([A|B],L,[H|T],R):- \+attack(A,H),groundedRemove([A|B],[H|L],T,R).
%groundedArg(L,M):-argsMinus(L,X),(X=[]->true;argsMinus(X,Y),subtract(Y,M,Z),(Z=[]->fail;append(M,L,NM),groundedArg(Z,NM))).
%groundedArg(L,M):-argsMinus(L,X),X=[],!,succ.
%groundedArg(L,M):-argsMinus(L,X),argsMinus(X,Y),subtract(Y,M,Z),Z=[],!,fail.
%groundedArg(L,M):-argsMinus(L,X),argsMinus(X,Y),subtract(Y,M,Z),append(M,L,NM),groundedArg(Z,NM).
%altresultsAppend([[],[]],Acc,Acc).
%altresultsAppend([[X|Tx],[]],[AccPro,AccOp],Res):- append(AccPro,X,AccPro2),altresultsAppend([Tx,[]],[AccPro2,AccOp],Res).
%altresultsAppend([[],[Y|Ty]],[AccPro,AccOp],Res):- append(AccOp,Y,AccOp2),altresultsAppend([[],Ty],[AccPro,AccOp2],Res).
%altresultsAppend([[X|Tx],[Y|Ty]],[AccPro,AccOp],Res):- append(AccPro,X,AccPro2),append(AccOp,Y,AccOp2),altresultsAppend([Tx,Ty],[AccPro2,AccOp2],Res).
%defAllStrategyArgs(Arg,Res,Exclude):-member(Arg,Exclude)->Res=[];(argMinusAtt(Arg,Att),findall([E,X],(member(E,Exclude),attack(E,X)),Exc),subtract(Att,Exc,Att2),(Att2=[]->Res=[[Arg]];(findall(SubRes,(member([X,Arg],Att2),defAllStrategyArgsOp(X,Arg,[],[],[Arg],[],SubRes,Exc)),Res2)->(resultsAppend(Res2,[],Res1),sort(Res1,Res));Res=[]))).			%defAllStrategyPro(Arg,0,[],[],[],[],Res2,Exclude)->sort(Res2,Res);Res=[].
%defAllStrategyArgsPro(Arg,Parg,Pattl,Oattl,Pl,Ol,Res2,Exclude):- append(Pattl,[[Arg,Parg]],Pattl2),append(Pl,[Arg],Pl2),argsMinusAtt(Pl2,Att),subtract(Att,Exclude,Att2),subtract(Att2,Oattl,Att3),		
%																(Att3=[]->(intersect(Pl2,Ol)->fail;(sort(Pl2,Pl3),Res2=[Pl3]));(findall(SubRes,(member([Y,X],Att3),defAllStrategyArgsOp(Y,X,Pattl2,Oattl,Pl2,Ol,SubRes,Exclude)),Res),
%																length(Att3,N),length(Res,N),resultsAppend(Res,[],Res2))).
%defAllStrategyArgsOp(Arg,Parg,Pattl,Oattl,Pl,Ol,Res2,Exclude):- append(Oattl,[[Arg,Parg]],Oattl2),append(Ol,[Arg],Ol2),argMinusAtt(Arg,Att),subtract(Att,Exclude,Att2),subtractAttack(Att2,Ol2,[],Att3),
%																(Att3=[]->fail;(findall(SubRes,(member([Y,X],Att3),defAllStrategyArgsPro(Y,X,Pattl,Oattl2,Pl,Ol2,SubRes,Exclude)),Res),
%																length(Res,N),N>=1,resultsAppend(Res,[],Res2))).
%defAllStrategy(Arg,Res,Exclude):-argMinusAtt(Arg,Att),subtract(Att,Exclude,Att2),(findall(SubRes,(member([X,Arg],Att2),defAllStrategyOp(X,Arg,[],[],[Arg],[],SubRes,Exclude)),Res2)->(resultsAppend(Res2,[],Res1),sort(Res1,Res));Res=[]).			%defAllStrategyPro(Arg,0,[],[],[],[],Res2,Exclude)->sort(Res2,Res);Res=[].
%defAllStrategyPro(Arg,Parg,Pattl,Oattl,Pl,Ol,Res2,Exclude):- append(Pattl,[[Arg,Parg]],Pattl2),append(Pl,[Arg],Pl2),argsMinusAtt(Pl2,Att),subtract(Att,Exclude,Att2),subtract(Att2,Oattl,Att3),		
%																(Att3=[]->(intersect(Pl2,Ol)->fail;(sort(Pattl2,Pattl3),Res2=[Pattl3]));(findall(SubRes,(member([Y,X],Att3),defAllStrategyOp(Y,X,Pattl2,Oattl,Pl2,Ol,SubRes,Exclude)),Res),
%																length(Att3,N),length(Res,N),resultsAppend(Res,[],Res2))).
%defAllStrategyOp(Arg,Parg,Pattl,Oattl,Pl,Ol,Res2,Exclude):- append(Oattl,[[Arg,Parg]],Oattl2),append(Ol,[Arg],Ol2),argMinusAtt(Arg,Att),subtract(Att,Exclude,Att2),subtractAttack(Att2,Ol2,[],Att3),
%																(Att3=[]->fail;(findall(SubRes,(member([Y,X],Att3),defAllStrategyPro(Y,X,Pattl,Oattl2,Pl,Ol2,SubRes,Exclude)),Res),
%																length(Res,N),N>=1,resultsAppend(Res,[],Res2))).

																
																	
%defAllPrefPath(Arg,Exclude,Res):-argMinusAtt(Arg,Att),subtract(Att,Exclude,Att2),findall(SubRes,(member([X,Arg],Att2),defAllPrefPathOp(X,Arg,[],[],[Arg],[],SubRes,Exclude)),Res2),resultsAppend(Res2,[],Res).
%defAllPrefPathPro(Arg,Parg,Pattl,Oattl,Pl,Ol,Res,Exclude):- append(Pattl,[[Arg,Parg]],Pattl2),append(Pl,[Arg],Pl2),argMinusAtt(Arg,Att),subtractAttack(Att,Ol,[],Att2),subtract(Att2,Exclude,Att3),
%																(Att3=[]->Res=[[Pattl2,Oattl,Pl2,Ol]];(findall(SubRes,(member([X,Arg],Att3),defAllPrefPathOp(X,Arg,Pattl2,Oattl,Pl2,Ol,SubRes,Exclude)),Res2),resultsAppend(Res2,[],Res))).
%defAllPrefPathOp(Arg,Parg,Pattl,Oattl,Pl,Ol,Res,Exclude):- append(Oattl,[[Arg,Parg]],Oattl2),append(Ol,[Arg],Ol2),argMinusAtt(Arg,Att),subtractAttack(Att,Ol2,[],Att2),subtract(Att2,Exclude,Att3),
%																(Att3=[]->fail;(findall(SubRes,(member([X,Arg],Att3),defAllPrefPathPro(X,Arg,Pattl,Oattl2,Pl,Ol2,SubRes,Exclude)),Res2),resultsAppend(Res2,[],Res))).
									
%attAllPrefPath(Arg,Exclude,Res):-argMinusAtt(Arg,Att),subtract(Att,Exclude,Att2),findall(SubRes,(member([X,Arg],Att2),attAllPrefPathOp(X,Arg,[],[],[Arg],[],SubRes,Exclude)),Res2),resultsAppend(Res2,[],Res).
%attAllPrefPathPro(Arg,Parg,Pattl,Oattl,Pl,Ol,Res,Exclude):- append(Pattl,[[Arg,Parg]],Pattl2),append(Pl,[Arg],Pl2),argMinusAtt(Arg,Att),subtractAttack(Att,Ol,[],Att2),subtract(Att2,Exclude,Att3),
%																(Att3=[]->Res=[[Pattl2,Oattl,Pl2,Ol,[0]]];(findall(SubRes,(member([X,Arg],Att3),attAllPrefPathOp(X,Arg,Pattl2,Oattl,Pl2,Ol,SubRes,Exclude)),Res2),resultsAppend(Res2,[],Res))).
%attAllPrefPathOp(Arg,Parg,Pattl,Oattl,Pl,Ol,Res,Exclude):- append(Oattl,[[Arg,Parg]],Oattl2),append(Ol,[Arg],Ol2),argMinusAtt(Arg,Att),subtractAttack(Att,Ol2,[],Att2),subtract(Att2,Exclude,Att3),
%																(Att3=[]->Res=[[Pattl,Oattl2,Pl,Ol2,[1]]];(findall(SubRes,(member([X,Arg],Att3),attAllPrefPathPro(X,Arg,Pattl,Oattl2,Pl,Ol2,SubRes,Exclude)),Res2),resultsAppend(Res2,[],Res))).
					
%attAllStrategy(Arg,Res,Exclude):-attAllPrefPath(Arg,Exclude,Res2),findall(S2,(subset(Strat,Res2),Strat\=[],unifyAttStrat(Strat,[[],[],[],[],[]],[S1,S2,S3,S4,S5]),(S5=[1];intersect(S3,S4)),forall((member(X,S4),argMinusAtt(X,Att),subtract(Att,Exclude,Att2)),subset(Att2,S1))),Res3),sort(Res3,Res).
%attAllStrategy(Arg,Res,Exclude):-attAllPrefPath(Arg,Exclude,Res2),findall(S2,(subset(Strat,Res2),Strat\=[],unifyAttStrat(Strat,[[],[],[]],[S1,S2,S4]),forall(member([_,_,Pl,_,End],Strat),(End=[1];intersect(Pl,S4))),forall((member(X,S4),argMinusAtt(X,Att),subtract(Att,Exclude,Att2)),subset(Att2,S1))),Res3),sort(Res3,Res).
%unifyAttStrat([],[A1,A2,A4],Res):-sort(A1,R1),sort(A2,R2),sort(A4,R4),Res=[R1,R2,R4].
%unifyAttStrat([H|T],Acc,Res):-combineAttStrat(H,Acc,NAcc),unifyAttStrat(T,NAcc,Res).
%combineAttStrat([S1,S2,_,S4,_],[T1,T2,T4],Res):-append(S1,T1,R1),append(S2,T2,R2),append(S4,T4,R4),Res=[R1,R2,R4].

%altdefAllStrategy(Arg,Res,Exclude):-defAllPrefPath(Arg,Exclude,Res2),findall(S1,(subset(Strat,Res2),Strat\=[],unifyDefStrat(Strat,[[],[],[],[]],[S1,S2,S3,S4]),\+intersect(S3,S4),forall((member(X,S3),argMinusAtt(X,Att),subtract(Att,Exclude,Att2)),subset(Att2,S2))),Res3),sort(Res3,Res).
%unifyDefStrat([],[A1,A2,A3,A4],Res):-sort(A1,R1),sort(A2,R2),sort(A3,R3),sort(A4,R4),Res=[R1,R2,R3,R4].
%unifyDefStrat([H|T],Acc,Res):-combineDefStrat(H,Acc,NAcc),unifyDefStrat(T,NAcc,Res).
%combineDefStrat([S1,S2,S3,S4],[T1,T2,T3,T4],Res):-append(S1,T1,R1),append(S2,T2,R2),append(S3,T3,R3),append(S4,T4,R4),Res=[R1,R2,R3,R4].
								
%critAttSets(Arg,Res,Exclude):-attAllStrategy(Arg,Res1,Exclude),minHittingSets(Res1,Res).		
%unifyPath([[Pro1H|Pro1T],[Op1H|Op1T]],[[Pro1H|Pro2T],[Op1H|Op2T]]):-unifyPath([Pro1T,Op1T],[Pro2T,Op2T]).
%altpreferredAllPath(Arg,Res):-altpreferredAllPro(Arg,[],[],Res1),elimD(Res1,[],[],Res).%,findall(X,(member(X,Res1),[Pro,_]=X,member(A,Pro),member(Y,Res1),[_,Op]=Y,member(B,Op),A=B),Rem),subtract(Res1,Rem,Res).
%altpreferredAllPro(Arg,Pl,Ol,Res):- append(Pl,[Arg],Pl2),argMinus(Arg,Att),subtract(Att,Ol,Att1),subtract(Att1,Pl,Att2),(Att2=[]->(Res=[[Pl2,Ol]]);(findall(SubRes,(member(X,Att2),altpreferredAllOp(X,Pl2,Ol,SubRes)),Res2),length(Att2,N),length(Res2,N),resultsAppend(Res2,[],Res))).
%altpreferredAllOp(Arg,Pl,Ol,Res):- append(Ol,[Arg],Ol2),argMinus(Arg,Att),subtract(Att,Ol,Att2),(Att2=[]->fail;(findall(SubRes,(member(X,Att2),altpreferredAllPro(X,Pl,Ol2,SubRes)),Res2),length(Res2,N),N>=1,resultsAppend(Res2,[],Res))).

%elimD([],_,Acc,Acc).
%elimD([[Pro,Op]|T],Ol,Acc,Res):- (member(X,Pro),member(X,Ol))->(elimD(T,Ol,Acc,Res));(append(Ol,Op,Ol2),elimD(T,Ol2,[[Pro,Op]|Acc],Res)).
%strategySplit(X,Res):-
%altattAllStrategy(Arg,Res):-altattAllStrategyPro(Arg,0,[],[],[],[],Res2),sort(Res2,Res).
%altattAllStrategyPro(Arg,Parg,Pattl,Oattl,Pl,Ol,Res2):- append(Pattl,[[Arg,Parg]],Pattl2),append(Pl,[Arg],Pl2),argMinus(Arg,Att),subtract(Att,Ol,Att2),(Att2=[]->fail;(findall(SubRes,(member(X,Att2),altattAllStrategyOp(X,Arg,Pattl2,Oattl,Pl2,Ol,SubRes)),Res),length(Res,N),N>=1,resultsAppend(Res,[],Res2))).
%altattAllStrategyOp(Arg,Parg,Pattl,Oattl,Pl,Ol,Res2):- append(Oattl,[[Arg,Parg]],Oattl2),append(Ol,[Arg],Ol2),argMinus(Ol2,Att),subtractAttack(Att,Ol2,[],Att2),subtract(Att2,Pattl,Att3),((Att3=[];member(Arg,Pl))->(Res2=[[Oattl2,Pattl]]);(findall(SubRes,(member([X,Y],Att3),altattAllStrategyPro(X,Y,Pattl,Oattl2,Pl,Ol2,SubRes)),Res),length(Att3,N),length(Res,N),resultsAppend(Res,[],Res2))).

%notpreferredAllPath(Arg,Res):-notpreferredAllPro(Arg,[],[],[],Res).
%notpreferredAllPro(Arg,L,Pl,Ol,Res2):- append(L,[Arg],L2),append(Pl,[Arg],Pl2),argMinus(Arg,Att),subtract(Att,Ol,Att2),(Att2=[]->fail;(findall(SubRes,(member(X,Att2),notpreferredAllOp(X,L2,Pl2,Ol,SubRes)),Res),length(Res,N),N>=1,resultsAppend(Res,[],Res2))).
%notpreferredAllOp(Arg,L,Pl,Ol,Res2):- append(L,[Arg],L2),append(Ol,[Arg],Ol2),argMinus(Arg,Att),subtract(Att,Ol2,Att2),((Att2=[];member(Arg,Pl))->Res2=[L2];(findall(SubRes,(member(X,Att2),notpreferredAllPro(X,L2,Pl,Ol2,SubRes)),Res),length(Att2,N),length(Res,N),resultsAppend(Res,[],Res2))).

%makePreferred(Arg,Except,Exclude,Res):-critAttSets(Arg,Res1,Exclude),findall(X,(member(X,Res1),forall(member(E,Except),(subtract(E,Exclude,E2),\+subset(E2,X)))),Res2),((Res2=[],Res1\=[])->fail;
%											findall(Z,(member(S,Res2),delete(Res2,S,Ex),append(Except,Ex,Except2),sort(Except2,Except3),append(Exclude,S,Exclude2),makePreferred(Arg,Except3,Exclude2,SubRes),(SubRes=[]->Z=S;(member(R,SubRes),append(S,R,Z)))),Res)).
%preferredPath/2
%para1: an argument									instantiation necessary
%para2: a list of arguments or lists of arguments, or ...
%returns true if para1 is in any preferred set and para2 is a list of strategies for all opponent moves, to proving that para1 is preferred
%preferredPath(Arg,Res):-preferredPro(Arg,[],[],[],Res).
%preferredPro(Arg,L,Pl,Ol,Res):- append(L,[Arg],L2),append(Pl,[Arg],Pl2),argsMinus(Pl2,Att),subtract(Att,Ol,Att2),(Att2=[]->Res=L2;(findall(SubRes,(member(X,Att2),argMinus(X,Xatt),subtract(Xatt,Ol,Xatt2),preferredOp(X,L2,Pl2,Ol,SubRes,Xatt2)),Res),length(Att2,N),length(Res,N))).
%preferredOp(_,_,_,_,_,[]):-!,fail.
%preferredOp(Arg,L,Pl,Ol,Res,[H|T]):- append(L,[Arg],L2),append(Ol,[Arg],Ol2),(preferredPro(H,L2,Pl,Ol2,Res2)->Res=Res2;preferredOp(Arg,L,Pl,Ol,Res,T)).

%allPreferredPath(Arg,Res):-preferredPath(Arg,Res),argPlus(Arg,Att),forall(member(X,Att),\+preferredArg(X)).

%preferredAllPath/2
%para1: an argument									instantiation necessary
%para2: a list of arguments or lists of arguments, or ...
%returns true if para1 is in any preferred set and para2 is a list of all strategies for proving that para1 is preferred
%preferredAllPath(Arg,Res):-preferredAllPro(Arg,[],[],[],Res).
%preferredAllPro(Arg,L,Pl,Ol,Res2):- append(L,[Arg],L2),append(Pl,[Arg],Pl2),argsMinus(Pl2,Att),subtract(Att,Ol,Att2),(Att2=[]->Res2=[L2];(findall(SubRes,(member(X,Att2),preferredAllOp(X,L2,Pl2,Ol,SubRes)),Res),length(Att2,N),length(Res,N),resultsAppend(Res,[],Res2))).
%preferredAllOp(Arg,L,Pl,Ol,Res2):- append(L,[Arg],L2),append(Ol,[Arg],Ol2),argMinus(Arg,Att),subtract(Att,Ol2,Att2),(Att2=[]->fail;(findall(SubRes,(member(X,Att2),preferredAllPro(X,L2,Pl,Ol2,SubRes)),Res),length(Res,N),N>=1,resultsAppend(Res,[],Res2))).

%altpreferredAllPath(Arg,Res):-altpreferredAllPro(Arg,0,[],[],[],[],Res).
%altpreferredAllPro(Arg,Parg,Pattl,Oattl,Pl,Ol,Res2):- append(Pattl,[[Arg,Parg]],Pattl2),append(Pl,[Arg],Pl2),argsMinusAtt(Pl2,Att),subtractAttack(Att,Ol,[],Att2),(Att2=[]->Res2=[[Pattl2,Oattl]];(findall(SubRes,(member([Y,X],Att2),altpreferredAllOp(Y,X,Pattl2,Oattl,Pl2,Ol,SubRes)),Res),length(Att2,N),length(Res,N),resultsAppend(Res,[],Res2))).
%altpreferredAllOp(Arg,Parg,Pattl,Oattl,Pl,Ol,Res2):- append(Oattl,[[Arg,Parg]],Oattl2),append(Ol,[Arg],Ol2),argMinus(Arg,Att),subtract(Att,Ol2,Att2),(Att2=[]->fail;(findall(SubRes,(member(X,Att2),altpreferredAllPro(X,Arg,Pattl,Oattl2,Pl,Ol2,SubRes)),Res),length(Res,N),N>=1,resultsAppend(Res,[],Res2))).

