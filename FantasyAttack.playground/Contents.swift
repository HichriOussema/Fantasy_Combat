import Foundation

class Character {
    let name: String
    let attackBasePoints: Int
    let defense: Int
    let speed: Int
    var life: Int
    let luck: Int
    
    var description: String {
            return "Name: \(name), Attack: \(attackBasePoints), Defense: \(defense), Speed: \(speed), Life: \(life), Luck: \(luck)"
        }

    init(name: String, attackBasePoints: Int, defense: Int, speed: Int, life: Int, luck: Int) {
        self.name = name
        self.attackBasePoints = attackBasePoints
        self.defense = defense
        self.speed = speed
        self.life = life
        self.luck = luck
    }
}
enum AttackType:String {
    case miss = "Miss !"
    case normal = ""
    case critical = "Critical !"
}
//Step 1: Determine the order of attack

func determineAttackOrder(_ player1: Character, _ player2: Character) -> (Character, Character) {
    return player1.speed >= player2.speed ? (player1, player2) : (player2, player1)
}

//Step 2: Determine the type of attack

func determineAttackType() -> AttackType {
    let randomNumber = Int.random(in: 0...99)
    if randomNumber < 20 {
        return .miss
    } else if randomNumber < 80 {
        return .normal
    } else {
        return .critical
    }
}

//Step 3: Calculate total attack
func calculateTotalAttack(_ character: Character, _ attackType: AttackType) -> Int {
    let constant: Int
    switch attackType {
    case .miss:
        constant = 0
    case .normal:
        constant = 1
    case .critical:
        constant = 3
    }
    return character.attackBasePoints * constant
}

//Step 4: Calculate damage
func calculateInflictedDamage(_ totalAttack: Int, _ character: Character) -> Int {
    let damage = totalAttack - character.defense
    return damage > 0 ? damage : 0
}

//Step 5: Reduce target's life
func reduceLife(_ character: inout Character, _ damage: Int) {
    character.life = max(character.life - damage, 0)
}

//Step 6: Log the results
func playRound(_ player1: Character, _ player2: Character) {
    print("Start GAME\n")
    print("Player1: \(player1.description)")
    print("Player2: \(player2.description)\n")
    
    var players = [player1, player2]
    
    var round = 1
    while players[0].life > 0 && players[1].life > 0 {
        print("\nRound \(round)")
        
        for attacker in players {
            var defender = players.first(where: { $0.name != attacker.name })!
            
            let attackType = determineAttackType()
            let attackPoints = calculateTotalAttack(attacker, attackType)
            let damage = calculateInflictedDamage(attackPoints, defender)
            reduceLife(&defender, damage)
            print("\(attackType.rawValue)")
            print("\(attacker.name) inflicts \(damage) of damage")
            print("\(defender.name) has \(defender.life) points of life left")
            
            if defender.life <= 0 {
                break
            }
        }
        round += 1
    }
    
    let winner = players.first(where: { $0.life > 0 })!
    print("\n\(winner.name) wins !!!\n")
    print("END GAME")
}

var player1 = Character(name: "Midoriya", attackBasePoints: 10, defense: 3, speed: 50, life: 35, luck: 50)
var player2 = Character(name: "Bakugo", attackBasePoints: 10, defense: 5, speed: 40, life: 50, luck: 0)
playRound(player1, player2)
