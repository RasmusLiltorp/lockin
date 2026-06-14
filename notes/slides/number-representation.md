# Number Representation

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/talReprSlides.pdf` (DM573, Rolf Fagerberg)

The deck explains how numbers are stored as bit patterns in a computer. It builds up from positional number systems (base 10, 7, 2, 16), shows how to convert between bases, then covers integer representation (unsigned binary and two's complement) and floating/fixed point for fractional numbers. It ends with the limits that come from using a fixed number of bits: overflow and rounding errors.

## Goal

Describe how numbers are represented as bit patterns in computers.

## Bit patterns

Information = a choice among different possibilities. The simplest case is a choice between two possibilities, called 0 and 1. One such two-way choice is a **bit**.

Two-way choices are easy to represent physically (1 = current, 0 = no current), which is why they fit computers.

More information = more bits, e.g. `01101011 0001100101011011...`. With 8 bits (= 1 byte) you get a choice among \(2^8 = 256\) possibilities.

A bit pattern means nothing on its own — it must be **interpreted**. `01101011 = ?` needs a system that says what each pattern stands for. Such systems exist for:

- Numbers (integers, fractional numbers)
- Letters
- Pixels (image file)
- Amplitude (sound file)
- Computer instruction (program)
- ...

The deck focuses on systems for integers and fractional numbers.

## Positional number systems

A number in base \(b\) is read as a weighted sum of powers of \(b\). The digit at position \(i\) (counting from 0 on the right) carries weight \(b^i\).

### Base 10 (decimal)

```
4532 = 4·1000 + 5·100 + 3·10 + 2·1
     = 4·10^3 + 5·10^2 + 3·10^1 + 2·10^0
```
- Base: 10
- Digits: 0–9 (there are 10 because \(10 \cdot 10^i = 10^{i+1}\))

### Base 7

```
4532_7 = 4·7^3 + 5·7^2 + 3·7^1 + 2·7^0
       = 4·343 + 5·49 + 3·7 + 2·1
       = 1640
```
- Base: 7
- Digits: 0–6 (because \(7 \cdot 7^i = 7^{i+1}\))

### Base 2 (binary / "total-systemet")

```
1001_2 = 1·2^3 + 0·2^2 + 0·2^1 + 1·2^0
       = 1·8 + 0·4 + 0·2 + 1·1
       = 9
```
- Base: 2
- Digits: 0, 1 (because \(2 \cdot 2^i = 2^{i+1}\))

This is the **binary number system**. It gives a natural reading of any bit pattern as a non-negative integer.

### Base 16 (hexadecimal)

```
4A3F_16 = 4·16^3 + 10·16^2 + 3·16^1 + 15·16^0
        = 4·4096 + 10·256 + 3·16 + 15·1
        = 19007
```
- Base: 16
- Digits: 0,1,2,...,9, A(=10), B(=11), ..., F(=15) (because \(16 \cdot 16^i = 16^{i+1}\))

The general rule for the digit count: in base \(b\) you use exactly \(b\) digits, and \(b \cdot b^i = b^{i+1}\) is why a carry happens after \(b\).

## Hexadecimal as shorthand for bit strings

Hex is a short way to write bit strings. Group bits into groups of 4 (each group has \(2^4 = 16\) possibilities) and replace each group with one hex digit.

The 4-bit-to-hex table:

| bits | hex | bits | hex |
|------|-----|------|-----|
| 0000 | 0   | 1000 | 8   |
| 0001 | 1   | 1001 | 9   |
| 0010 | 2   | 1010 | A   |
| 0011 | 3   | 1011 | B   |
| 0100 | 4   | 1100 | C   |
| 0101 | 5   | 1101 | D   |
| 0110 | 6   | 1110 | E   |
| 0111 | 7   | 1111 | F   |

Worked example: `0110 1010 1110 01... = 6AE...`

## Arithmetic in any base

Addition works the same in every base — just swap in the base for carrying. Subtraction, multiplication, and division also work the same way.

### Addition examples

Base 10 (carries shown on top):
```
  1111
   5432
 +96781
