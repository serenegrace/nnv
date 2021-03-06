load NeuralNetwork7_3.mat;
Layers = [];
n = length(b);
for i=1:n - 1
    bi = cell2mat(b(i));
    Wi = cell2mat(W(i));
    Li = Layer(Wi, bi, 'ReLU');
    Layers = [Layers Li];
end
bn = cell2mat(b(n));
Wn = cell2mat(W(n));
Ln = Layer(Wn, bn, 'Linear');

Layers = [Layers Ln];

F = FFNN(Layers);

lb = [-1; -1; -1];
ub = [1; 1; 1];

I = Polyhedron('lb', lb, 'ub', ub);

% select option for reachability algorithm

[R, t] = F.reach(I, 'exact', 4, []); % exact reach set
%[R, t] = F.reach(I, 'approx', 1, 300); % over-approximate reach set
%[R, t] = F.reach(I, 'mix', 4, 800); % mixing scheme - over-approximate reach set
save F.mat F; % save the verified network
F.print('F.info'); % print all information to a file


% generate some input to test the output
e = 0.25;
x = [];
y = [];
for x1=-1:e:1
    for x2=-1:e:1
        for x3=-1:e:1
            xi = [x1; x2; x3];
            yi = F.evaluate(xi);
            x = [x, xi];
            y = [y, yi];
        end
    end
end

fig = figure;
R.plot;
hold on;
plot(y(1, :), y(2, :), 'o');

