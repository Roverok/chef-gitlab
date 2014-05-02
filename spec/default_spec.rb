require 'chefspec'

describe 'gitlab::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'gitlab::default' }
  # just includes - nothing can be checked here
end
