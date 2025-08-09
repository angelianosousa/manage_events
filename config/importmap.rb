# Pin npm packages by running ./bin/importmap

pin "application"
pin "jquery" # @3.7.1
pin "popper", to: 'popper.js', preload: true
pin "bootstrap", to: 'bootstrap.min.js', preload: true
pin "vanilla-nested", to: "vanilla_nested.js", preload: true
