dir_pos(n, Row-Col, Row1-Col):-
    Row1 is Row - 1.

dir_pos(e, Row-Col, Row-Col1):-
    Col1 is Col + 1.

dir_pos(s, Row-Col, Row1-Col):-
    Row1 is Row + 1.

dir_pos(w, Row-Col, Row-Col1):-
    Col1 is Col - 1.

is_pos_valid(Row-Col, MaxRow-MaxCol, Trees):-
    Row >= 1,
    Row =< MaxRow,
    Col >= 1,
    Col =< MaxCol,
    \+member(Row-Col, Trees).

check_tent_pos(MaxRow-MaxCol, Row-Col, Trees, [Dir | DirTail], [Dir | IL]):-
    dir_pos(Dir, Row-Col, TentRow-TentCol),
    is_pos_valid(TentRow-TentCol, MaxRow-MaxCol, Trees),
    check_tent_pos(MaxRow-MaxCol, Row-Col, Trees, DirTail, IL).

check_tent_pos(MaxRow-MaxCol, Row-Col, Trees, [Dir | DirTail], IL):-
    dir_pos(Dir, Row-Col, TentRow-TentCol),
    \+is_pos_valid(TentRow-TentCol, MaxRow-MaxCol, Trees),
    check_tent_pos(MaxRow-MaxCol, Row-Col, Trees, DirTail, IL).

    
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
    iranylistak(MaxRow-MaxCol, Fs, ILs).
iranylistak(_, [], _, []).