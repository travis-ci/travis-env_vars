RSpec.describe Travis::EnvVars::Hash do
  shared_examples_for 'parses' do |desc = '', hash, expected|
    specify(desc) do
      result = Travis::EnvVars.new(hash).to_a
      expect(result).to eq expected
    end
  end

  let(:parse_error) { Travis::EnvVars::ParseError }

  it_behaves_like 'parses', 'multiple env vars', { FOO: 'foo', BAR: 'bar', BAZ: 'baz' }, [%(FOO=foo), %(BAR=bar), %(BAZ=baz)]
  it_behaves_like 'parses', 'a quoted env var', { FOO: '"foo"' }, [%(FOO="foo")]
  it_behaves_like 'parses', 'a dollar value', { FOO: '$foo' }, [%(FOO=$foo)]
  it_behaves_like 'parses', 'a secure env var', { secure: 'ABC123' }, [%(ABC123)]

  # TODO: should we care about weird cases when the input object is a hash?
  # it_behaves_like 'parses hash', { FOO: '' }, [%(FOO="")]
end
