import random
import numpy as np

# Set the parameters
num_employed_bees = 50
num_onlooker_bees = 50
max_iterations = 100
limit = 50
problem_size = 30

# Define the fitness function
def fitness_function(x):
    return np.sum(x**2)

# Initialize the population
food_sources = np.random.rand(num_employed_bees, problem_size) * 100
fitness_values = np.array([fitness_function(food) for food in food_sources])
no_improvement_counters = np.zeros(num_employed_bees)

# Main loop
for iteration in range(max_iterations):
    # Employed bees phase
    for i in range(num_employed_bees):
        # Randomly select a dimension to change
        dimension = random.randint(0, problem_size - 1)
        
        # Generate a new candidate solution (mutant)
        mutant = np.copy(food_sources[i])
        mutant[dimension] += (random.random() - 0.5) * 2  # Modify the selected dimension randomly
        
        # Evaluate the fitness of the mutant
        mutant_fitness = fitness_function(mutant)
        
        # Greedy selection between the current solution and its mutant
        if mutant_fitness < fitness_values[i]:
            food_sources[i] = mutant
            fitness_values[i] = mutant_fitness
            no_improvement_counters[i] = 0
        else:
            no_improvement_counters[i] += 1

    # Calculate the probabilities based on fitness values
    total_fitness = np.sum(fitness_values)
    if total_fitness == 0:
        probabilities = np.ones(num_employed_bees) / num_employed_bees
    else:
        probabilities = (1.0 / (1.0 + fitness_values)) / np.sum(1.0 / (1.0 + fitness_values))

    # Onlooker bees phase
    for j in range(num_onlooker_bees):
        # Select a food source based on roulette wheel selection
        selected_food_source = np.random.choice(num_employed_bees, p=probabilities)
        
        # Randomly select a dimension to change
        dimension = random.randint(0, problem_size - 1)
        
        # Generate a new candidate solution (mutant)
        mutant = np.copy(food_sources[selected_food_source])
        mutant[dimension] += (random.random() - 0.5) * 2  # Modify the selected dimension randomly
        
        # Evaluate the fitness of the mutant
        mutant_fitness = fitness_function(mutant)
        
        # Greedy selection between the selected solution and its mutant
        if mutant_fitness < fitness_values[selected_food_source]:
            food_sources[selected_food_source] = mutant
            fitness_values[selected_food_source] = mutant_fitness
            no_improvement_counters[selected_food_source] = 0
        else:
            no_improvement_counters[selected_food_source] += 1

    # Scout bees phase
    for k in range(num_employed_bees):
        if no_improvement_counters[k] > limit:
            food_sources[k] = np.random.rand(problem_size) * 100
            fitness_values[k] = fitness_function(food_sources[k])
            no_improvement_counters[k] = 0

    # Display the best solution in each iteration
    best_fitness = np.min(fitness_values)
    print(f"Iteration {iteration}, Best Fitness: {best_fitness}")

# Find the overall best solution
overall_best_fitness = np.min(fitness_values)
overall_best_index = np.argmin(fitness_values)
overall_best_solution = food_sources[overall_best_index]
print("--- Optimization Results ---")
print(f"Best Fitness: {overall_best_fitness}")
print(f"Best Solution: {overall_best_solution}")
