fives(X) -->
    disj(unify(X,5),delay(fives(X))).

sixes(X) -->
    disj(unify(X,6),delay(sixes(X))).

fives_and_sixes(X) -->
    disj(fives(X),sixes(X)).

five_or_six(X) -->
    disj(unify(X,5),unify(X,6)).
