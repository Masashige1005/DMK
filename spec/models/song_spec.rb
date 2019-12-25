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