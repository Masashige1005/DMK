require 'rails_helper'

RSpec.describe Song, type: :model do
  context "保存できる場合" do
    it "user_idを入れて保存" do
      user = FactoryBot.create(:user)
      expect(FactoryBot.create(:song, user_id: user.id)).to be_valid
    end
  end
  context "保存できない場合" do
    it "user_idを保存していない" do
      expect(FactoryBot.build(:song)).to_not be_valid
    end
    it "nameが空欄" do
      expect(FactoryBot.build(:song, :no_name)).to_not be_valid
    end
    it "descriptionが空欄" do
      expect(FactoryBot.build(:song, :no_description)).to_not be_valid
    end
    it "descriptionが301文字以上" do
      expect(FactoryBot.build(:song, :too_long_description)).to_not be_valid
    end
    it "imageがない場合" do
      expect(FactoryBot.build(:song, :no_image)).to_not be_valid
    end
    it "lylics_urlがない場合" do
      expect(FactoryBot.build(:song, :no_lylics_url)).to_not be_valid
    end
    it "track_urlがない場合" do
      expect(FactoryBot.build(:song, :no_track_url)).to_not be_valid
    end
    it "artist_urlがない場合" do
      expect(FactoryBot.build(:song, :no_artist_url)).to_not be_valid
    end
  end

  before do
    @user1 = FactoryBot.create(:user, :create_with_songs)
    @user2 = FactoryBot.create(:user, :create_with_songs)
  end
  feature "ログインしていない状態で" do
    feature "以下のページへアクセスした際のリダイレクト先の確認" do
      scenario "songsの一覧ページ" do
        visit songs_path
        expect(page).to have_current_path new_user_session_path
      end

      scenario "songの詳細ページ" do
        visit song_path(@user1.songs.first)
        expect(page).to have_current_path new_user_session_path
      end

      scenario "songの編集ページ" do
        visit edit_song_path(@user1.songs.first)
        expect(page).to have_current_path new_user_session_path
      end
    end
  end

  feature "ログインした状態で" do
    before do
      login(@user1)
    end
    feature "表示内容とリンクの確認" do
      scenario "songの一覧ページの表示内容とリンクは正しいか" do
        visit books_path
        books = Book.all
        books.each do |book|
          expect(page).to have_link book.title,href: song_path(song)
          expect(page).to have_content song.description
        end
        expect(page).to have_link "",href: user_path(@user1)
        expect(page).to have_content @user1.name
        expect(page).to have_content @user1.introduction
      end

      scenario "自分のsongの詳細ページでの表示内容とリンクは正しいか" do
        book = @user1.books.first
        visit book_path(book)
        expect(page).to have_content song.name
        expect(page).to have_content song.description
        expect(page).to have_link "",href: edit_song_path(song)
        expect(all("a[data-method='delete']")[-1][:href]).to eq(song_path(@user1.songs.first)) #削除ボタンがあることの確認
        expect(page).to have_link @user1.name,href: user_path(@user1)
        expect(page).to have_link "",href: edit_user_path(@user1)
        expect(page).to have_content @user1.name
      end

      scenario "他人のsongの詳細ページでの表示内容とリンクは正しいか" do
        book = @user2.songs.first
        visit song_path(song)
        expect(page).to have_content song.name
        expect(page).to have_content song.description
        expect(page).to_not have_link "",href: edit_song_path(song)
        expect(all("a[data-method='delete']")[-1][:href]).to_not eq(song_path(@user1.songs.first)) #削除ボタンがないことの確認
        expect(page).to have_link @user2.name,href: user_path(@user2)
        expect(page).to have_content @user2.name
      end
    end

    feature "song投稿ページからsongを投稿" do
      before do
        visit books_path
        find_field('song[name]').set("name_a")
        find_field('song[description]').set("description_b")
      end
      scenario "正しく保存できているか" do
        expect {
          find("input[name='commit']").click
        }.to change(@user1.songs, :count).by(1)
      end
    end

    feature "有効ではない内容のbookを投稿" do
      before do
        visit user_path(@user1)
        find("input[name='book[title]']").set("title_e")
      end
      scenario "保存されないか" do
        expect {
          find("input[name='commit']").click
        }.to change(@user1.songs, :count).by(0)
      end
      scenario "リダイレクト先は正しいか" do
        find("input[name='commit']").click
        expect(page).to have_current_path song_path(song)
      end
    end

    feature "自分が投稿したsongの更新" do
      before do
        book = @user1.songs.first
        visit edit_book_path(book)
        find_field('song[description]').set('update_description_a')
        find("input[name='commit']").click
      end
      scenario "songが更新されているか" do
        expect(page).to have_content "update_description_a"
      end
      scenario "リダイレクト先は正しいか" do
        expect(page).to have_current_path song_path(@user1.songs.first)
      end
    end

    feature "他人が投稿したsongの更新" do
      scenario "編集ページへアクセスできず、song一覧ページにリダイレクトされるか" do
        visit edit_book_path(@user2.songs.first)
        expect(page).to have_current_path songs_path
      end
    end

    feature "有効ではない内容のbookの更新" do
      before do
        book = @user1.books.first
        visit edit_song_path(book)
        find_field('book[description]').set(nil)
        find("input[name='commit']").click
      end
      scenario "リダイレクト先は正しいか" do
        expect(page).to have_current_path song_path(@user1.songs.first)
      end
    end

    feature "songの削除" do
      before do
        book = @user1.songs.first
        visit song_path(song)
      end
      scenario "songが削除されているか" do
        expect {
          all("a[data-method='delete']").select{|n| n[:href] == song_path(@user1.songs.first)}[0].click
        }.to change(@user1.songs, :count).by(-1)
      end
      scenario "リダイレクト先が正しいか" do
        all("a[data-method='delete']").select{|n| n[:href] == song_path(@user1.songs.first)}[0].click
        expect(page).to have_current_path songs_path
      end
    end
  end
end
