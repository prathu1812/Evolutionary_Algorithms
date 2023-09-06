clc;
clear all;

% Genetic Algorithm Parameters
pop_size = 50;
num_vars = 30;
lb = -100;
ub = 100;
num_generations = 1000;
mutation_rate = 0.1;
crossover_rate = 0.7;

% Initialize population
population = lb + (ub - lb) * rand(pop_size, num_vars);

% Main loop
for gen = 1:num_generations
    
    % Evaluate fitness for each individual in the population
    fitness = zeros(pop_size, 1);
    for i = 1:pop_size
        fitness(i) = sphere_func(population(i, :));
    end
    best_fitness = min(fitness);
    
    % Selection
    tournament_size = 2;
    tournament_winners = zeros(pop_size, num_vars);
    for i = 1:pop_size
        tournament_inds = randperm(pop_size, tournament_size);
        tournament_fitness = fitness(tournament_inds);
        [~, best_ind] = min(tournament_fitness);
        tournament_winners(i, :) = population(tournament_inds(best_ind), :);
    end
    
    % Crossover
    crossover_inds = rand(pop_size, num_vars) < crossover_rate;
    offspring = zeros(pop_size, num_vars);
    for i = 1:pop_size
        parent1 = tournament_winners(i, :);
        if i == pop_size
            parent2 = tournament_winners(1, :);
        else
            parent2 = tournament_winners(i+1, :);
        end
        offspring(i, crossover_inds(i,:)) = parent1(crossover_inds(i,:));
        offspring(i, ~crossover_inds(i,:)) = parent2(~crossover_inds(i,:));
    end
    
    % Mutation
    mutation_inds = rand(pop_size, num_vars) < mutation_rate;
    mutation_amounts = lb + (ub - lb) * rand(pop_size, num_vars);
    offspring(mutation_inds) = mutation_amounts(mutation_inds);
    
    % Update population
    population = offspring;
    
    % Display current best fitness
    fprintf('Generation %d: Best Fitness = %f\n', gen, best_fitness);
end

% Final evaluation
final_fitness = zeros(pop_size, 1);
for i = 1:pop_size
    final_fitness(i) = sphere_func(population(i, :));
end
best_solution = population(final_fitness == min(final_fitness), :);
best_fitness = min(final_fitness);
fprintf('Final Best Fitness = %f\n', best_fitness);
disp('Best Solution:');
disp(best_solution);
