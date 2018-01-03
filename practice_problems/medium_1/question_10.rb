#The return value of foo will always be "yes", as that is the only line in the
#method definition, and therefore the last line, and therefore the return
#value, regardless of the parameter passed to it (since there is none, the
#parameter takes the defaule value of "no").
#Since foo's return value was "yes", "yes" is passed to bar as its parameter,
#so foo's default parameter is ignored. Since "yes" is not "no", the second
#expression is evaluated in line 6, giving param the value of "no". Since this
#is the last line of bar, the return value will be "no".
