# -*- coding: utf-8 -*-
"""
Created on Thu Sep  7 03:37:05 2023

@author: msi-1
"""

import numpy as np

# PSO Parameters
numParticles = 50  # Number of particles in the swarm
maxIterations = 100  # Maximum number of iterations
c1 = 2  # Cognitive coefficient
c2 = 2  # Social coefficient
w = 0.7  # Inertia weight

# Problem-specific parameters
Dim = 2  # Dimensionality of the problem
# Define your problem here, including the objective function and any constraints


# Define the PSO function
def pso():
    # Initialize the swarm
    position = np.random.rand(numParticles, Dim)  # Particle positions
    velocity = np.zeros((numParticles, Dim))  # Particle velocities
    personalBest = position.copy()  # Personal best positions
    personalBestFitness = np.zeros(numParticles) + np.inf  # Personal best fitness values
    globalBest = np.zeros(Dim)  # Global best position
    globalBestFitness = np.inf  # Global best fitness value

    # Main loop
    for iteration in range(maxIterations):
        # Evaluate fitness for each particle
        for i in range(numParticles):
            fitness = objective_function(position[i])

            # Update personal best if better fitness is found
            if fitness < personalBestFitness[i]:
                personalBest[i] = position[i]
                personalBestFitness[i] = fitness

            # Update global best if better fitness is found
            if fitness < globalBestFitness:
                globalBest = position[i]
                globalBestFitness = fitness

        # Update particle velocities and positions
        for i in range(numParticles):
            r1 = np.random.rand(Dim)
            r2 = np.random.rand(Dim)
            velocity[i] = w * velocity[i] \
                          + c1 * r1 * (personalBest[i] - position[i]) \
                          + c2 * r2 * (globalBest - position[i])
            position[i] = position[i] + velocity[i]

            # Apply any necessary constraints to the particle positions

            # Update fitness if necessary

            # Display current best fitness
            print(f'Iteration {iteration + 1}: Best Fitness = {globalBestFitness}')

    # Display final result
    print('Optimization Complete!')
    print(f'Best Fitness = {globalBestFitness}')
    print(f'Best Position = {globalBest}')


# Define your objective function
def objective_function(x):
    # Define your objective function here
    return np.sum(x**2)
    


# Run the PSO algorithm
pso()
