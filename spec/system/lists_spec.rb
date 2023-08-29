# frozen_string_literal: true

require 'rails_helper'

describe '投稿のテスト' do
  let!(:list) { create(:list,title:'hoge',body:'hogege') }
  describe 'トップ画面のテスト' do
    before do
      visit top_path
    end
    context '表示の確認' do
      it 'トップ画面に「ここはTOPページです」が表示されるか' do
        expect(page).to have_content 'ここはTOPページです'
      end
      it 'top_pathが「/top」か' do
        expect(current_path).to eq('/top')
      end
    end
  end

  describe '投稿画面のテスト' do
    before do
      visit new_list_path
    end
    context '表示の確認' do
      it 'new_list_pathが「/lists/new」か' do
        expect(current_path).to eq('/lists/new')
      end
      it '投稿ボタンが表示されているか' do
        expect(page).to have_button '投稿'
      end
    end
    context '投稿処理のテスト' do
      it 'リダイレクト先は正しいか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:10)
        fill_in 'list[body]', with: Faker::Lorem.characters(number:30)
        click_button '投稿'
        expect(page).to have_current_path list_path(List.last)
      end
    end
  end

  describe '一覧画面のテスト' do
    before do
      visit lists_path
    end
    context '一覧の表示とリンクの確認' do
      it '一覧画面に投稿されたものが表示されているか' do
        # List.all.each_with_index do |list|
          expect(page).to have_content list.title
          expect(page).to have_content list.body
        # end
      end
    end
  end

  describe '詳細画面のテスト' do
    before do
      visit list_path(list)
    end
    context '表示の確認' do
      it '削除リンクが表示されるか' do
        # destroy_link = find_all('a')[1]
        # expect(destroy_link.native.inner_text).to match(/destroy/i)
        expect(page).to have_link '削除'
      end
      it '編集リンクが表示されるか' do
        # edit_link = find_all('a')[0]
        # expect(edit_link.native.inner_text).to match(/edit/i)
        expect(page).to have_link '編集'
      end
      context 'リンクの遷移先の確認' do
        it '編集の遷移先は編集画面か' do
          edit_link = find_all('a')[3]
          edit_link.click
          expect(current_path).to eq('/lists/' + list.id.to_s + '/edit')
        end
      end
      context 'listの削除のテスト' do
        it 'listの削除' do
          expect{ list.destroy }.to change{ List.count }.by(-1)
        end
      end
    end
  end

  describe '編集画面のテスト' do
    before do
      visit edit_list_path(list)
    end
    context '表示の確認' do
      it '編集前のタイトルと本文がフォームに表示されるか' do
        expect(page).to have_field 'list/title', with: list.title
        expect(page).to have_field 'list/body', with: list.body
      end
      it '保存ボタンが表示されるか' do
        expect(page).to have_button '保存'
      end
    end
    context '更新処理に関するテスト' do
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:10)
        fill_in 'list[body]', with: Faker::Lorem.characters(number:30)
        click_button '保存'
        expect(page).to have_current_path list_path(list)
      end
    end
  end
end