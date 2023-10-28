dir_pos(n, Row-Col, Row1-Col):-
    Row1 is Row - 1.

dir_pos(e, Row-Col, Row-Col1):-
    Col1 is Col + 1.

dir_pos(s, Row-Col, Row1-Col):-
    Row1 is Row + 1.

dir_pos(w, Row-Col, Row-Col1):-
    Col1 is Col - 1.

% tents_pos(+Trees, +Dirs, +MaxRow-MaxCol, -TreePositions).
tents_pos([], [], _,[]).
tents_pos([Row-Col|T], [Dir|Dt], MaxRow-MaxCol, [Row1-Col1|TT]):-
    dir_pos(Dir, Row-Col, Row1-Col1),
    Row1 > 0,
    Row1 =< MaxRow,
    Col1 > 0,
    Col1 =< MaxCol,
    tents_pos(T, Dt, MaxRow-MaxCol, TT).

% sort will remove duplicates
check_duplicate_pos(List, OriginalList):-
    sort(List, Sorted),
    length(OriginalList, Len),
    length(Sorted, Len).
    
check_duplicate_pos([Row-Col|T]):-
    \+member(Row-Col, T),
    check_duplicate_pos(T).

create_row(_, CurCol, MaxCol, _, []):- CurCol > MaxCol.
create_row(CurRow, CurCol, MaxCol, TentPositions, [1 | Row]):-
    member(CurRow-CurCol, TentPositions),
    CurCol =< MaxCol,
    NextCol is CurCol + 1,
    create_row(CurRow, NextCol, MaxCol, TentPositions, Row).

create_row(CurRow, CurCol, MaxCol, TentPositions, [0 | Row]):-
    \+member(CurRow-CurCol, TentPositions),
    CurCol =< MaxCol,
    NextCol is CurCol + 1,
    create_row(CurRow, NextCol, MaxCol, TentPositions, Row).

create_mx(CurRow, MaxRow, _, _, []):- CurRow > MaxRow.
create_mx(CurRow, MaxRow, MaxCol, TentPositions, [Row | Mx]):-
    CurRow =< MaxRow,
    create_row(CurRow, 1, MaxCol, TentPositions, Row),
    NextRow is CurRow + 1,
    create_mx(NextRow, MaxRow, MaxCol, TentPositions, Mx).


satrak_mx(Row-Col, Trees, TentDirs, Mx):-
    tents_pos(Trees, TentDirs, Row-Col, TentPositions),
    check_duplicate_pos(TentPositions, TentPositions),
    print(TentPositions),
    create_mx(1, Row, Col, TentPositions, Mx).

