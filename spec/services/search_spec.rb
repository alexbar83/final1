require 'rails_helper'

RSpec.describe 'Search class' do
  describe '#search_results' do
    let!(:search_text) { 'text text text' }

    %w(Questions Answers Comments Users).each do |search_object|
      it "returns result of #{search_object}" do
        expect(search_object.classify.constantize).to receive(:search).with(search_text)
        Search.search_results(search_text, search_object)
      end
    end

    it 'returns all result' do
      expect(ThinkingSphinx).to receive(:search).with(search_text)
      Search.search_results(search_text, 'All')
    end
  end 
  