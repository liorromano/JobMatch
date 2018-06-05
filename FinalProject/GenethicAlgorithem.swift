import UIKit
import Foundation

var BEST_SOLUTION = Individual()

let DNA_LENGTH = 6

let TOURNAMENT_SIZE = 5
let MAX_GENERATIONS_COUNT = 100

var POPULATION_SIZE = 100
let MUTATION_CHANCE = 0.01
let SAVE_FITTEST = true

var employeeList = [Employee]()
var jobList = [Job]()

struct Individual: CustomStringConvertible {
    var data:[Employee?]?
    var fitness = 0
    
    /*mutating func randomize() {
        for index in 0...DNA_LENGTH-1 {
            data[index] = AVAILABLE_GENES[Int(arc4random_uniform(UInt32(AVAILABLE_GENES.count)))]
        }
    }*/
    
    mutating func createRandomIndividual()
    {
        var copyEmployeeList:[Employee?]
        copyEmployeeList = employeeList
        data = [Employee?]()
        for index in 0...jobList.count-1
        {
            let randNum = Int(arc4random_uniform(UInt32(employeeList.count)))

            if let employee = copyEmployeeList[randNum]{
                data?.append(employee)
            }
            else{
                data?.append(nil)
            }
            copyEmployeeList[randNum] = nil
        }
    }
    
    
    //Fitnes value should range in 0 to Int max, where 0 is solution equal to OPTIMAL
    mutating func calculateFitness() { //can use reduce
        for index in 0...jobList.count-1 {
            if let answer = data?[index]{
                self.fitness += Model.instance.FitEmployee(job: jobList[index], employee: (data?[index])!)
            }
            else{
                self.fitness += 10000
            }
           
        }
    }
    
    func cross(_ otherIndividual: Individual) -> Individual {
        var individual = Individual()
        
        //DIFFERENT METHODS ARE AVAILABLE:
        //single cross, multi cross, uniform cross (we are using single cross)
        individual.data = [Employee?]()
        let crossIndex = Int(arc4random_uniform(UInt32(jobList.count)))
        for i in 0..<crossIndex {
            if let answer = self.data?[i]{
                individual.data?.append((self.data?[i])!)
            }
            else{
                individual.data?.append(nil)
            }

        }
        for i in crossIndex...jobList.count-1 {
            if let answer = otherIndividual.data?[i]{
                individual.data?.append((otherIndividual.data?[i])!)
            }
            else{
                individual.data?.append(nil)
            }

        }
        
        return individual
    }
    
    mutating func mutate() {
        for index in 0...jobList.count-1 {
            if Double(Float(arc4random()) / Float(UINT32_MAX)) <= MUTATION_CHANCE {
                self.data?[index] = employeeList[Int(arc4random_uniform(UInt32(employeeList.count)))]
            }
        }
    }
    
    var description : String {
        return "\(self.data) Fitness: \(self.fitness)"
    }
}

//FRAMEWORK
struct Population {
    var individuals = [Individual]()
    var fittestIndividual: Individual?
    
    mutating func calculateFittestIndividual() {
        fittestIndividual =  individuals.sorted(by: { (first, second) -> Bool in
            first.fitness < second.fitness
        }).first!
    }
}

class GenthicAlgorithem{
    
    
    func runGeneticAlgorithm(jobs:[Job],employees:[Employee],callback:@escaping ([Employee?])->Void) {
        
        jobList = jobs
        employeeList = employees
        
        /*//Create Initial Population
        var population = createInitialPopulation()
        population.calculateFittestIndividual()*/
        
        for generation in 1...MAX_GENERATIONS_COUNT {
           

            //Create Initial Population
            var population = createInitialPopulation()
            population.calculateFittestIndividual()
            
            var newPopulation = Population()
            if SAVE_FITTEST {
                for index in 0...(POPULATION_SIZE/2)-1
                {
                    //newPopulation.individuals.append(population.fittestIndividual!)
                    newPopulation.individuals.append(population.individuals[index])
                }
            }
            
            for _ in newPopulation.individuals.count...POPULATION_SIZE-1 {
                
                //TOURNAMENT METHOD (other is roulette wheel)
                let individual1 = selectParentTournament(population)
                let individual2 = selectParentTournament(population)
                
                var childrenIndividual = individual1.cross(individual2)
                childrenIndividual.mutate()
                childrenIndividual.calculateFitness()
                newPopulation.individuals.append(childrenIndividual)
            }
            
            population = newPopulation
            population.calculateFittestIndividual()
            if population.fittestIndividual!.fitness == 0 {
                print("!!! Generation:\(generation) Fittest:\(population.fittestIndividual!)")
                BEST_SOLUTION = population.fittestIndividual!
                break
            }
            else
            {
                if(generation == 1)
                {
                    BEST_SOLUTION = population.fittestIndividual!
                }
                else
                {
                    if(population.fittestIndividual!.fitness < BEST_SOLUTION.fitness)
                    {
                        BEST_SOLUTION = population.fittestIndividual!
                    }
                }

             print("Generation:\(generation) Fittest:\(population.fittestIndividual!)")
            }
           
        }
        callback(BEST_SOLUTION.data!)
    }
    
    func selectParentTournament(_ population:Population) -> Individual{
        var tournamentPopulation = Population()
        for _ in 1...TOURNAMENT_SIZE {
            tournamentPopulation.individuals.append(population.individuals[Int(arc4random_uniform(UInt32(population.individuals.count)))])
        }
        tournamentPopulation.calculateFittestIndividual()
        return tournamentPopulation.fittestIndividual!
    }
    
    func createInitialPopulation() -> Population{
        var population = Population()
        for index in 0...POPULATION_SIZE-1
        {
            var individual = Individual()
            individual.createRandomIndividual()
            individual.calculateFitness()
            population.individuals.append(individual)
        }
        return population
    }
    
    func getSolution()->[Employee?]
    {
        return BEST_SOLUTION.data!
    }
}
