# frozen_string_literal: true

RSpec.describe RuboCop::ExceptionMessages::Plugin do
  subject(:plugin) { described_class.new }

  describe '#about' do
    it 'returns metadata about the plugin' do
      about = plugin.about

      expect(about.name).to eq('rubocop-exception_messages')
      expect(about.version).to eq(RuboCop::ExceptionMessages::VERSION)
      expect(about.homepage).to eq('https://github.com/dblock/rubocop-exception_messages')
    end
  end

  describe '#supported?' do
    it 'supports the rubocop engine' do
      context = instance_double(LintRoller::Context, engine: :rubocop)

      expect(plugin.supported?(context)).to be(true)
    end

    it 'does not support other engines' do
      context = instance_double(LintRoller::Context, engine: :standard)

      expect(plugin.supported?(context)).to be(false)
    end
  end

  describe '#rules' do
    it 'returns rules pointing at the default config' do
      rules = plugin.rules(nil)

      expect(rules.type).to eq(:path)
      expect(rules.config_format).to eq(:rubocop)
      expect(rules.value.to_s).to end_with('config/default.yml')
    end
  end
end
