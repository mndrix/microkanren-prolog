:- use_module(library(edcg)).

% Playing around with microKanren implemented using extended DCG syntax

edcg:acc_info(stream,St,In,Out,Out=[St|In]).
edcg:acc_info(subs,Sub,In,Out,Out=[Sub|In]).
edcg:acc_info(counter,In,In,Out,succ(In,Out)).

edcg:pred_info(call_fresh,3,[counter,subs]).
edcg:pred_info(conj,3,[counter,subs]).
edcg:pred_info(disj,3,[counter,subs]).
edcg:pred_info(lookup,2,[subs]).
edcg:pred_info(state,1,[counter,subs]).
edcg:pred_info(unify,2,[counter,subs,stream]).
edcg:pred_info(unification,2,[subs]).
edcg:pred_info(unification_,2,[subs]).
edcg:pred_info(walk,2,[subs]).
edcg:pred_info(var,1,[counter]).

var(var(N)) -->>
   [N]:counter.

walk(U,V) -->>
    U=var(_),
    lookup(U,V0),
    !,
    walk(V0,V).
walk(U,U) -->>
    [].

lookup(U,V) -->>
    Subs/subs,
    memberchk(U-V,Subs).

state(state(Subs,C)) -->>
     C/counter,
     Subs/subs.

unify(U0,V0) -->>
    walk(U0,U),
    walk(V0,V),
    unification_(U,V),
    !,
    C/counter,
    Subs/subs,
    [state(Subs,C)]:stream.
unify(_,_) -->>
    []:stream.

unification_(var(N),var(N)) -->> [].
unification_(var(N),T) -->> [var(N)-T]:subs.
unification_(T,var(N)) -->> [var(N)-T]:subs.
unification_(Ua-Ub,Va-Vb) -->>
    unification(Ua,Va),
    unification(Ub,Vb).
unification_(U,V) -->>
    U == V.

call_fresh(X,Goal,Str) -->>
    var(X),
    state(St),
    call(Goal,St,Str).

disj(Goal1,Goal2,Str) -->>
    state(St),
    call(Goal1,St,Str1),
    call(Goal2,St,Str2),
    mplus(Str1,Str2,Str).

conj(Goal1,Goal2,Str) -->>
    state(St),
    call(Goal1,St,Str0),
    bind(Str0,Goal2,Str).

% todo.
