require 'baby'
require 'rattle' # this is only here to illustrate an un-doubled example

describe Baby do

  it 'should shake its rattle' do
    # the test file has a dependency on rattle and injects its own version (not best practice)

    rattle = Rattle.new
    baby = Baby.new(rattle) # a real rattle is injected
    expect(baby.shake_rattle).to eq("I'm a rattle being shaken")

    # this works fine, but couples the baby testing to another class, so harder to maintain
  end

  it 'should shake its rattle' do
    # this time we accept the default rattle, so could ditch the "require rattle"
    # but we're still testing the output of the rattle class (also not best practice?)

    baby = Baby.new
    expect(baby.shake_rattle).to eq("I'm a rattle being shaken")
  end

  it 'should add a fake rattle to its toy collection' do
    # this is an unverified double
    # the baby_spec file has no access to the actual Rattle class
    # we're now only testing the Baby class

    rattle = double('I am a fake rattle aka unverified double')
    baby = Baby.new(rattle) # we are injecting the fake rattle
    expect(baby.collect_rattle).to eq([rattle])

    # For the baby to collect its toys, we have no need to use any functionality
    # from the rattle class, so our fake rattle works just fine
  end

  it 'should shake its rattle (unverified double) - should fail' do
    # we can also use unverified doubles to fake real methods on the rattle class
    # as with our rattle shaking examples above

    rattle = double("I'm a fake rattle")
    # we've defined a double and given it a name
    baby = Baby.new(rattle) # inject fake rattle
    expect(baby.shake_rattle).to eq("I'm a rattle being shaken")

    # this test will fail as we haven't told our fake rattle how to
    # deal with shaking yet
  end

  it 'should shake its rattle (unverified double) - should pass' do
    # we can also use unverified doubles to fake real methods on the rattle class
    # as with our rattle shaking examples above

    rattle = double("I'm a fake rattle", shake: "I'm a rattle being shaken")
    # here we define a double, give it a name (first arg)
    # then we tell it to respond to the method :shake with a message
    baby = Baby.new(rattle) # inject fake rattle
    expect(baby.shake_rattle).to eq("I'm a rattle being shaken")

    # this test will now pass
  end

  it 'should throw its rattle (unverified double)' do
    # however, we can accidentally create doubles for methods that don't exist
    # note that there is no :throw method on the real rattle class

    rattle = double(Rattle, throw: 'it flies across the room')

    baby = Baby.new(rattle) # inject the fake rattle
    expect(baby.throw_rattle).to eq('it flies across the room')

    # this will succeed, even though it shouldn't
  end

  it 'should throw its rattle (verified double) - should fail' do
    # we can use a verified double to ensure this doesn't happen
    # only methods actually present in the doubled class are valid

    rattle = instance_double(Rattle, throw: 'it flies across the room')
    baby = Baby.new(rattle) # inject the fake rattle
    expect(baby.throw_rattle).to eq('it flies across the room')

    # this test will now fail
    # any idea why I get a NoMethodError rather than 'the Rattle class
    # does not implement the class method: throw'?
  end

  it 'should shake its rattle (verified double) - should pass' do
    # but when we use a real method, the test should pass

    rattle = instance_double(Rattle, shake: "I'm a rattle being shaken")
    baby = Baby.new(rattle) # inject fake rattle
    expect(baby.shake_rattle).to eq("I'm a rattle being shaken")
  end


end