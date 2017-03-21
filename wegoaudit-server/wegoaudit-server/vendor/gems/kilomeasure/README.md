# What is it?

A gem for applying formulas to inputted sets of data, in order to calculate the
potential savings from undertaking a "measure" (some form of building retrofit
or subsystem improvement/replacement/new installation). For a given measure and
set of inputs the gem calculates a value that can be used to calculate savings
(by running calculations for before and after states and getting the
difference).

## Interface

```ruby
kilomeasure.load
measure = kilomeasure.get_measure('lighting')

before_inputs = {
  run_hours_per_week: 100,
  total_number_of_fixtures: 1,
  watts_per_lamp: 80,
  lamps_per_fixture: 3
}

after_inputs = before_inputs.merge(watts_per_lamp: 40)

calculations_set = measure.run_retrofit_calculations(
  before_inputs: before_inputs,
  after_inputs: after_inputs)

# ((100 * 1 * 80 * 3) / 7) * 365 => 1_251_428.57
# ((100 * 1 * 40 * 3) / 7) * 365 => 625_714.29
calculations_set[:annual_electric_savings].value.round(2) # => 625_714.29
```

## Data storage formats

The rules and formulas used to calculate values are stored in YAML files under
[data/](data/). The name of the file is used to retrieve each set of data (e.g.
`dhw_replacement_measure` for `data/measures/dhw_replacement_measure.yml`).

### Measures

Measures are located in [data/measures](data/measures/).

Here is an annotated example of a measure file:

``` yaml
# valid options for each field (for documentation purposes only atm)
options:
  type_of_bulk:
    - incandescent
    - led

# fields that are expected to be passed in
inputs:
  # List fields grouped by structure
  measure:
    - electricity_kwh_cost
  lighting:
    - run_hours_per_week
    - total_number_of_fixtures
    - lamps_per_fixture
    - type_of_bulb
    - cost_per_bulb

# Default values will be used if the field is not passed
defaults: 
  run_hours_per_week: 20
  type_of_bulb:
    existing: incandescent
    proposed: led

# A lookup is just a case statement that looks at the value of a passed-in
# field and returns another value or expression. 
lookups:
  watts_per_lamp:
    input_name: type_of_bulb
    lookup:
      incandescent: 80
      led: 15

# Formulas are expressions that refer to each other. They must not contain
a circular reference and the names must refer to either another formula or an
# input.
#  
# Formulas have access to some constant names, like `pi` and various
# conversions like `kw_kwh_conversion`. They also have access to a `proposed`
# name which defaults to false and that can be used to switch logic inside
# formulas.
formulas:
  base_kw:
    'total_number_of_fixtures * watts_per_lamp * lamps_per_fixture'
  kwh_per_week:
    'base_kw * run_hours_per_week'
  kwh_per_day:
    'kwh_per_week / 7'
  annual_electric_usage: 
    'kwh_per_day * 365'
  cost_of_measure:
    'cost_per_bulb * total_number_of_fixtures'
```
