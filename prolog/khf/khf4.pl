% :- type parcMutató ==   int-int.          % egy parcella helyét meghatározó egészszám-pár
% :- type fák        ==   list(parcMutató). % a fák helyeit tartalmazó lista
% :- type irány    --->   n                 % észak 
%                       ; e                 % kelet 
%                       ; s                 % dél   
%                       ; w.                % nyugat
% :- type sHelyek    ==   list(irany).      % a fákhoz tartozó sátrak irányát megadó lista
% :- type bool       ==   int               % csak 0 vagy 1 lehet
% :- type boolMx     ==   list(list(bool)). % a sátrak helyét leíró 0-1 mátrix

% :- pred satrak_mx(parcMutató::in,         % NM
%                   fák::in,                % Fs
%                   sHelyek::in,            % Ss
%                   boolMx::out).           % Mx

satrak_mx(1-1, [], [], Mx):-
    Mx = [[0]].

satrak_mx(Row-Col, Trees, TentDirs, Mx):-
    length(Mx, Row),
    member(SomeRow, Mx),
    length(Row1, Col).
    