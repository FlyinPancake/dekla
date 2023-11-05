dir_pos(n, Row-Col, Row1-Col):-
    Row1 is Row - 1.

dir_pos(e, Row-Col, Row-Col1):-
    Col1 is Col + 1.

dir_pos(s, Row-Col, Row1-Col):-
    Row1 is Row + 1.

dir_pos(w, Row-Col, Row-Col1):-
    Col1 is Col - 1.

dir_pos(ne, Row-Col, Row1-Col1):-
    Row1 is Row - 1,
    Col1 is Col + 1.

dir_pos(se, Row-Col, Row1-Col1):-
    Row1 is Row + 1,
    Col1 is Col + 1.

dir_pos(sw, Row-Col, Row1-Col1):-
    Row1 is Row + 1,
    Col1 is Col - 1.

dir_pos(nw, Row-Col, Row1-Col1):-
    Row1 is Row - 1,
    Col1 is Col - 1.

is_pos_valid(Row-Col, MaxRow-MaxCol, Trees):-
    Row >= 1,
    Row =< MaxRow,
    Col >= 1,
    Col =< MaxCol,
    \+member(Row-Col, Trees).

check_tent_pos(MaxRow-MaxCol, Row-Col, Trees, [Dir | DirTail], [Dir | IL]):-
    check_tent_pos(MaxRow-MaxCol, Row-Col, Trees, DirTail, IL),
    dir_pos(Dir, Row-Col, TentRow-TentCol),
    is_pos_valid(TentRow-TentCol, MaxRow-MaxCol, Trees).

check_tent_pos(MaxRow-MaxCol, Row-Col, Trees, [Dir | DirTail], IL):-
    check_tent_pos(MaxRow-MaxCol, Row-Col, Trees, DirTail, IL),
    dir_pos(Dir, Row-Col, TentRow-TentCol),
    \+is_pos_valid(TentRow-TentCol, MaxRow-MaxCol, Trees).

    
check_tent_pos(_, _, _, [], []).

ensure_dir_lists([]).
ensure_dir_lists([H|T]):-
    length(H, L),
    L > 0,
    ensure_dir_lists(T).

iranylistak(MaxRow-MaxCol, Trees, IranyListak):-
    iranylistak(MaxRow-MaxCol, Trees, Trees, IranyListak),
    ensure_dir_lists(IranyListak), !.

iranylistak(_,_,[]).

iranylistak(MaxRow-MaxCol, [TreeRow-TreeCol | Fs], Trees, [IL| ILs]):-
    check_tent_pos(MaxRow-MaxCol, TreeRow-TreeCol, Trees, [e, n, s, w], IL),
    iranylistak(MaxRow-MaxCol, Fs, Trees, ILs).
iranylistak(_, [], _, []).

% :- pred get_nth_element(N::in,       % N
%                        List::in,     % List
%                        Element::out) % Element
get_nth_element(1, [X|_], X).
get_nth_element(N, [_|T], Element) :-
    N > 1,
    N1 is N - 1,
    get_nth_element(N1, T, Element).

% :- pred sator_szukites(fák::in,            % Fs
%                        int::in,            % I
%                        iránylisták::in,    % ILs0
%                        iránylisták::out)   % ILs
sator_szukites(Fs, I, ILs0, ILs):-
    get_nth_element(I, ILs0, ThisDirList),
    get_nth_element(1, ThisDirList, ThisTreeDir),
    length(ThisDirList, 1),
    get_nth_element(I, Fs, ThisTree),
    dir_pos(ThisTreeDir, ThisTree, ThisTent),
    get_forbidden_positions(ThisTent, Fs, ForbiddenPositions),
    sort(ForbiddenPositions, SortedForbiddenPositions),
    shrink_possible_positions(Fs, [ThisTent|SortedForbiddenPositions], ThisTree, ILs0, ILs).

get_adjacent_positions(_, [], []).
get_adjacent_positions(Row-Col, [Dir| TDir], [AdjRow-AdjCol|T]):-
    dir_pos(Dir, Row-Col, AdjRow-AdjCol),
    get_adjacent_positions(Row-Col, TDir, T).

% :- pred get_forbidden_positions(sator::in,            % Tent
%                                 fák::in,              % Fs
%                                 tiltott_pozíciók::out) % ForbiddenPositions
get_forbidden_positions(Row-Col, Trees, ForbiddenPositions):-
    get_adjacent_positions(Row-Col, [n,e,s,w,ne,se,sw,nw], AdjacentPositions),
    append(Trees, AdjacentPositions, ForbiddenPositions).


