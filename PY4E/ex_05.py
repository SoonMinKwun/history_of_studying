try :
    s_pay = input('ADD YOUR PAY ',)
    f_pay = float(s_pay)
    s_rate = input('ADD YOUR RATE ',)
    f_rate = float(s_rate)

    gross = float(f_pay)*float(f_rate)
    over_rate = float(f_rate) - 40

    if over_rate > 0 :
        gross = float(gross) + (float(over_rate)/2)*float(f_pay)

    print('YOUR GROSS IS',gross)

except :
    print('Error, please enter numeric input!')
