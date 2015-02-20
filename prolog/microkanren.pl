:- module(microkanren, [
    call_fresh/4,
    conj/4,
    disj/4,
    empty_state/1,
    unify/4
]).

%% Naming conventions
%
% Sub - a substitution
% C - a variable counter
% Sta - a state combining Sub and C
% Str - a stream
% T - a term

empty_state(state([],1)).

var(var(C0),state(Sub,C0),state(Sub,C)) :-
    succ(C0,C).

walk(U,Sub,V) :-
    ( U=var(_), memberchk(U-V0,Sub) -> walk(V0,Sub,V); V=U ).

unify(U,V,state(Sub0,C),Str) :-
    ( unification(U,V,Sub0,Sub) -> unit(state(Sub,C),Str); Str=[] ).

unification(U0,V0,Sub0,Sub) :-
    walk(U0,Sub0,U),
    walk(V0,Sub0,V),
    once(unification_(U,V,Sub0,Sub)).

unification_(var(N),var(N),Sub,Sub).
unification_(var(N),T,Sub,[var(N)-T|Sub]).
unification_(T,var(N),Sub,[var(N)-T|Sub]).
unification_(Ua-Ub,Va-Vb,Sub0,Sub) :-
    unification(Ua,Va,Sub0,Sub1),
    unification(Ub,Vb,Sub1,Sub).
unification_(U,V,Sub,Sub) :-
    U == V.

unit(Sta,[Sta]).

call_fresh(X,Goal,St0,Str) :-
    var(X,St0,St),
    call(Goal,St,Str).

disj(Goal1,Goal2,St0,Str) :-
    call(Goal1,St0,Str1),
    call(Goal2,St0,Str2),
    mplus(Str1,Str2,Str).

conj(Goal1,Goal2,St0,Str) :-
    call(Goal1,St0,Str0),
    bind(Str0, Goal2, Str).

mplus(Str1,Str2,Str) :-
    is_immature(Str1),
    !,
    freeze(Str,(force(Str1),mplus(Str2,Str1,Str))).
mplus([],Str,Str).
mplus([St|Sts0],Str,[St|Sts]) :-
    mplus(Sts0,Str,Sts).

bind(Str0,Goal,Str) :-
    is_immature(Str0),
    !,
    freeze(Str,(force(Str0),bind(Str0,Goal,Str))).
bind([],_,[]).
bind([St|Sts],Goal,Str) :-
    call(Goal,St,Str1),
    bind(Sts,Goal,Str2),
    mplus(Str1,Str2,Str).

is_immature(Str) :-
    \+ frozen(Str,true).

force(Str) :-
    once(Str=[_|_]; Str=[]).
