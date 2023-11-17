atom_prefix(_, '', 0).
atom_prefix(Atom, Prefix, N):-
    atom_codes(Atom, AtomCodes),
    length(AtomCodes, AtomLength),
    N =< AtomLength,
    AtomCodes = [AtomHead| AtomTail],
    NNext is N - 1,
    atom_codes(AtomNext, AtomTail),
    atom_prefix(AtomNext, PrefixNext, NNext),
    atom_codes(PrefixNext, PrefixNextCodes),
    atom_codes(Prefix, [AtomHead | PrefixNextCodes]).


reszatom(X, X):- atom(X).
reszatom(Kif, Atom):-
    nonvar(Kif),
    Kif =.. [_ | Args],
    subterm_list(Atom, Args).

subterm_list(Atom, [H|_]):- reszatom(H, Atom).
subterm_list(Atom, [_|T]):- subterm_list(Atom, T).


% osszege(+K, ?Ossz): Ossz a K kifejezésben előforduló egész számok
% összege.
osszege(Number, Number):- number(Number).
osszege(Kif, Sum):-
    \+number(Kif),
    nonvar(Kif),
    compound(Kif),
    Kif =.. [_|Args],
    osszege_list(Args, Sum).
osszege(NonNumber, 0):- \+number(NonNumber), \+compound(NonNumber).

osszege_list([], 0).
osszege_list([H|T], Sum):-
    osszege(H, HSum),
    osszege_list(T, TSum),
    Sum is HSum + TSum.

p(1).
p(2).
p(X) :- X > 1.

m(2, 0).
m(1, 2).
m(1, 3).
m(2, 1).
m(_, 4).

q(X) :- m(_, X), p(X).

% Adott bemeneti számlista esetén balról jobbra haladva sorolja fel a lista
%     szélsőértékeit, azaz azokat az elemeket, amelyeknek mindkét oldalán van
%     szomszédja, és amelyek vagy mindkét közvetlen szomszédnál határozottan nagyobbak,
%     vagy mindkettőnél határozottan kisebbek!

f5(List, X) :-
    append(_, [Left, X,Right|_], List),
    (
        X > Right,
        X > Left;
        X < Right,
        X < Left
    ).

% Adott bemeneti számlista esetén sorolja fel az összes olyan A-B párt, amelyre A
% és B az adott listában közvetlenül szomszédos elemekként (ebben a sorrendben)
% előfordulnak és amelyre az A+B összeg értéke 5!

% f6(L, A-B): A és B két olyan szomszédos eleme az L számlistának, amelyek
% összege 5.

f6(List, A-B) :-
    append(_, [A,B|_], List),
    A + B =:= 5.

% Adott bemeneti számlista esetén sorolja fel az összes olyan h(A,S,B) struktúra-
% kifejezést, amelyre A, S és B a bemeneti listában (nem feltétlenül szomszédos)
% elemekként ebben a sorrendben előfordulnak és amelyre az A+B összeg értéke S!

f7(List, h(A, S, B)):-
    nth0(IdA, List, A),
    nth0(IdS, List, S),
    nth0(IdB, List, B),
    IdA < IdS,
    IdS < IdB,
    S =:= A + B.

f8(List, Sum):-
    findall(X, (member(X,List), X mod 2 =:= 0), EvenNumbers),
    sumlist(EvenNumbers, Sum).
    
helyettesitese(Number, _, Number):- number(Number),!.
helyettesitese(ReplaceFrom, [ReplaceFrom-ReplaceTo | _], ReplaceTo):- !.
helyettesitese(ReplaceFrom, [_|Tail], ReplaceTo):- helyettesitese(ReplaceFrom, Tail, ReplaceTo).
helyettesitese(Atom, [], Atom):- atom(Atom).

erteke(Value, ReplaceList, Result):-
    (atom(Value); number(Value)),
    \+ compound(Value),
    helyettesitese(Value, ReplaceList, Result).

erteke(Term, ReplaceList, Result):-
    \+ atom(Term),
    \+ number(Term), 
    compound(Term),
    Term =.. List,
    value_of_list(List, ReplaceList, ResultList),
    CompleteTerm =.. ResultList,
    Result is CompleteTerm.
    
value_of_list([],_,[]).
value_of_list([TermHead| TermTail], ReplaceList,[ResultHead | ResultTail]):-
    erteke(TermHead, ReplaceList, ResultHead),
    value_of_list(TermTail, ReplaceList, ResultTail).

kezdo_szava(CharList, [A,B|FirstWord], Tail):-
    CharList = [A,B|CharRest],
    A >= 97,
    A =< 122,
    B >= 97,
    B =< 122,
    kezdo_szava_helper(CharRest, FirstWord, Tail).

kezdo_szava_helper([], _, []).
kezdo_szava_helper([Char|CharList], [Char|FirstWordTail], Tail):-
    Char >= 97,
    Char =< 122,
    kezdo_szava_helper(CharList, FirstWordTail, Tail).
kezdo_szava_helper([Char|Tail], [], [Char|Tail]):-
        (Char < 97;
        Char > 122).


szava(Atom, Szo, Index) :-
    atom_codes(Atom, CharList),
    length(CharList, AtomLength),
    between(1, AtomLength, Index),
    is_substring(FirstWord, CharList, Index),
    kezdo_szava(CharList, FirstWord, _),
    atom_codes(Szo, FirstWord).

is_substring(SubString, String, Index):- is_substring_helper(SubString, String, Index).

is_substring_helper(SubString, [_| Tring], Index):-
    is_substring_helper(SubString, Tring, OldIndex),
    Index is OldIndex + 1.
is_substring_helper(SubString, String, 1):-
    check_prefix(SubString, String).


check_prefix([],_, _).
check_prefix([H|SubStringTail], [H| StringTail]):-
    check_prefix(SubStringTail, StringTail).

