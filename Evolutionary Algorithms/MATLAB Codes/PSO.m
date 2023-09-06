clc;
clear all;

% PSO Parameters
pop_size = 50;
num_vars = 30;
lb = -100;
ub = 100;
num_generations = 1000;
w = 0.5;  % Inertia weight
c1 = 2;  % Cognitive coefficient
c2 = 2;  % Social coefficient

% Initialize population, velocity, personal best, and global best
population = lb + (ub - lb) * rand(pop_size, num_vars);
velocity = zeros(pop_size, num_vars);
pbest = population;
pbest_value = inf * ones(pop_size, 1);
for i = 1:pop_size
    pbest_value(i) = sphere_func(population(i, :));
end
[gbest_value, gbest_index] = min(pbest_value);
gbest = population(gbest_index, :);

% Main loop
for gen = 1:num_generations
    for i = 1:pop_size
        % Update velocity
        velocity(i, :) = w * velocity(i, :) + ...
                         c1 * rand(1, num_vars) .* (pbest(i, :) - population(i, :)) + ...
                         c2 * rand(1, num_vars) .* (gbest - population(i, :));
        
        % Update position
        population(i, :) = population(i, :) + velocity(i, :);
        
        % Boundary check
        population(i, :) = max(population(i, :), lb);
        population(i, :) = min(population(i, :), ub);
        
        % Update personal best
        current_value = sphere_func(population(i, :));
        if current_value < pbest_value(i)
            pbest(i, :) = population(i, :);
            pbest_value(i) = current_value;
        end
    end
    
    % Update global best
    [current_gbest_value, current_gbest_index] = min(pbest_value);
    if current_gbest_value < gbest_value
        gbest = pbest(current_gbest_index, :);
        gbest_value = current_gbest_value;
    end
    
    % Display current best value
    fprintf('Generation %d: Best Value = %f\n', gen, gbest_value);
end

% Final evaluation
fprintf('Final Best Value = %f\n', gbest_value);
disp('Best Solution:');
disp(gbest);
