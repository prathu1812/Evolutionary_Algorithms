clc;
clear all;

% ABC Parameters
pop_size = 50;  % Total population (employed + onlookers)
num_vars = 30;
lb = -100;
ub = 100;
num_generations = 1000;
limit = 50;  % Limit for abandoning a food source

% Initialize population and fitness values
population = lb + (ub - lb) * rand(pop_size, num_vars);
fitness_values = zeros(pop_size, 1);
for i = 1:pop_size
    fitness_values(i) = sphere_func(population(i, :));
end

trial = zeros(pop_size, 1);  % Counter for tracking the number of trials for each food source

% Main loop
for gen = 1:num_generations
    % Employed Bees Phase
    for i = 1:pop_size
        % Produce a mutant solution for bee i
        k = i;
        while k == i
            k = randi([1, pop_size]);
        end
        j = randi([1, num_vars]);
        mutant = population(i, :);
        mutant(j) = mutant(j) + (mutant(j) - population(k, j)) * (rand() - 0.5) * 2;
        
        % Boundary check
        mutant(j) = max(mutant(j), lb);
        mutant(j) = min(mutant(j), ub);
        
        % Evaluate fitness
        mutant_fitness = sphere_func(mutant);
        
        % Greedy selection
        if mutant_fitness < fitness_values(i)
            population(i, :) = mutant;
            fitness_values(i) = mutant_fitness;
            trial(i) = 0;
        else
            trial(i) = trial(i) + 1;
        end
    end
    
    % Calculate probability values for selection
    prob = (0.9 * (fitness_values - min(fitness_values)) / (max(fitness_values) - min(fitness_values))) + 0.1;
    
    % Onlooker Bees Phase
    i = 1;
    t = 0;
    while t < pop_size
        if rand() < prob(i)
            t = t + 1;
            
            % Produce a mutant solution for bee i
            k = i;
            while k == i
                k = randi([1, pop_size]);
            end
            j = randi([1, num_vars]);
            mutant = population(i, :);
            mutant(j) = mutant(j) + (mutant(j) - population(k, j)) * (rand() - 0.5) * 2;
            
            % Boundary check
            mutant(j) = max(mutant(j), lb);
            mutant(j) = min(mutant(j), ub);
            
            % Evaluate fitness
            mutant_fitness = sphere_func(mutant);
            
            % Greedy selection
            if mutant_fitness < fitness_values(i)
                population(i, :) = mutant;
                fitness_values(i) = mutant_fitness;
                trial(i) = 0;
            else
                trial(i) = trial(i) + 1;
            end
        end
        i = i + 1;
        if i == pop_size + 1
            i = 1;
        end
    end
    
    % Scout Bees Phase
    for i = 1:pop_size
        if trial(i) > limit
            population(i, :) = lb + (ub - lb) * rand(1, num_vars);
            fitness_values(i) = sphere_func(population(i, :));
            trial(i) = 0;
        end
    end
    
    % Display current best value
    best_value = min(fitness_values);
    fprintf('Generation %d: Best Value = %f\n', gen, best_value);
end

% Final evaluation
[best_value, best_index] = min(fitness_values);
best_solution = population(best_index, :);
fprintf('Final Best Value = %f\n', best_value);
disp('Best Solution:');
disp(best_solution);
