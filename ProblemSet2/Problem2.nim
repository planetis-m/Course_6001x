# Write a program that calculates the minimum fixed monthly payment 
# needed in order pay off a credit card balance within 12 months. 
# By a fixed monthly payment, we mean a single number which does 
# not change each month, but instead is a constant amount that 
# will be paid each month.

# Needed for round
import math

let
    annualInterestRate = 0.2 # annual interest rate as a decimal
    monthlyInterestRate = annualInterestRate / 12.0
    balance = 3329.0 # the outstanding balance on the credit card

var
    minimumPayment = 10.0
    found = false # Used to exit the while loop

while not found:
    var testBalance = balance

    for i in 0 .. <12:
        let unpaidBalance = testBalance - minimumPayment
        let interest = monthlyInterestRate * unpaidBalance
        testBalance = unpaidBalance + interest

    if testBalance <= 0.0:
        found = true
    else:
        minimumPayment += 10.0

echo "Lowest Payment: ", minimumPayment
