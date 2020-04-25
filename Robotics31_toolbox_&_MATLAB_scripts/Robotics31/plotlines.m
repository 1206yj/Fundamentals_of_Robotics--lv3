function plotlines(U, L, pen)

plot([U(1,L(1,:)); U(1,L(2,:))], -[U(2,L(1,:)); U(2,L(2,:))], pen)
