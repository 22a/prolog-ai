% a-star search
% peter meehan - 13318021

arc(N,M,Seed,NCost,Cost) :- M is N*Seed, Cost is NCost + 1.
arc(N,M,Seed,NCost,Cost) :- M is N*Seed + 1, Cost is NCost + 2.

goal(N,Target) :- 0 is N mod Target.

h(N,Hvalue,Target) :- goal(N,Target), !, Hvalue is 0
                      ;
                      Hvalue is 1/N.

less-than([Node1,Cost1],[Node2,Cost2],Target) :-
  h(Node1,Hvalue1,Target), h(Node2,Hvalue2,Target),
  F1 is Cost1+Hvalue1, F2 is Cost2+Hvalue2,
  F1 =< F2.

add-to-frontier(FNode,[],FNew,_) :- FNew = [FNode].
add-to-frontier(FNode,[F|FRest],FNew,Target) :-
  less-than(FNode,F,Target), !, FNew = [FNode,F|FRest];
  add-to-frontier(FNode,FRest,C,Target),FNew = [F|C].

add-list-to-frontier(NList,[],FNew,_) :- FNew = NList.
add-list-to-frontier([],FRest,FNew,_) :- FNew = FRest.
add-list-to-frontier([N|NRest],FRest,FNew,Target) :-
  add-to-frontier(N,FRest,C,Target),
  add-list-to-frontier(NRest,C,FNew,Target).

a-star(Start,Seed,Target,Found) :- search([[Start,0]],Seed,Target,Found).

search([[Node,_]|_],_,Target,Found) :- goal(Node,Target), Found is Node.
search([[Node,NCost]|FRest],Seed,Target,Found) :-
  bagof([X,Cost],arc(Node,X,Seed,NCost,Cost), FNodes),
  add-list-to-frontier(FNodes,FRest,FNew,Target),
  search(FNew,Seed,Target,Found).




% debug code below
debug-search([[Node,_]|_],_,Target,Found) :- goal(Node,Target), Found is Node.
debug-search([[Node,NCost]|FRest],Seed,Target,Found) :-
  write('node: '), write(Node),nl,
  write('cost: '), write(NCost),nl,
  write('rest of stack: '), printlist(FRest),
  setof([X,Cost],arc(Node,X,Seed,NCost,Cost), FNodes),
  write('newly found children: '), printlist(FNodes),
  add-list-to-frontier(FNodes,FRest,FNew,Target),
  debug-search(FNew,Seed,Target,Found).

printlist([]) :- nl.
printlist([X|List]) :-
  write(X),nl,
  printlist(List).
