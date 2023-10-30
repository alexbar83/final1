require 'sphinx_helper'

feature 'Search' do
  given!(:user) { create(:user, email: 'test@test.com') }
  given!(:question) { create(:question, body: 'search', user: user) }
  given!(:answer) { create :answer,body: 'search', question: question, user: user }
  given!(:comment) { create(:comment, commentable: question, body: 'search', user: user) }

  scenario 'Questions search', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.search' do
        fill_in 'search_text', with: 'search*'
        select 'Question', from: 'search_object'
        click_on 'Search'
      end

      within '.search_results' do
        expect(page).to have_content(question.title)
      end      
    end
  end

  scenario 'Answers search', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.search' do
        fill_in 'search_text', with: 'search*'
        select 'Answer', from: 'search_object'
        click_on 'Search'
      end

      within '.search_results' do
        expect(page).to have_content(answer.body)
      end      
    end
  end

  scenario 'Users search', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.search' do
        fill_in 'search_text', with: 'search*'
        select 'User', from: 'search_object'
        click_on 'Search'
      end

      within '.search_results' do
        expect(page).to have_content(user.email)
      end      
    end
  end

  scenario 'Comments search', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.search' do
        fill_in 'search_text', with: 'search*'
        select 'Comment', from: 'search_object'
        click_on 'Search'
      end

      within '.search_results' do
        expect(page).to have_content(comment.body)
      end      
    end
  end

  scenario 'general search', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      within '.search' do
        fill_in 'search_text', with: 'search*'
        select 'All', from: 'search_object'
        click_on 'Search'
      end

      within '.search_results' do
        expect(page).to have_content(question.title)
        expect(page).to have_content(answer.body)
        expect(page).to have_content(comment.body)
        expect(page).to have_content(user.email)
      end      
    end
  end
end 
