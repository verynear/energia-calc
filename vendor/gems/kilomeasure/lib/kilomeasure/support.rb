require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/array/extract_options'

require 'dentaku'
Dentaku.enable_ast_cache!
require 'fattr'
require 'memoizer'

require 'kilomeasure/support/boolean_attr'
require 'kilomeasure/support/object_base'
require 'kilomeasure/support/dentaku_patch'
