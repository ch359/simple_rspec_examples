# A look at mocking with method stubs and object doubles

I wanted to have a resource that stepped through demonstrating the differences using super simple classes. The examples
I found online had more complexity that sometimes obscured what was going on. 

Still a WIP. Tests 4, 5, and 8 are expected to fail to illustrate issues. 

I'm not 100% sure test 8 is failing for the right reason: I was expecting a `the Rattle class does not implement the
class method` error based on walkthroughs. Currently, the test fails with a `NoMethodError: private method 'throw' 
called on #<InstanceDouble(Rattle)`. If anyone knows whether this is expected behaviour or whether there's something
wrong with the verified double, feedback would be appreciated. 
