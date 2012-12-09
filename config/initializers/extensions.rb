require 'extensions/this_method_name'
require 'extensions/active_record_errors'
require 'extensions/acts_as_reviewed'
require 'extensions/accepts_duplicate_ids'
require 'extensions/nil_class_extensions'
require 'extensions/object_add_ivar'
require 'extensions/file_store_find'
require 'extensions/recaptcha_fix'

Kernel.module_eval do
  include ThisMethodName
end