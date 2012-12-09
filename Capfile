load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
Dir['config/recipes/*.rb'].each { |recipe| load(recipe) }

load 'config/deploy' # remove this line to skip loading any of the default tasks