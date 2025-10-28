# Write a program to calculate the credit card balance after one year 
# if a person only pays the minimum monthly payment required by the 
# credit card company each month.

import std/[math, syncio]

let
   annualInterestRate = 0.2 # annual interest rate as a decimal
   monthlyPaymentRate = 0.04 # minimum monthly payment rate as a decimal
   monthlyInterestRate = annualInterestRate / 12.0

# the outstanding balance on the credit card
var balance = 42.0

for i in 1 .. 12:
   let minimumPayment = monthlyPaymentRate * balance
   let unpaidBalance = balance - minimumPayment
   let interest = monthlyInterestRate * unpaidBalance
   balance = unpaidBalance + interest
   echo "Month ", i, " Remaining balance: ", round(balance, 2)

echo "Remaining balance: ", round(balance, 2)