% Don't shrink if we are at the end of the list TODO
% :- pred shrink_possible_positions(Fák::in,          % Fs
%                                   tiltott_pozíciók::in, % ForbiddenPositions
%                                   iránylisták::in,  % ILs0
%                                   iránylisták::out) % ILs
shrink_possible_positions([], _, _,[], []).
shrink_possible_positions(
    [ShrinkTree| TailTrees],
    ForbiddenPositions,
    ShrinkTree,
    [IL|TailILs],
    [IL|TailCorrectDirs]
) :- 
    shrink_possible_positions(TailTrees, ForbiddenPositions, ShrinkTree, TailILs, TailCorrectDirs).
shrink_possible_positions(
    [CurTree|TailTrees],
    ForbiddenPositions,
    ShrinkTree,
    [IL|TailILs],
    [CorrectDirs | TailCorrectDirs]
):-
    length(IL, ILLength),
    ILLength >= 1,
    shrink_this_position(CurTree, IL, ForbiddenPositions, CorrectDirs),
    CurTree \= ShrinkTree,
    shrink_possible_positions(TailTrees, ForbiddenPositions, ShrinkTree, TailILs, TailCorrectDirs).

shrink_this_position(_, [], _, []).
shrink_this_position(
    Pos,
    [Dir | TailDirs], 
    ForbiddenPositions,
    [Dir | CorrectDirs]
):-
    dir_pos(Dir, Pos, AdjPos),
    \+member(AdjPos, ForbiddenPositions),
    shrink_this_position(Pos, TailDirs, ForbiddenPositions, CorrectDirs).

shrink_this_position(
    Pos,
    [Dir | TailDirs], 
    ForbiddenPositions,
    CorrectDirs
):-
    dir_pos(Dir, Pos, AdjPos),
    member(AdjPos, ForbiddenPositions),
    shrink_this_position(Pos, TailDirs, ForbiddenPositions, CorrectDirs).


% :- type parcMutató ==    int-int.          % egy parcella helyét meghatározó egészszám-pár
% :- type fák ==           list(parcMutató). % a fák helyeit tartalmazó lista
% :- type irány    --->    n                 % észak 
%                        ; e                 % kelet 
%                        ; s                 % dél   
%                        ; w.                % nyugat
% :- type iránylista ==    list(irany).      % egy adott fához rendelt sátor
                                             % lehetséges irányait megadó lista
% :- type iránylisták ==   list(iránylista). % az összes fa iránylistája

% :- type összegfeltétel==sor(int, int);     % sor(I,Db): az I-edik sorbeli sátrak száma Db
%                         oszl(int, int).    % oszl(J,Db): a J-edik oszlopbeli sátrak száma Db

% :- pred osszeg_szukites(fák::in,           % Fs
%                         összegfeltétel::in,% Osszegfeltetel
%                         iránylisták::in,   % ILs0
%                         iránylisták::out)  % ILs

fix_trees([], [], _, []).
fix_trees([Tree | TailTrees], [Dirs | TailDirs], SumReq, [Tree-Dirs | FixedTrees]):-
    is_fix_tree(Tree, Dirs, SumReq),
    fix_trees(TailTrees, TailDirs, SumReq, FixedTrees).
fix_trees([Tree | TailTrees], [Dirs | TailDirs], SumReq, FixedTrees):-
    \+is_fix_tree(Tree, Dirs, SumReq),
    fix_trees(TailTrees, TailDirs, SumReq, FixedTrees).


is_fix_tree(Tree, [Dir | TailDir], sor(Row, _)):-
    dir_pos(Dir, Tree, Row-_),
    is_fix_tree(Tree, TailDir, sor(Row, _)).

is_fix_tree(Tree, [Dir | TailDir], oszl(Col, ColSum)):-
    dir_pos(Dir, Tree, _-Col),
    is_fix_tree(Tree, TailDir, oszl(Col, ColSum)).

is_fix_tree(_, [], _).


% osszeg_szukites(Fs, sor(Row, RowSum), ILs0, ILs):-
%     fix_trees(Fs, ILs0, sor(Row, RowSum), FixedTrees),
%     print(FixedTrees).


% osszeg_szukites(Fs, oszl(Col, ColSum), ILs0, ILs):-
%     fix_trees(Fs, ILs0, oszl(Col, ColSum), FixedTrees),
%     print(FixedTrees).
    

osszeg_szukites(Fs, SumReq, ILs0, ILs):-
    fix_trees(Fs, ILs0, SumReq, FixedTrees),
    print(FixedTrees).
    
