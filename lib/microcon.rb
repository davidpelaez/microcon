require 'dry-monads'
require 'rack/request'
require 'oj'
require 'transproc'
require 'dry-container'
require 'adts'

require 'microcon/functions'
require 'microcon/request'
require 'microcon/response'
require 'microcon/contextualizer'
require 'microcon/result_types'
require 'microcon/result_handlers'
require 'microcon/controller'

Oj.default_options = { symbol_keys: true, indent: 2,
  mode: :compat, bigdecimal_as_decimal: true,
  quirks_mode: false }