=102213
```

Base 2 (carries on top):
```
  111
   1110_2
 +11100_2
=101010_2
```

### Multiplication and division examples

```
1010_2 · 1110_2 = 10001100_2      (Check: 10 · 14 = 140)
1101011_2 : 101_2 = 10101_2, rem 10_2   (Check: 107 : 5 = 21, rem 2)
```

## Converting between bases

### From another base to decimal

Use the definition (weighted sum of powers).
```
1011_2 = 1·8 + 0·4 + 1·2 + 1·1 = 11
4532_7 = 4·343 + 5·49 + 3·7 + 2·1 = 1640
```

### To another base: repeated integer division

Integer division gives a quotient and a remainder, written as the equation `dividend = divisor · quotient + remainder`:

| division | quotient | remainder | as equation |
|----------|----------|-----------|-------------|
| 31 : 7   | 4        | 3         | 31 = 7·4 + 3 |
| 25 : 2   | 12       | 1         | 25 = 2·12 + 1 |

## Algorithm: convert a positive integer to binary

**Problem:** find the binary digits of a positive integer \(N\).

**Idea:** the remainder of \(N : 2\) is the lowest binary digit. Divide the quotient by 2 again to get the next digit, and so on. Digits come out right-to-left (least significant first).

```
X = N
While X > 0 repeat:
    next digit = remainder of integer division X : 2
    X = quotient of integer division X : 2
```

### Worked example: N = 25

| division | quotient | remainder |
|----------|----------|-----------|
| 25 : 2   | 12       | 1         |
| 12 : 2   | 6        | 0         |
| 6 : 2    | 3        | 0         |
| 3 : 2    | 1        | 1         |
| 1 : 2    | 0        | 1         |

Reading remainders bottom-to-top: `25 = 11001_2`.

### Why it works

Repeatedly factoring out the division equation `X = 2·quotient + remainder`:
```
25 = 2·12 + 1
   = 2(2·6 + 0) + 1
   = 2(2(2·3 + 0) + 0) + 1
   = 2(2(2(2·1 + 1) + 0) + 0) + 1
   = 2(2(2(2(2·0 + 1) + 1) + 0) + 0) + 1
   = 2^5·0 + 2^4·1 + 2^3·1 + 2^2·0 + 2^1·0 + 2^0·1
```
Expanding the nesting gives exactly the binary positional sum, so the remainders are the binary digits.

**Termination:** the last division is always `1 : 2` (quotient 0, remainder 1). \(X\) reaches 1 because integer division by 2 always makes \(X\) smaller, and you can never jump from an integer \(\ge 2\) straight to an integer \(\le 0\). The loop runs about \(\log_2 N\) times.

## Integer representation

Number representations almost always use a **fixed number of bits**, because then operations can be implemented efficiently in hardware.

\[ k \text{ bits} = 2^k \text{ different bit patterns} \]

### Unsigned (positive) integers

The binary system gives a natural representation. For \(k = 4\) the 16 patterns map to 0–15:

| bits | value | bits | value |
|------|-------|------|-------|
| 0000 | 0     | 1000 | 8     |
| 0001 | 1     | 1001 | 9     |
| 0010 | 2     | 1010 | 10    |
| 0011 | 3     | 1011 | 11    |
| 0100 | 4     | 1100 | 12    |
| 0101 | 5     | 1101 | 13    |
| 0110 | 6     | 1110 | 14    |
| 0111 | 7     | 1111 | 15    |

The open question: how do we spread \(2^k\) patterns over both negative and positive integers?

## Two's complement

One way to represent both signs. For \(k = 4\):

| bits | value | bits | value |
|------|-------|------|-------|
| 0000 | 0     | 1000 | -8    |
| 0001 | 1     | 1001 | -7    |
| 0010 | 2     | 1010 | -6    |
| 0011 | 3     | 1011 | -5    |
| 0100 | 4     | 1100 | -4    |
| 0101 | 5     | 1101 | -3    |
| 0110 | 6     | 1110 | -2    |
| 0111 | 7     | 1111 | -1    |

The patterns 0000–0111 keep their unsigned meaning (0–7); 1000–1111 mean -8 to -1.

This is called **two's complement**. It can also be described as: the highest digit counts \(-(2^{k-1})\) instead of \(+2^{k-1}\).

```
1101_2 = 1·(-(2^3)) + 1·2^2 + 0·2^1 + 1·2^0
       = 1·(-8) + 1·4 + 0·2 + 1·1
       = -3
