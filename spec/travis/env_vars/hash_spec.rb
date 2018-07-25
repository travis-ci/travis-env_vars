RSpec.describe Travis::EnvVars do
  shared_examples_for 'parses' do |hash, expected|
    specify do
      result = described_class.new(hash).to_a
      expect(result).to eq expected
    end
  end

  let(:parse_error) { Travis::EnvVars::ParseError }

  it_behaves_like 'parses', { FOO: 'foo', BAR: 'bar', BAZ: 'baz' }, [%(FOO=foo), %(BAR=bar), %(BAZ=baz)]
  it_behaves_like 'parses', { FOO: '"foo"' }, [%(FOO="foo")]
  it_behaves_like 'parses', { FOO: '$foo' }, [%(FOO=$foo)]

  # TODO: should we care about weird cases when the input object is a hash?
  # it_behaves_like 'parses hash', { FOO: '' }, [%(FOO="")]
end
