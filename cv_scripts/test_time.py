import datetime
import time
start = datetime.datetime.now()
 
'''
some elegant, complex code that takes a non-trivial amount of
time to run, and you're trying to optimize it
'''
time.sleep(2)
 
end = datetime.datetime.now()
#print start-end
print(f"Closest black cross centroid: {end.second-start.second+2} | ")