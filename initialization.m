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
function Positions=initialization(SearchAgents_no,dim,ub,lb)

Boundary_no= size(ub,2); % numnber of boundaries

% If the boundaries of all variables are equal and user enter a signle
% number for both ub and lb
if Boundary_no==1
    Positions=rand(SearchAgents_no,dim).*(ub-lb)+lb;
end

% If each variable has a different lb and ub
if Boundary_no>1
    for i=1:dim
        ub_i=ub(i);
        lb_i=lb(i);
        Positions(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;
    end
end
