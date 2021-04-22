a = [1 2 3 5]
b = [1 2 3 4 6]

aCoordinate = [3 4; 3 6; 6 6; 6 4]'
bCoordinate = [8 8; 6 8; 6 5; 6 9]'

%% add noise
M = length(aCoordinate)
sigma = 0.05; % Std. dev. of noise
aCoordinate = aCoordinate + randn(2, M) * sigma;
bCoordinate = bCoordinate + randn(2, M) * sigma; 


%% perform intersect and calculate

common = intersect(a,b)
chi = aCoordinate(:,common)
x = bCoordinate(:,common)

% Subtract the means
x_prime = x - mean(x, 2);
chi_prime = chi - mean(chi, 2);
M = length(common)
% Compute dispersion matrix
D = (chi_prime * x_prime.') / M; % Same as eq. 11 from Sachar e.a.

% Singular value decomposition
[U, ~, V] = svd(D);

% Recover rotation matrix
R = U * V.';

% Recover translation vector
Gamma = mean(chi - R * x, 2);

% Transform x points using recovered results
x_transformed = R * bCoordinate + Gamma; % Eq. 15 from Sachar e.a.

scatter(aCoordinate(1,:),aCoordinate(2,:),'o')
hold all
scatter(bCoordinate(1,:),bCoordinate(2,:),'x')
hold all
scatter(x_transformed(1,:),x_transformed(2,:),'+','magenta')
xlim([0 10])
ylim([0 10])
legend("Set A","Set B","Set B mapped to A")