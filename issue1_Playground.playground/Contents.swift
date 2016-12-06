//: Playground - noun: a place where people can play

import Foundation

// issue：計算 1~100 中奇數的總和

func calOddNumber() -> Int {
    var total = 0
    
    for i in 1...100 where i % 2 == 1 {
        total += i
    }
    
    return total
}

calOddNumber()