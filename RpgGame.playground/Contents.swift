class Unit {
    let name: String
    let damage, agility, defence: Int
    var health: Int
    
    init(name: String, damage: Int, agility: Int, defence: Int, health: Int) {
        self.name = name
        self.damage = damage
        self.agility = agility
        self.defence = defence
        self.health = health
    }
    
    func Attack(on unit: Unit) {
        preconditionFailure("This method must be overridden")
    }
}

extension Unit: Equatable{
    static func == (lhs: Unit, rhs: Unit) -> Bool {
            return
                lhs.damage == rhs.damage &&
                lhs.agility == rhs.agility &&
                lhs.defence == rhs.defence &&
                lhs.name == rhs.name
        }
}

class Mage : Unit {
    let intelegince: Int
    
    init(intelegince: Int, name: String, damage: Int, agility: Int, defence: Int, health: Int) {
        self.intelegince = intelegince
        super.init(name: name, damage: damage, agility: agility, defence: defence, health: health)
    }
    
    override func Attack(on unit: Unit) {
        unit.health = unit.health * unit.defence - self.intelegince * self.agility * self.damage
    }
}

class Assasin : Unit {
    let stealth: Int
    
    init(stealth: Int, name: String, damage: Int, agility: Int, defence: Int, health: Int) {
        self.stealth = stealth
        super.init(name: name, damage: damage, agility: agility, defence: defence, health: health)
    }
    
    override func Attack(on unit: Unit) {
        unit.health = unit.health * unit.defence - self.stealth * self.agility * self.damage
    }
}

class Knight : Unit {
    let strength: Int
    
    init(strength: Int, name: String, damage: Int, agility: Int, defence: Int, health: Int) {
        self.strength = strength
        super.init(name: name, damage: damage, agility: agility, defence: defence, health: health)
    }
    
    override func Attack(on unit: Unit) {
        unit.health = unit.health * unit.defence - self.strength * self.agility * self.damage
    }
}


class UnitFactory {
    static func makeUnit() -> Unit? {
        switch Int.random(in: 1...3) {
        case 1:
            let possibleNames = ["Yennefer of Vengerberg", "Triss Merigold", "Gendalf the White", "Jaine Praudmur", "Darth Vader"]
            let possibleHealth = [3000, 4000, 5000, 6000, 4500]
            let possibleDefence = [5, 6, 7, 8, 9]
            let possibleDamage = [50, 60, 70, 80, 90]
            let possibleAgility = [3, 4, 5, 6, 7]
            let possibleIntelegince = [500, 600, 700, 800, 900]
            
            return Mage(intelegince: possibleIntelegince.randomElement()!, name: possibleNames.randomElement()!, damage: possibleDamage.randomElement()!, agility: possibleAgility.randomElement()!, defence: possibleDefence.randomElement()!, health: possibleHealth.randomElement()!)
            
        case 2:
            
            let possibleNames = ["Altair", "Riki", "Ezio Auditore", "Prince of Persia", "Darth Maul"]
            let possibleHealth = [2000, 3000, 4000, 5000, 3500]
            let possibleDefence = [5, 6, 7, 8, 9]
            let possibleDamage = [50, 60, 70, 80, 90]
            let possibleAgility = [3, 4, 5, 6, 7]
            let possibleStealth = [550, 650, 750, 850, 950]
            
            return Assasin(stealth: possibleStealth.randomElement()!, name: possibleNames.randomElement()!, damage: possibleDamage.randomElement()!, agility: possibleAgility.randomElement()!, defence: possibleDefence.randomElement()!, health: possibleHealth.randomElement()!)
            
        case 3:
            let possibleNames = ["Obi van Kenobi", "Geralt of Rivia", "Warior Rin", "King Arthur", "Reinhard"]
            let possibleHealth = [4000, 5000, 6000, 7000, 8500]
            let possibleDefence = [5, 6, 7, 8, 9]
            let possibleDamage = [50, 60, 70, 80, 90]
            let possibleAgility = [3, 4, 5, 6, 7]
            let possibleStrength = [350, 400, 600, 500, 800]
            
            return Knight(strength: possibleStrength.randomElement()!, name: possibleNames.randomElement()!, damage: possibleDamage.randomElement()!, agility: possibleAgility.randomElement()!, defence: possibleDefence.randomElement()!, health: possibleHealth.randomElement()!)
            
        default:
            return nil
        }
    }
}

enum Errors: Error {
    case createUnitError(String)
    case deletingUnitError(String)
}

class Battlefield {
    func BeginBattle(amountOfUnits: Int) throws -> Unit? {
        var units:[Unit] = [Unit]()
        
        while units.count != amountOfUnits {
            guard let unit = UnitFactory.makeUnit() else {
                throw Errors.createUnitError("Instead of unit returned nil")
            }
            units.append(unit)
        }
       
        print(units)
        while units.count != 1 {
            let attacker = units.randomElement()
            let defender = units.randomElement()
        
            if attacker == defender {continue}
            
            print(attacker!.name ," бьет по ", defender!.name)
            attacker?.Attack(on: defender!)
            if defender!.health <= 0 {
                guard let index = units.firstIndex(of: defender!) else {
                    throw Errors.deletingUnitError("Units does not contain sought unit")
                }
                print(defender!.name, "выбывает")
                units.remove(at: index)
                print("в бою осталось", units.count)
            }
        }
        return units[0]
    }
}

let amountOfUnits = 15
let battlefield = Battlefield()
let winner = try battlefield.BeginBattle(amountOfUnits: amountOfUnits)

print(winner!.name, "ПОБЕДИТЕЛЬ!")