```

### Properties of two's complement

1. **Sign is the first bit** — leading 1 means negative.
2. **Simple sign flip:** copy bits from the right up to and including the first 1-bit; invert the rest (0↔1).
   - Example: `6 = 0110 → 1010 = -6`.
3. The **ordinary addition method also works for negative numbers**. No extra logic circuits needed (saves transistors on the CPU).
4. **Subtraction = flip sign and add.** No subtraction circuit needed (saves transistors).

The slide notes that properties 1 and 4 are clear, while 2 and 3 need a proof (not part of the curriculum).

Two's complement is therefore the common choice for integers. In Java `int` is a two's complement integer with \(k = 32\). Python uses it as the base type for integers too.

## Fractional numbers (kommatal)

Same constraint: a fixed number of bits, \(2^k\) patterns. Two ideas carried over from base 10:

- **Fixed point** (45.32)
- **Floating point** (\(-6.87 \cdot 10^{-6}\))

Both transfer to base 2. Computers most often use floating point with base 2. To understand floating point you first need fixed point in base 2.

In Java: `float` (\(k = 32\)) and `double` (\(k = 64\)) are floating point. In Python `float` is the same (\(k = 64\)).

### Fixed point

Digits right of the point carry negative powers of the base.

Base 10:
```
45.32 = 4·10 + 5·1 + 3·(1/10) + 2·(1/100)
      = 4·10^1 + 5·10^0 + 3·10^-1 + 2·10^-2
```

Base 2 worked example:
```
10110.111_2 = 1·2^4 + 0·2^3 + 1·2^2 + 1·2^1 + 0·2^0
            + 1·2^-1 + 1·2^-2 + 1·2^-3
            = 16 + 0 + 4 + 2 + 0 + 1/2 + 1/4 + 1/8
            = 22 7/8
            = 22.875
```

### Floating point

Base 10 idea: move the point so it sits just after the first nonzero digit, and record sign, exponent, mantissa.

| number | sign | exponent | mantissa |
|--------|------|----------|----------|
| 2340000.0 = 2.34·10^6 | plus | 6 | 2.34 |
| 0.000456 = 4.56·10^-4 | plus | -4 | 4.56 |
| -0.0987 = -9.87·10^-2 | minus | -2 | 9.87 |

Base 2 idea: move the point so it sits just after the first nonzero digit — which in binary is **always 1**.
```
101100.0_2 = 1.011_2 · 2^5
-0.01101_2 = -1.101_2 · 2^-2
```

A fixed number of bits is assigned to each of sign, exponent, mantissa. For \(k = 8\) the deck chooses **1, 3, and 4 bits**. The exponent can be positive or negative, so it is stored in two's complement. The mantissa is padded with 0s on the right if needed.

Worked example for \(-0.01101_2\):

- Sign: `1` (1 for negative, 0 for positive)
- Exponent: `110` (= -2 in 3-bit two's complement)
- Mantissa bits: `(1.)1010` — the leading 1 is not written because it is always 1

So \(-0.01101_2\) is represented as `1 110 1010`.

## Limitations

Integers and fractional numbers are infinite sets. A fixed \(k\) bits gives only \(2^k\) patterns, so **not all numbers can be represented**. Symptoms:

- **Overflow** — e.g. `maxInt + maxInt = ?`
- **Rounding errors**
  - A large number \(x\) + a very small number \(y\) = the same large \(x\).
  - \((x + y) + z \ne x + (y + z)\) when, for example, \(x + y\) cannot be represented exactly. (Floating point addition is not associative.)

In practice problems are rare because the bit counts are large. Alternatively there are libraries for arbitrarily large integers (using a variable number of bits, at a cost in efficiency). Python does this automatically for its `int` type.
