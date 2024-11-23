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
% Particle Swarm Optimization
function [gBestScore, gBest, cg_curve] = PSO(N, Max_iteration, lb, ub, dim, fobj)

    % PSO Information
    Vmax = 2;
    noP = N;
    wMax = 0.9;
    wMin = 0.2;
    c1 = 2;
    c2 = 2;

    % Initializations
    iter = Max_iteration;
    vel = zeros(noP, dim);
    pBestScore = inf(noP, 1);
    pBest = zeros(noP, dim);
    gBest = zeros(1, dim);
    cg_curve = zeros(1, iter);
    
    % Initialize search history and fitness history
    search_history = zeros(noP, iter, dim);  % Store positions of particles
    fitness_history = zeros(noP, iter);  % Store fitness values of particles

    % Random initialization for agents
    pos = initialization(noP, dim, ub, lb); 

    % Initialize gBestScore for a minimization problem
    gBestScore = inf;

    for l = 1:iter 
        for i = 1:noP
            % Return back the particles that go beyond the boundaries of the search space
            Flag4ub = pos(i,:) > ub;
            Flag4lb = pos(i,:) < lb;
            pos(i,:) = (pos(i,:) .* (~(Flag4ub + Flag4lb))) + ub .* Flag4ub + lb .* Flag4lb;

            % Calculate objective function for each particle
            fitness = fobj(pos(i,:));
            fitness_history(i, l) = fitness;  % Store fitness value in history
            
            % Update personal best
            if pBestScore(i) > fitness
                pBestScore(i) = fitness;
                pBest(i, :) = pos(i, :);
            end
            
            % Update global best
            if gBestScore > fitness
                gBestScore = fitness;
                gBest = pos(i, :);
            end
            
            % Store the current position in search history
            search_history(i, l, :) = pos(i, :);
        end

        % Update the W of PSO
        w = wMax - l * ((wMax - wMin) / iter);
        
        % Update the Velocity and Position of particles
        for i = 1:noP
            for j = 1:dim       
                vel(i,j) = w * vel(i,j) + c1 * rand() * (pBest(i,j) - pos(i,j)) + c2 * rand() * (gBest(j) - pos(i,j));
                
                % Limit the velocity
                if vel(i,j) > Vmax
                    vel(i,j) = Vmax;
                end
                if vel(i,j) < -Vmax
                    vel(i,j) = -Vmax;
                end            
                pos(i,j) = pos(i,j) + vel(i,j);
            end
        end
        cg_curve(l) = gBestScore;
    end
end
