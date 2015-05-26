## 0.2.1

* feature: add configurable defaults to checkboxes
* feature: add Ruby MRI 2.1+2.2, Rubinius 2.5 support
  discontinue Rubinius 2.1+2.2

## 0.2.0

* feature: add user input prompt with support for default values
* feature: add confirmation prompt with support for default values
* feature: render response for all prompts if desired
* improvement: hide the cursor in the list and checkbox prompts
* bugfix: fix the clear method not clearing every line on the way up

## 0.1.1

* feature: add (and verify) rubinius 2.1 + 2.2 support
* bugfix: default rendering options when invoking the module with .ask must be set
* bugfix: add utf-8 encoding hints
* bugfix: extract version information into a separate independent file

## 0.1.0

* feature: add list selection
* feature: add checkbox selection
* feature: add colors
* improvement: extract style into its own module
* improvement: implement interface for all prompts under Ask module
* improvement: moved prompt rendering to IOHelper
* improvement: separate the looping of user input out of the list and move it to the IOHelper
* improvement: separate selector from item rendering
* improvement: separate list rendering from processing
* bugfix: don't do anything if checkbox has no items
* bugfix: don't render the list if there is no item in it
* bugfix: create the Inquirer module first, before including any of its implementations
* bugfix: make simple checkbox selected colored
* bugfix: select checkbox items based on space keypress

