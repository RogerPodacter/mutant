require 'spec_helper'

describe Mutant::Mutator::Node::Generic, 'dstr' do
  before do
    Mutant::Random.stub(:hex_string => 'random')
  end

  let(:source)  { '"foo#{bar}baz"' }

  let(:mutations) do
    mutations = []
    mutations << '"random#{bar}baz"'
    mutations << '"#{nil}#{bar}baz"'
    mutations << '"foo#{bar}random"'
    mutations << '"foo#{bar}#{nil}"'
  end

  it_should_behave_like 'a mutator'
end