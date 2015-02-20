# Description

A Prolog implementation of microKanren as described in the [paper](http://webyrd.net/scheme-2013/papers/HemannMuKanren2013.pdf) *μKanren: A Minimal Functional Core for Relational Programming* by Jason Hemann and Daniel P. Friedman.

# Example

```prolog
% swipl -s microkanren.pl
?- [examples].
?- empty_state(S0), call_fresh(X,fives_and_sixes(X),S0,[A,B,C|_]).
A = C, C = state([var(1)-5], 2),
B = state([var(1)-6], 2).
```
