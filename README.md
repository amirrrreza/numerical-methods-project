# Balanced Question Assignment Optimization

## About the Project

In this project, I worked on a question assignment problem where questions with different difficulty levels need to be distributed among students.

The main goal was to create a balanced assignment so that the total workload of students is as similar as possible.

I started with a simple greedy algorithm and then explored more advanced optimization approaches to compare their performance.

---

## Problem Description

The problem can be described as follows:

- We have a number of questions.
- Each question has a difficulty level (1–4 stars).
- We need to assign these questions to a number of students.

Each question should be assigned to only one student, while trying to avoid giving too much workload to one student.

The objective is to minimize the maximum total difficulty assigned to a student.

---

## Approaches

### 1. Greedy Approach

The first solution was implemented using a greedy algorithm.

At each step, the question was assigned to the student who had the lowest current workload.

This approach is simple and fast, but it does not always provide the best possible solution.

---

### 2. MILP Optimization Approach

After implementing the greedy method, I formulated the problem as a Mixed Integer Linear Programming (MILP) model.

The model was implemented in Julia using:

- JuMP
- HiGHS solver

This approach finds the optimal assignment by minimizing the maximum workload among students.

---

### 3. Custom Algorithm

As the next step, I developed an algorithm without using external optimization solvers.

The purpose was to understand the optimization process more deeply and compare the results with the greedy and MILP approaches.

---

## Implementation

The project was developed using Julia.

Main concepts used:

- Greedy algorithms
- Optimization modeling
- Integer programming
- Algorithm design
- Computational problem solving

---

## Example

Input:
Question difficulties:
[3, 3, 2, 2, 2]

Number of students:
2

Example result:
Student 1:
Questions: 1, 4
Total difficulty: 5

Student 2:
Questions: 2, 3, 5
Total difficulty: 7

Maximum workload: 7

---

## Comparison

Different approaches were implemented and compared:

- Greedy algorithm: faster but may not find the optimal solution.
- MILP approach: slower for large problems but guarantees the optimal solution.
- Custom algorithm: developed to explore alternative optimization strategies.

---

## How to Run

Install the required packages:

```julia
using Pkg
Pkg.add("JuMP")
Pkg.add("HiGHS")

Run the project

