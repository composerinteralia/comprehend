class C
  def self.[](*args)
    C.new(*args)
  end

  def initialize(*enumerables, mapper)
    @enumerables = enumerables.map(&:to_enum)
    @mapper = mapper
  end

  def method_missing(name, *args, &prc)
    if (duped = dup).result.respond_to?(name)
      duped.result = duped.result.send(name, *args, &prc)
      duped.result.respond_to?(:to_a) ? duped : duped.result
    elsif (arr = to_a).respond_to?(name)
      arr.send(name, *args, &prc)
    else
      super(name, *args, &prc)
    end
  end

  def [](i)
    take(i + 1).to_a.last
  end

  def ==(other)
    return false unless other.respond_to?(:to_a)
    to_a == other.to_a
  end

  def dup
    self.class[*enumerables.map(&:rewind), mapper].tap { |d| d.result = result }
  end

  def inspect
    "#<C:#{"0x%x" % object_id}: #{result}>"
  end

  def to_a
    @to_a ||= result.to_a
  end

  def to_s
    to_a.to_s
  end

  protected
  attr_writer :result

  def result
    @result ||= Enumerator.new { |yielder| yield_values(yielder) }.lazy
  end

  private
  attr_reader :enumerables, :mapper

  def yield_values(yielder)
    depth = 0
    values = []

    begin
      while true
        values[depth] = enumerables[depth].next

        if depth == enumerables.length - 1
          yielder << mapper.(*values)
        else
          depth += 1
        end
      end
    rescue StopIteration
      if depth > 0
        enumerables[depth].rewind
        depth -= 1
        retry
      end
    end
  end
end
