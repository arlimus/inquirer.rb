# inquirer.rb

[![Build Status](https://travis-ci.org/arlimus/inquirer.rb.png)](https://travis-ci.org/arlimus/inquirer.rb)

Interactive user prompts on CLI for ruby.

## Prompt types

### List

```ruby
idx = Ask.list "Look behind you...", [
  "a three-headed monkey!",
  "a pink pony",
  "Godzilla"
]
# idx is the selected index
```

![List example](example/list.png)

### Checkbox

```ruby
idx = Ask.checkbox "Monkey see, monkey...", [
  "don't",
  "eats Banana",
  "do"
]
# idx is an array containing the selections
```

![Checkbox example](example/checkbox.png)

### Input

```ruby
name = Ask.input "What's your name"
phone = Ask.input "What's your phone number"
# name and phone are the responses for each question
```

![Input example](example/input.png)

### Confirm

```ruby
value = Ask.confirm "Are you sure?"
# value is a boolean
```

![Input example](example/confirm.png)

## Options

### Method parameters

- question: `string` The text to your are going to ask
- elements: `array` Array of options to show. Only for `checkbox` and `list` types.

### Rendering options

You can pass this options as the lastest parameter

- clear: `bool` [Default true] Clear the original question after pressing enter
- response: `bool` [Default true] Whether to show the selected response

```ruby
# If you dont want any output use
Ask.input "What's your name", response: false

# If you don't want the response and you want to keep the question prompt
Ask.input "What's your name", clear: false, response: false
```

## Installation

    gem install inquirer

## Compatibility

|      Ruby      | Linux | OS X | Windows |
|----------------|:-----:|:----:|:-------:|
| MRI 1.9.3      | ✔     | ✔    | ✘       |
| MRI 2.0.0      | ✔     | ✔    | ✘       |
| Rubinius 2.1.1 | ✔     | ✔    | ✘       |
| Rubinius 2.2.1 | ✔     | ✔    | ✘       |
| JRuby 1.7.x    | ✘     | ✘    | ✘       |

## Contributors

**Thank you for contributing!**

* ![blackjid](https://avatars1.githubusercontent.com/u/228037?s=16) [blackjid](https://github.com/blackjid)

## Credit

This is basically the wonderful [Inquirer.js](https://github.com/SBoudrias/Inquirer.js), just done for ruby. I was unable to find a good gem to handle user interaction in ruby as well as this module does in JS.

## License

Apache v2
Author: Dominik Richter
