# frozen_string_literal: true

RSpec.describe UseCase do
  subject(:use_case) do
    use_case_class.new
  end

  let(:use_case_class) { Class.new { include UseCase } }
  let(:errors) { ['some error'] }

  describe '#perform' do
    it 'raises' do
      expect { use_case_class.perform }
        .to raise_error(NotImplementedError)
    end
  end

  describe '.perform' do
    it 'raises' do
      expect { use_case.perform }
        .to raise_error(NotImplementedError)
    end
  end

  describe '.success' do
    it 'false when errors present' do
      use_case.instance_variable_set(:@errors, errors)
      expect(use_case.success?).to be false
    end

    it 'true when errors absent' do
      use_case.instance_variable_set(:@errors, [])
      expect(use_case.success?).to be true
    end
  end

  describe '.errors?' do
    it 'true when errors present' do
      use_case.instance_variable_set(:@errors, errors)
      expect(use_case.errors?).to be true
    end

    it 'false when errors nil' do
      use_case.instance_variable_set(:@errors, nil)
      expect(use_case.errors?).to be false
    end

    it 'false when errors empty' do
      use_case.instance_variable_set(:@errors, [])
      expect(use_case.errors?).to be false
    end
  end

  describe '.errors' do
    it 'returns when present' do
      use_case.instance_variable_set(:@errors, errors)
      expect(use_case.errors).to eq errors
    end

    it 'empty array when no errors' do
      use_case.instance_variable_set(:@errors, nil)
      expect(use_case.errors).to eq []
    end
  end

  describe '.errors=' do
    it 'overwrites @errors' do
      use_case.instance_variable_set(:@errors, nil)
      use_case.errors = errors
      expect(use_case.errors).to eq errors
    end
  end

  describe '.save_error' do
    let(:new_error) { 'New Error Message' }

    it 'adds error' do
      use_case.errors = errors
      use_case.save_error(new_error)
      expect(use_case.errors.size).to eq 2
      expect(use_case.errors.last).to eq new_error
    end
  end

  describe '.save_errors=' do
    let(:new_errors) { ['New Error Message'] }

    it 'adds error' do
      use_case.errors = errors
      use_case.save_errors(new_errors)
      expect(use_case.errors.size).to eq 2
      expect(use_case.errors.last).to eq new_errors.last
    end

    it 'exits if errors parameters are empty' do
      use_case.instance_variable_set(:@errors, nil)
      use_case.save_errors([])
      expect(use_case.errors).to be_empty
    end
  end
end
