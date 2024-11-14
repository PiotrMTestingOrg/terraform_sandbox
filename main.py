import os

# os.environ['test_user'] = 'abc'

USER = os.environ['TEST_USER']

a = 2
b = 5
print("The result of the script is", a+b, "and will be used for", USER)