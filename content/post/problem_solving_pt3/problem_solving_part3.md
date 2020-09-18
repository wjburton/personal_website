---
title: "Problem Solving: Part 2"
date: 2020-06-27T13:18:13-07:00
draft: False
---

In continuing the problem solving series I want to spend some time with george polya's problem solving method but focus on an actual data science problem.

I came across the following problem at work, and will try to frame it using the classic titanic dataset:

Imagine you time-traveled to back in time to 1912, to right before the Titanic was boarding. Your goal was to try to save as many lives as possible. You couldn't convince the captain to stop the trip, but you had the opportunity to convince them that a certain population of passengers shouldn't be able to board do to "high risk of disease" (Or some other excuse). The captain is not willing to remove more than a certain % of passengers, say 20%, but that is variable.

Luckily you have the titanic dataset and a laptop handy. Here is your task:  
**Objective**  

* Either save as many lives as possible under a population size constraint, or minimize the population reduced given a % lives saved constraint. For example, Save as many lives as possible while removing only 20% of the population. OR Save 50% of the lives and minimize the % of the population you have to remove.
* Have an easily explainable set of rules that you can tell the captain. If your rules don't make sense to the captain then they will not stop anyone from boarding. 

**Solution Parameters**  

The first two parameters can not be constrained at the same time. When you run your solution you can only provide an input for one of them. This is because if you were to say I want to remove 20% of deaths and remove 10% of the population then there may be no solution.

1. The population size (as a %) you are allowed to remove (maybe the captain is feeling more or less strict that day)
2. The % of lives you want to save (ex. if 100 people died and you need to save 20, then the parameter here is 20%) It should be noted that the solution is not expected to save the exact % of lives saved, but the solution should save atleast that amount of passengers.
3. The max depth of a hardcut combination. Ex. depth 1. people in third class AND depth 2. who boarded from city C AND depth 3. under the age of 20. That hardcut combination example has a depth of 3.
4. The number of hardcut combinations allowed (The example in parameter 3.is a single hardcut combination)
5. Specific variables you want to limit the rules to include (While the rules created may not be optimal, the variables you call out may be more explainable).


**Bonus Parameter**  
6. Provide a removal ratio and have the solution be unconstrained for both population size lost and lives saved. A removal ratio is the ratio between lives saved and population lost. For example, if you remove 40% of lives but have to cut out 20% of the population then your ratio = 2:1 or 2.

**Solution Example**  
The captain allowed you to remove up to 20% of the passengers.  

You came up with 3 rules: 

1. People in third class AND who boarded from city C AND under the age of 20.  
2. People over the age of 60   
3. People from city A AND are first class passengers  

These rules saved 40% of lives and cut out 20% of the population for a removal ratio of 2:1

**The solution must be able to re-run given different parameter inputs and come up with a new rule set**
Claude shannon problem solving - see if you can find some resources.
