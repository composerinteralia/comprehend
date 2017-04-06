# Comprehend

Saddened by Ruby's lack of list comprehensions, I built a lazy comprehendy thing.

```rb
∞ = Float::INFINITY

C[[1, 0], 1..5, -> (a, b) { a + b }] # => [2, 3, 4, 5, 6, 1, 2, 3, 4, 5]

C[(1..∞), -> (a) { a * 2 }].take(5) # => [2, 4, 6, 8, 10]

C[(1..∞), -> (a) { a }].reject(&:odd?).take(5) # => [2, 4, 6, 8, 10]
```
