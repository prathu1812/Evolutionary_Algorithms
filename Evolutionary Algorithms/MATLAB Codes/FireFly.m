clc;
clear all;

% Firefly Algorithm Parameters
pop_size = 50;
num_vars = 30;
lb = -100;
ub = 100;
num_generations = 1000;
alpha = 0.2;  % Randomness factor
beta0 = 1;  % Attractiveness at r = 0
gamma = 0.5;  % Light absorption coefficient

% Initialize population and light intensity
population = lb + (ub - lb) * rand(pop_size, num_vars);
intensity = zeros(pop_size, 1);
for i = 1:pop_size
    intensity(i) = sphere_func(population(i, :));
end

% Main loop
for gen = 1:num_generations
    for i = 1:pop_size
        for j = 1:pop_size
            if intensity(i) > intensity(j)  % Firefly i is attracted to brighter (lower fitness) firefly j
                % Calculate distance between fireflies i and j
                r = norm(population(i, :) - population(j, :));
                
                % Attractiveness
                beta = beta0 * exp(-gamma * r^2);
                
                % Update firefly i towards j
                new_position = population(i, :) + ...
                               beta * (population(j, :) - population(i, :)) + ...
                               alpha * (rand(1, num_vars) - 0.5);
                
                % Ensure boundaries
                new_position = max(new_position, lb);
                new_position = min(new_position, ub);
                
                % Update intensity for the new position
                new_intensity = sphere_func(new_position);
                
                % Greedy selection
                if new_intensity < intensity(i)
                    population(i, :) = new_position;
                    intensity(i) = new_intensity;
                end
            end
        end
    end
    
    % Display current best intensity
    best_intensity = min(intensity);
    fprintf('Generation %d: Best Intensity = %f\n', gen, best_intensity);
end

% Final evaluation
best_solution = population(intensity == min(intensity), :);
fprintf('Final Best Intensity = %f\n', best_intensity);
disp('Best Solution:');
disp(best_solution);
