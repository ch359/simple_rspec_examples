# A look at mocking with method stubs and object doubles

I wanted to have a resource that stepped through demonstrating the differences using super simple classes. The examples
I found online had more complexity that sometimes obscured what was going on. 

# How to use me

Have a quick look at the lib files, and then read down the spec file which has a bunch of introductory text at the top and then lots of explanatory comments throughout the tests explaining what's going on as why. 

# Notes and questions

Still a WIP. Tests 4, 5, and 8 are expected to fail to illustrate issues. 

I'm not 100% sure test 8 is failing for the right reason: I was expecting a `the Rattle class does not implement the
class method` error based on walkthroughs. Currently, the test fails with a `NoMethodError: private method 'throw' 
called on #<InstanceDouble(Rattle)`. If anyone knows whether this is expected behaviour or whether there's something
wrong with the verified double, feedback would be appreciated. 

