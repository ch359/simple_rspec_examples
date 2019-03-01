require 'rattle'

class Baby

  def initialize(rattle = Rattle.new)
    @rattle = rattle
    @toys = []
  end

  def shake_rattle
    @rattle.shake
  end

  def throw_rattle
    @rattle.throw_rattle
  end

  def collect_rattle
    @toys.push(@rattle)
  end

end