# -*- coding: utf-8 -*-
"""
Created on Thu Sep  7 03:52:58 2023

@author: msi-1
"""

import random

# Genetic Algorithm parameters
POPULATION_SIZE = 100
GENERATION_COUNT = 50
CROSSOVER_RATE = 0.8
MUTATION_RATE = 0.1
CHROMOSOME_LENGTH = 4
LOWER_BOUND = -5.12
UPPER_BOUND = 5.12

# Generate a random chromosome
def generate_chromosome():
    return [random.randint(0, 1) for _ in range(CHROMOSOME_LENGTH)]

# Evaluate the fitness of an individual
def evaluate_fitness(chromosome):
    x = decode_chromosome(chromosome)
    #Here you can change the objective function value 
    fitness_value = sum([gene**2 for gene in x])
    return fitness_value

# Decode binary chromosome to real-valued representation
def decode_chromosome(chromosome):
    x = []
    for gene in chromosome:
        value = LOWER_BOUND + (UPPER_BOUND - LOWER_BOUND) * int("".join(map(str, chromosome)), 2) / (2 ** CHROMOSOME_LENGTH - 1)
        x.append(value)
    return x

# Perform selection using tournament selection
def selection(population):
    tournament_size = 5
    selected_parents = []
    for _ in range(len(population)):
        tournament = random.sample(population, tournament_size)
        winner = min(tournament, key=lambda x: x[1])
        selected_parents.append(winner[0])
    return selected_parents

# Perform crossover between two parents
def crossover(parent1, parent2):
    if random.random() < CROSSOVER_RATE:
        crossover_point = random.randint(1, CHROMOSOME_LENGTH - 1)
        child1 = parent1[:crossover_point] + parent2[crossover_point:]
        child2 = parent2[:crossover_point] + parent1[crossover_point:]
        return child1, child2
    else:
        return parent1, parent2

# Perform mutation on an individual
def mutate(individual):
    mutated_individual = individual.copy()
    for i in range(CHROMOSOME_LENGTH):
        if random.random() < MUTATION_RATE:
            mutated_individual[i] = 1 - mutated_individual[i]
    return mutated_individual

# Generate an initial population
population = [(generate_chromosome(), 0) for _ in range(POPULATION_SIZE)]

# Genetic Algorithm main loop
for _ in range(GENERATION_COUNT):
    # Evaluate fitness of each individual in the population
    population = [(chromosome, evaluate_fitness(chromosome)) for chromosome, _ in population]

    # Select parents for reproduction
    parents = selection(population)

    # Create offspring through crossover and mutation
    offspring = []
    for i in range(0, POPULATION_SIZE, 2):
        parent1 = parents[i]
        parent2 = parents[i + 1]
        child1, child2 = crossover(parent1, parent2)
        child1 = mutate(child1)
        child2 = mutate(child2)
        offspring.extend([child1, child2])

    # Replace the old population with the offspring
    population = [(chromosome, 0) for chromosome in offspring]

# Get the best individual as the solution
best_individual = min(population, key=lambda x: x[1])[0]
decoded_solution = decode_chromosome(best_individual)
fitness_value = evaluate_fitness(best_individual)
# Print the solution
print("Best Solution:", decoded_solution)
print("Best Fitness:", fitness_value)

