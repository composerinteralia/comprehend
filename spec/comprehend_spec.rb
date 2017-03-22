require 'comprehend'

describe C do
  let(:∞) { Float::INFINITY }

  describe '#[]' do
    it 'returns the element at the given index' do
      list = C[[1, 2], [3, 2], -> (a, b) { a + b }]
      expect(list[0]).to eq(4)
      expect(list[1]).to eq(3)
      expect(list[2]).to eq(5)
      expect(list[3]).to eq(4)
    end
  end

  it 'handles infinite lists' do
    list = C[(1..∞), -> (a) { a }]
    expect(list.take(5)).to eq([1, 2, 3, 4, 5])
  end

  it 'handles multiple lists' do
    list = C[[2, 1], [1, 2], -> (a, b) { (a * b) }]
    expect(list.to_a).to eq([2, 4, 1, 2])
  end

  it 'is chainable' do
    list = C[(1..∞), -> (a) { a }]
    chained = list.reject(&:even?).map { |a| a * 7 }
    expect(chained.take(5).to_a).to eq([7, 21, 35, 49, 63])
  end
end
