require 'baby'
require 'rattle' # this is only here to illustrate examples 1 and 2, more below

# A note on terminology. It's not as complicated as it first appears:
# Everytime you've written an `expect(x).to y` statement you've created a mock.
# When you write `allow(x).to receive(y)` you're doing a (partial?) stub
# When you write `allow(x).to receive(y).and_return(z)`, that's a stub
# All of the above can be applied to real objects, but also fake ones (doubles)
# If you replace `x = Object.new` with `x = double('Object'), you've made a double.
# Use stubs to give it any functionality needed.

# The examples below illustrate these principles and the comments show what's
# going on and whether the test is expected to pass or fail.

# Note: my current understanding is that doubles should not be used for feature
# tests since, by definition, they need to replicate the use of the actual program.
# So a feature test file would be using the actual rattle (as in e.g. 2)
# Your unit tests can go nuts with doubles


describe Baby do

  context "Testing a hard dependency" do

    it '(1) should shake its rattle' do
      # the test file has a dependency on rattle and injects its own version (not best practice)

      rattle = Rattle.new
      baby = Baby.new(rattle) # a real rattle is injected
      expect(baby.shake_rattle).to eq("I'm a rattle being shaken")

      # this works fine, but couples the baby testing to another class, so harder to maintain
    end

    it '(2) should shake its rattle' do
      # this time we accept the default rattle, so could ditch the "require rattle" at the top
      # but we're still testing the output of the rattle class (maybe also not best practice?)

      # NB: The 'require rattle' is not actually required for either example in this case, as Baby creates its own.
      # But if Baby didn't do this, the 'require' would be needed, so I've left it in for illustrative purposes.

      baby = Baby.new
      expect(baby.shake_rattle).to eq("I'm a rattle being shaken")
    end

  end

  context "Introducing unverified doubles" do

    it '(3) should add a fake rattle to its toy collection' do
      # this is an unverified double
      # the baby_spec file has no access to the actual Rattle class
      # we're now only testing the Baby class

      rattle = double('I am a fake rattle aka unverified double')
      baby = Baby.new(rattle) # we are injecting the fake rattle
      expect(baby.collect_rattle).to eq([rattle])

      # For the baby to collect its toys, we have no need to use any functionality
      # from the rattle class, so our fake rattle works just fine
    end

    it '(4) should shake its rattle (unverified double) - should fail' do
      # we can also use unverified doubles to fake real methods on the rattle class
      # as with our rattle shaking examples above

      rattle = double("I'm a fake rattle")
      # we've defined a double and given it a name
      baby = Baby.new(rattle) # inject fake rattle
      expect(baby.shake_rattle).to eq("I'm a rattle being shaken")

      # this test will fail as we haven't told our fake rattle how to
      # deal with shaking yet
    end

    it '(5) should shake its rattle (unverified double) - should fail' do
      # we can also use unverified doubles to stub real methods on the rattle class
      # as with our rattle shaking examples above

      rattle = double("I'm a fake rattle")
      allow(rattle).to receive(:shake)

      # here we define a double, give it a name (1st arg)
      # then we tell it to expect a method call to :shake

      baby = Baby.new(rattle) # inject fake rattle
      expect(baby.shake_rattle).to eq("I'm a rattle being shaken")

      # this test will now recognise the method being called
      # but will still fail because no response is given
    end

    it '(6) should shake its rattle (unverified double) - should pass' do
      # we can also use unverified doubles to stub real methods on the rattle class
      # as with our rattle shaking examples above

      rattle = double("I'm a fake rattle")
      allow(rattle).to receive(:shake).and_return("I'm a rattle being shaken")

      # here we define a double, give it a name (1st arg)
      # then we tell it to respond to the method :shake with a message (2nd arg)

      baby = Baby.new(rattle) # inject fake rattle
      expect(baby.shake_rattle).to eq("I'm a rattle being shaken")

      # this test will now pass as method is recognised and response is correct
      # our test now checks whether `Baby.shake_rattle` calls `Rattle.shake` as intended
      # our test doesn't care what happens inside the Rattle class however
    end

    it '(7) should throw its rattle (unverified double)' do
      # however, we can accidentally create doubles for methods that don't exist
      # note that there is no :throw method on the real rattle class

      rattle = double(Rattle, throw: 'it flies across the room')
      # nb: I think this syntax is the same as a separate stub
      # i.e. `rattle = double(Rattle)`, `allow(rattle).to receive(:throw).and_
      # return('It flies across the room')`

      baby = Baby.new(rattle) # inject the fake rattle
      expect(baby.throw_rattle).to eq('it flies across the room')

      # this will succeed, even though it shouldn't
    end

  end

  context "Testing verified doubles" do

    it '(8) should throw its rattle (verified double) - should fail' do
      # we can use a verified double to ensure this doesn't happen
      # only methods actually present in the doubled class are valid


      rattle = instance_double(Rattle)
      allow(rattle).to receive(:throw).and_return('it flies across the room')
      baby = Baby.new(rattle) # inject the fake rattle
      expect(baby.throw_rattle).to eq('it flies across the room')

      # this test will now fail, as the verified double checks whether the method
      # exists in the Rattle class

      # ** any idea why I get a NoMethodError rather than 'the Rattle class
      # does not implement the class method: throw' I was expecting
      # from walkthroughs?**
    end

    it '(9) should shake its rattle (verified double) - should pass' do
      # but when we use a real method, the test should pass

      rattle = instance_double(Rattle, shake: "I'm a rattle being shaken")
      baby = Baby.new(rattle) # inject fake rattle
      expect(baby.shake_rattle).to eq("I'm a rattle being shaken")
    end
  end

end