function [J, grad] = cofiCostFunc(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
%COFICOSTFUNC Collaborative filtering cost function
%   [J, grad] = COFICOSTFUNC(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.
%

% Unfold the U and W matrices from params
X = reshape(params(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);

            
% You need to return the following values correctly
J = 0;
X_grad = zeros(size(X));
Theta_grad = zeros(size(Theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost function and gradient for collaborative
%               filtering. Concretely, you should first implement the cost
%               function (without regularization) and make sure it is
%               matches our costs. After that, you should implement the 
%               gradient and use the checkCostFunction routine to check
%               that the gradient is correct. Finally, you should implement
%               regularization.
%
% Notes: X - num_movies  x num_features matrix of movie features
%        Theta - num_users  x num_features matrix of user features
%        Y - num_movies x num_users matrix of user ratings of movies
%        R - num_movies x num_users matrix, where R(i, j) = 1 if the 
%            i-th movie was rated by the j-th user
%
% You should set the following variables correctly:
%
%        X_grad - num_movies x num_features matrix, containing the 
%                 partial derivatives w.r.t. to each element of X
%        Theta_grad - num_users x num_features matrix, containing the 
%                     partial derivatives w.r.t. to each element of Theta
%
J = sum((((X * Theta' - Y) .* R) .^ 2) (:)) / 2;

J = J + (lambda / 2) * (sum((Theta .^ 2)(:) ) + sum((X .^ 2)(:) ));
n_m = size(X);
for i = 1:n_m
  idx = find(R(i, :) == 1);
  Theta_tmp = Theta(idx, :);
  Y_tmp = Y(i, idx);
  diff_l = X(i, :) * Theta_tmp' - Y_tmp;
  X_grad(i, :) = diff_l * Theta_tmp;
  X_grad(i, :) =   X_grad(i, :) + lambda * X(i,:);
end;

n_u = size(Theta);
for j = 1:n_u
  %j - current user, idx - movies rated by this user
  idx = find(R(:,j) == 1);
  % feature vector for current user
  Theta_tmp = Theta(j, :);
%features of movies rated by current user 
  X_tmp = X(idx, :);
%ratings given by current user
  Y_tmp = Y(idx, j);
  diff_l =  Theta_tmp * X_tmp' - Y_tmp';
  Theta_grad(j, :) = diff_l * X_tmp;
  Theta_grad(j, :) =   Theta_grad(j, :) + lambda * Theta(j, :);
end;



% =============================================================

grad = [X_grad(:); Theta_grad(:)];

end
