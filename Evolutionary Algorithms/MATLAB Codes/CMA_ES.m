function [BestCost,best]=CMA_ES(fhd,D,N,MaxIt,lx,ux,func_num)


global initial_flag
initial_flag=0;

%% Problem Settings
VarSize=[1 D];       % Decision Variables Matrix Size
optimum = func_num * 100.0;
max_nfes= 10000*D;
nfes=0;

%% CMA-ES Settings
% Number of Parents
mu=round(N/2);

% Parent Weights
w=log(mu+0.5)-log(1:mu);
w=w/sum(w);

% Number of Effective Solutions
mu_eff=1/sum(w.^2);

% Step Size Control Parameters (c_sigma and d_sigma);
sigma0=0.3*(ux-lx);
cs=(mu_eff+2)/(D+mu_eff+5);
ds=1+cs+2*max(sqrt((mu_eff-1)/(D+1))-1,0);
ENN=sqrt(D)*(1-1/(4*D)+1/(21*D^2));

% Covariance Update Parameters
cc=(4+mu_eff/D)/(4+D+2*mu_eff/D);
c1=2/((D+1.3)^2+mu_eff);
alpha_mu=2;
cmu=min(1-c1,alpha_mu*(mu_eff-2+1/mu_eff)/((D+2)^2+alpha_mu*mu_eff/2));
hth=(1.4+2/(D+1))*ENN;

%% Initialization

ps=cell(MaxIt,1);
pc=cell(MaxIt,1);
C=cell(MaxIt,1);
sigma=cell(MaxIt,1);

ps{1}=zeros(VarSize);
pc{1}=zeros(VarSize);
C{1}=eye(D);
sigma{1}=sigma0;

empty_individual.Position=[];
empty_individual.Step=[];
empty_individual.Cost=[];

M=repmat(empty_individual,MaxIt,1);
M(1).Position=unifrnd(lx,ux,VarSize);
M(1).Step=zeros(VarSize);
M(1).Cost= feval(fhd, M(1).Position', func_num);   %benchmark_func(M(1).Position,func_num);
BestSol=M(1);

BestCost=zeros(MaxIt,1);

%% CMA-ES Main Loop
for g=1:MaxIt
    
    % Generate Samples
    pop=repmat(empty_individual,N,1);
    for i=1:N
        pop(i).Step=mvnrnd(zeros(VarSize),C{g});
        pop(i).Position= M(g).Position+sigma{g}.*pop(i).Step;
        pop(i).Cost= feval(fhd, pop(i).Position', func_num);   %benchmark_func(pop(i).Position,func_num);
        
        % Update Best Solution Ever Found
        if pop(i).Cost<BestSol.Cost
            BestSol=pop(i);
        end
        nfes = nfes+1;
    end
    if nfes > max_nfes
        break
    end
    
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
  
    % Save Results
    BestCost(g)=BestSol.Cost;
    
    % Exit At Last Iteration
    if g==MaxIt
        break;
    end
        
    % Update Mean
    M(g+1).Step=0;
    for j=1:mu
        M(g+1).Step=M(g+1).Step+w(j)*pop(j).Step;
    end
    M(g+1).Position=M(g).Position+sigma{g}.*M(g+1).Step;
    M(g+1).Cost= feval(fhd,M(g+1).Position',func_num);  %benchmark_func(M(g+1).Position,func_num);
    if M(g+1).Cost<BestSol.Cost
        BestSol=M(g+1);
    end
    
    % Update Step Size
    ps{g+1}=(1-cs)*ps{g}+sqrt(cs*(2-cs)*mu_eff)*M(g+1).Step/chol(C{g})';
    sigma{g+1}=sigma{g}*exp(cs/ds*(norm(ps{g+1})/ENN-1))^0.3;
    
    % Update Covariance Matrix
    if norm(ps{g+1})/sqrt(1-(1-cs)^(2*(g+1)))<hth
        hs=1;
    else
        hs=0;
    end
    delta=(1-hs)*cc*(2-cc);
    pc{g+1}=(1-cc)*pc{g}+hs*sqrt(cc*(2-cc)*mu_eff)*M(g+1).Step;
    C{g+1}=(1-c1-cmu)*C{g}+c1*(pc{g+1}'*pc{g+1}+delta*C{g});
    for j=1:mu
        C{g+1}=C{g+1}+cmu*w(j)*pop(j).Step'*pop(j).Step;
    end
    
    % If Covariance Matrix is not Positive Defenite or Near Singular
    [V, E]=eig(C{g+1});
    if any(diag(E)<0)
        E=max(E,0);
        C{g+1}=V*E/V;
    end
    bsf_error_val = BestSol.Cost - optimum;
    fprintf('%d nfes, best-so-far error value = %1.8e\n',  nfes,bsf_error_val)
end
bestx=BestSol.Position; %×îÓÅÖµ
best=BestSol.Cost;
end