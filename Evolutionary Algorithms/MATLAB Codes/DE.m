clc;
clear all;

% Differential Evolution Parameters
pop_size = 50;
num_vars = 30;
lb = -100;
ub = 100;
num_generations = 1000;
F = 0.5;  % Differential weight
CR = 0.7;  % Crossover probability

% Initialize population
population = lb + (ub - lb) * rand(pop_size, num_vars);
trial_population = zeros(pop_size, num_vars);

% Evaluate initial population
fitness = zeros(pop_size, 1);
for i = 1:pop_size
    fitness(i) = sphere_func(population(i, :));
end

% Main loop
for gen = 1:num_generations
    
    for i = 1:pop_size
        % Mutation
        indices = setdiff(1:pop_size, i);  % Exclude the current index
        selected_indices = randsample(indices, 3);  % Randomly select three distinct indices
        
        a = population(selected_indices(1), :);
        b = population(selected_indices(2), :);
        c = population(selected_indices(3), :);
        
        mutant_vector = a + F * (b - c);
        
        % Crossover
        j_rand = randi([1, num_vars]);
        for j = 1:num_vars
            if rand() <= CR || j == j_rand
                trial_population(i, j) = mutant_vector(j);
            else
                trial_population(i, j) = population(i, j);
            end
        end
    end
    
    % Selection
    for i = 1:pop_size
        trial_fitness = sphere_func(trial_population(i, :));
        if trial_fitness < fitness(i)
            population(i, :) = trial_population(i, :);
            fitness(i) = trial_fitness;
        end
    end
    
    % Display current best fitness
    best_fitness = min(fitness);
    fprintf('Generation %d: Best Fitness = %f\n', gen, best_fitness);
end

% Final evaluation
best_solution = population(fitness == min(fitness), :);
fprintf('Final Best Fitness = %f\n', best_fitness);
disp('Best Solution:');
disp(best_solution);
