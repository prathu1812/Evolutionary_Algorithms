# -*- coding: utf-8 -*-
"""
Created on Thu Sep  7 03:51:51 2023

@author: msi-1
"""

import numpy as np

def sphere_func(x):
    return np.sum(x**2)

def differential_evolution(pop_size, num_vars, lb, ub, num_generations, F, CR):
    # Initialize population
    population = np.random.uniform(lb, ub, (pop_size, num_vars))
    
    # Main loop
    for gen in range(num_generations):
        # Evaluate fitness
        fitness = np.apply_along_axis(sphere_func, 1, population)
        best_fitness = np.min(fitness)
        
        # Create offspring population
        offspring = np.zeros_like(population)
        for i in range(pop_size):
            # Select three distinct individuals from the population
            idx = np.random.choice(pop_size, 3, replace=False)
            x1, x2, x3 = population[idx]
            
            # Mutation
            v = x1 + F * (x2 - x3)
            
            # Crossover
            mask = np.random.rand(num_vars) < CR
            u = np.where(mask, v, population[i])
            
            # Selection
            if sphere_func(u) <= fitness[i]:
                offspring[i] = u
            else:
                offspring[i] = population[i]
        
        # Update population
        population = offspring
        
        # Display current best fitness
        print(f'Generation {gen}: Best Fitness = {best_fitness}')
    
    # Final evaluation
    final_fitness = np.apply_along_axis(sphere_func, 1, population)
    best_solution = population[np.argmin(final_fitness)]
    best_fitness = np.min(final_fitness)
    print(f'Final Best Fitness = {best_fitness}')
    print('Best Solution:')
    print(best_solution)

# DE Parameters
pop_size = 50
num_vars = 3
lb = -100
ub = 100
num_generations = 1000
F = 0.8  # Scaling factor
CR = 0.9  # Crossover rate

# Run DE algorithm
differential_evolution(pop_size, num_vars, lb, ub, num_generations, F, CR)
