%% Probability mass function

n = 16; % no. of support points
% Probabilities chosen uniformly at random
    % wu = rand([n 1]);
    % w=wu/sum(wu);
% Exponential probabilities
    r = 0.8;
    w = ( r.^(0:n-1)' ) ./ sum( r.^(0:n-1)' );


%% Compute the cdf
F = zeros([n 1]);
F(1) = w(1);
for i = 2:n
    F(i) = F(i-1)+w(i);
end %i

%% Expectation of the cdf
E = F'*w;
E2 = (F.^2)'*w;

%% Fictitious sampling 
k = 4; % no. of fictitious samples
m = 5e+2; % window length
for j = 1:m
    y = randsample(1:n,k,true,w);
    
    % The usual count
    c(j) = 0;
    for i = 2:k
        if y(i) <= y(1)
            c(j) = c(j)+1;
        end %if
    end %i
end %j
    
%% No fictitious sampling

% Samples from the true distribution to construct a histogram (for
% comparison)
m = 1e+3;
y0 = randsample(1:n,m,true,w);

% We construct histograms with k bins. S is the number of support points
% per bin.
k = 4;
S = ceil(n/k);

% Weights (same as w, actually)
W = zeros([k*S 1]);
W(1:n) = w;
% The support set
Y = 1:k*S;
% Counts for the histograms: C is the counter for the histogram of the
% actual samples, C0 is the histogram corrected by the pmf to yield a
% uniform distribution
C = zeros([k 1]);
C0 = zeros([k 1]);
for j = 1:m
    for l = 1:k
        idx = (l-1)*S + (1 : S);
        if not(isempty(find(y0(j)==Y(idx), 1)))
            C(l) = C(l) + 1 / (k*sum(W(idx)));
            C0(l) = C0(l) + 1;
        end %if
    end %l
end %j

figure(1); bar(1:k,C0); title('Original histogram');
figure(2); bar(1:k,C); title('Corrected histogram');