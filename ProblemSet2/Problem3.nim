# Needed for pow, round
import std/[math, syncio]

let
   annualInterestRate = 0.18 # annual interest rate as a decimal
   monthlyInterestRate = annualInterestRate / 12.0
   balance = 999999.0 # the outstanding balance on the credit card

var
   lowerBound = balance / 12.0
   upperBound = (balance * pow(1 + monthlyInterestRate, 12)) / 12.0
   minimumPayment = (lowerBound + upperBound) / 2.0

while true:
   var testBalance = balance

   for i in 1 .. 12:
      let unpaidBalance = testBalance - minimumPayment
      let interest = monthlyInterestRate * unpaidBalance
      testBalance = unpaidBalance + interest

   let v = round(testBalance, 2)
   if v > 0.0:
      lowerBound = minimumPayment
   elif v < 0.0:
      upperBound = minimumPayment
   else:
      break
   minimumPayment = (lowerBound + upperBound) / 2.0

echo "Lowest Payment: ", round(minimumPayment, 2)
