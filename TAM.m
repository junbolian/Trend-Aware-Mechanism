%___________________________________________________________________________________________________________________________________________________%

% 📜 Trend-Aware Mechanism (TAM) source codes (version 1.0)

% 🌐 Website and codes of TAM: https://github.com/junbolian/Trend-Aware-Mechanism

% 📅 Last update: Nov  2024

% 📧 E-Mail: junbolian@qq.com
  
%----------------------------------------------------------------------------------------------------------------------------------------------------%

% 👥 Inventor: Junbo Lian (junbolian@qq.com)

%----------------------------------------------------------------------------------------------------------------------------------------------------%

% ✍️ After use of code, please users cite to the main paper on TAM:

% 👥 Junbo Jacob Lian, Kaichen OuYang, Rui Zhong, Yujun Zhang, Shipeng Luo, Ling Ma, Xincan Wu, Huiling Chen*
% 📜 Trend-Aware Mechanism: A Novel Update Strategy for Improved Metaheuristic Algorithm Performance

%____________________________________________________________________________________________________________________________________________________%


function Vec = TAM(search_history, fitness_history, Max_iter, i, j, K)
    % Inputs:
    % - search_history: historical search positions, 3D matrix (N, Max_iter, dim)
    % - fitness_history: historical fitness values, 2D matrix (N, Max_iter)
    % - Max_iter: maximum number of iterations
    % - i: current iteration index
    % - j: individual index in the population
    % - K: number of nearest points to consider
    
    % If i <= n, skip the trend-aware update mechanism
    n = 3;
    if i <= n 
        Vec = zeros(1, size(search_history, 3));  % Return a zero row vector of size 1 x dim
        return;
    end

    % Dimensions of the problem
    [N, ~, dim] = size(search_history);

    % Current and previous positions
    pos_curr = squeeze(search_history(j, i-1, :));  % Position at iteration (i-1)
    pos_prev = squeeze(search_history(j, i-2, :));  % Position at iteration (i-2)
    
    % Compute trend vector V (Eq. (2))
    V = pos_prev - pos_curr;

    % Generate random vector V' using adaptive covariance mechanism (Eq. (3)-(7))
    X = squeeze(search_history(:, i-1, :));  % Positions of all individuals at iteration (i-1)
    mu = zeros(dim, 1);
    Sigma = cov(X);  % Covariance matrix
    Z = mvnrnd(mu, Sigma);  % Random vector Z ~ N(0, Σ)


    % Compute high-dimensional vector V'
    alpha = i / Max_iter;  % Weighting parameter alpha (Eq. (6))
    beta = 1 - alpha;  % Weighting parameter beta
    V_prime = alpha * V + beta * Z';  % Eq. (5)

    % Preallocate distances and index pairs
    dists = zeros(N * (i - 1), 1);  % Preallocate with maximum possible size
    index_pairs = zeros(N * (i - 1), 2);  % Preallocate with maximum possible size
    count = 0;  % Counter for valid distances

    % Vectorize distance calculations
    v_curr_prev = pos_prev - pos_curr;  % Vector from pos_curr to pos_prev
    norm_v_curr_prev = norm(v_curr_prev);  % Pre-calculate norm

    for p = 1:N
        for it = i-n:i-1  % Iterate through n past iterations up to (i-1)
            P = squeeze(search_history(p, it, :));  % Point at iteration 'it'
            % Vector from pos_curr to P
            v_curr_P = P - pos_curr;
            
            % Projection of v_curr_P onto v_curr_prev
            proj_factor = dot(v_curr_P, v_curr_prev) / norm_v_curr_prev^2;  % Normalize only once
            projection = proj_factor * v_curr_prev;  % Projected vector
            
            % Perpendicular distance (Euclidean distance) between P and the line
            d = norm(v_curr_P - projection);
            count = count + 1;  % Increment valid count
            dists(count) = d;  % Store distance
            index_pairs(count, :) = [p, it];  % Store the individual and iteration index
        end
    end

    % Trim preallocated arrays to the actual size used
    dists = dists(1:count);
    index_pairs = index_pairs(1:count, :);

    % Find the K points with the smallest distances
    [~, sorted_idx] = sort(dists);  % Sort distances in ascending order
    nearest_indices = sorted_idx(1:K);  % Select K nearest points
    K_nearest = index_pairs(nearest_indices, :);  % Get corresponding individual and iteration pairs

    % Perform fitness comparison and update strategy (Eq. (8)-(10))
    F = zeros(K, 1);
    for k = 1:K
        p_k = K_nearest(k, 1);  % Individual index of the K-th nearest point
        it_k = K_nearest(k, 2);  % Iteration index of the K-th nearest point
        f_k = fitness_history(p_k, it_k);  % Fitness value at nearest point

        f_prev1 = fitness_history(j, i-1);  % Fitness at iteration (i-1)
        f_prev2 = fitness_history(j, i-2);  % Fitness at iteration (i-2)

        if f_k > max(f_prev1, f_prev2)
            F(k) = 1;
        elseif f_prev1 < f_prev2 && f_k > min(f_prev1, f_prev2)
            F(k) = 0.4;
        elseif  f_k > min(f_prev1, f_prev2)
            F(k) = 0;
        else
            F(k) = -1;
        end
    end

    % Determine update direction based on sum of F (Eq. (9)-(10))
    if sum(F) < 0
        Vec = (V_prime * (1 - i / (rand() * Max_iter)) / 10)';  % Ensure Vec is a row vector of size 1 x dim
    else
        Vec = (-V_prime * (1 - i / (rand() * Max_iter)) / 10)';  % Ensure Vec is a row vector of size 1 x dim
    end
end