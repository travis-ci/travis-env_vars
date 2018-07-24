RSpec.describe Travis::EnvVars do
  subject { |e| described_class.new(e.description).to_a }

  let(:parse_error) { Travis::EnvVars::ParseError }

  specify %(FOO=) do
    should eq [%(FOO=)]
  end

  specify %(FOO="") do
    should eq [%(FOO="")]
  end

  specify %(FOO=foo BAR=bar BAZ=baz) do
    should eq [%(FOO=foo), %(BAR=bar), %(BAZ=baz)]
  end

  specify %(FOO="foo foo" BAR="bar bar") do
    should eq [%(FOO="foo foo"), %(BAR="bar bar")]
  end

  specify %(FOO='foo foo' BAR='bar bar') do
    should eq [%(FOO='foo foo'), %(BAR='bar bar')]
  end

  specify %(FOO='"foo foo" foo' BAR='"bar bar" bar') do
    should eq [%(FOO='"foo foo" foo'), %(BAR='"bar bar" bar')]
  end

  specify %(FOO="'foo foo' foo" BAR="'bar bar' bar") do
    should eq [%(FOO="'foo foo' foo"), %(BAR="'bar bar' bar")]
  end

  specify 'FOO=foo\"bar' do
    should eq ['FOO=foo\"bar']
  end

  specify 'FOO="\"foo\" bar"' do
    should eq ['FOO="\"foo\" bar"']
  end

  specify 'FOO="\"\\\"foo foo\\\"\" foo"' do
    should eq ['FOO="\"\\\"foo foo\\\"\" foo"']
  end

  specify 'FOO=$bar' do
    should eq ['FOO=$bar']
  end

  specify 'FOO="$bar"' do
    should eq ['FOO="$bar"']
  end

  specify 'FOO=$(pwd)' do
    should eq ['FOO=$(pwd)']
  end

  specify 'FOO=`pwd`' do
    should eq ['FOO=`pwd`']
  end

  specify 'FOO' do
    expect { subject }.to raise_error(parse_error)
  end

  specify 'FOO="' do
    expect { subject }.to raise_error(parse_error)
  end

  specify 'FOO="\"' do
    expect { subject }.to raise_error(parse_error)
  end

  specify 'FOO="\" ' do
    expect { subject }.to raise_error(parse_error)
  end

  specify 'FOO="\" BAR=bar' do
    expect { subject }.to raise_error(parse_error)
  end

  specify 'FOO=foo"bar' do
    expect { subject }.to raise_error(parse_error)
  end
end
